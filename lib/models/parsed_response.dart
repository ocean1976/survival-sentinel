/// AI yanıtlarını parse edip yapılandırılmış bloklara dönüştürür.
///
/// Desteklenen marker'lar (CLAUDE.md §2.3):
///   ▲ ACİL      — acil eylem bloğu (kırmızı kutu)
///   » PROTOKOL  — numaralı adımlar (yeşil başlık)
///   ◆ KRİTİK    — uyarılar (— ile başlayan satırlar, amber başlık)
///
/// Ayrıca `## ACİL EYLEM` gibi markdown heading formatını da algılar
/// (skill dosyalarındaki mevcut yapıyla uyumlu kalmak için).
library;

enum BlockKind { urgent, protocol, critical, plain }

abstract class ResponseBlock {
  const ResponseBlock();
  BlockKind get kind;
}

class UrgentBlock extends ResponseBlock {
  final String text;
  const UrgentBlock(this.text);
  @override
  BlockKind get kind => BlockKind.urgent;
}

class ProtocolBlock extends ResponseBlock {
  final List<String> steps;
  const ProtocolBlock(this.steps);
  @override
  BlockKind get kind => BlockKind.protocol;
}

class CriticalBlock extends ResponseBlock {
  final List<String> warnings;
  const CriticalBlock(this.warnings);
  @override
  BlockKind get kind => BlockKind.critical;
}

class PlainBlock extends ResponseBlock {
  final String text;
  const PlainBlock(this.text);
  @override
  BlockKind get kind => BlockKind.plain;
}

class ParsedResponse {
  final List<ResponseBlock> blocks;
  const ParsedResponse(this.blocks);

  bool get hasStructure =>
      blocks.any((b) => b.kind != BlockKind.plain);

  static ParsedResponse parse(String raw) {
    final lines = raw.split('\n');
    final blocks = <ResponseBlock>[];

    BlockKind? current;
    final buffer = <String>[];

    void flush() {
      if (buffer.isEmpty) {
        current = null;
        return;
      }
      final joined = buffer.join('\n').trim();
      buffer.clear();
      if (joined.isEmpty) {
        current = null;
        return;
      }
      switch (current) {
        case BlockKind.urgent:
          blocks.add(UrgentBlock(joined));
          break;
        case BlockKind.protocol:
          final steps = joined
              .split('\n')
              .map(_stripListMarker)
              .where((s) => s.isNotEmpty)
              .toList();
          if (steps.isEmpty) {
            blocks.add(PlainBlock(joined));
          } else {
            blocks.add(ProtocolBlock(steps));
          }
          break;
        case BlockKind.critical:
          final warnings = joined
              .split('\n')
              .map(_stripDashMarker)
              .where((s) => s.isNotEmpty)
              .toList();
          if (warnings.isEmpty) {
            blocks.add(PlainBlock(joined));
          } else {
            blocks.add(CriticalBlock(warnings));
          }
          break;
        case BlockKind.plain:
        case null:
          blocks.add(PlainBlock(joined));
      }
      current = null;
    }

    for (final rawLine in lines) {
      final line = rawLine.trimRight();
      final classification = _classify(line);

      if (classification != null) {
        flush();
        current = classification.kind;
        if (classification.inlineContent != null &&
            classification.inlineContent!.isNotEmpty) {
          buffer.add(classification.inlineContent!);
        }
      } else if (line.trim().isEmpty) {
        if (buffer.isNotEmpty) {
          flush();
        }
      } else {
        current ??= BlockKind.plain;
        buffer.add(line);
      }
    }
    flush();

    // Disclaimer tekrarlarını temizle — global bar ayrıca gösteriyor.
    return ParsedResponse(
      blocks.where((b) => !_isDisclaimerOnly(b)).toList(),
    );
  }

  static _Classification? _classify(String line) {
    final trimmed = line.trimLeft();
    if (trimmed.isEmpty) return null;

    // Legacy marker prefix: ▲ » ◆ (skill files + earlier prompt)
    if (trimmed.startsWith('▲')) {
      return _Classification(
          BlockKind.urgent, _stripHeadingPrefix(trimmed.substring(1)));
    }
    if (trimmed.startsWith('»')) {
      return _Classification(
          BlockKind.protocol, _stripHeadingPrefix(trimmed.substring(1)));
    }
    if (trimmed.startsWith('◆')) {
      return _Classification(
          BlockKind.critical, _stripHeadingPrefix(trimmed.substring(1)));
    }

    // New Haven Protocol v2 prompt markers: ⚠️ 📋 ⚡
    // Emojis may be followed by a variation selector (U+FE0F) or whitespace.
    if (_startsWithEmoji(trimmed, '⚠')) {
      return _Classification(
          BlockKind.urgent, _stripEmojiHeading(trimmed));
    }
    if (_startsWithEmoji(trimmed, '📋')) {
      return _Classification(
          BlockKind.protocol, _stripEmojiHeading(trimmed));
    }
    if (_startsWithEmoji(trimmed, '⚡')) {
      return _Classification(
          BlockKind.critical, _stripEmojiHeading(trimmed));
    }

    // Markdown heading: ## ACİL EYLEM / ## PROTOKOL / ## KRİTİK UYARILAR
    final heading = RegExp(r'^#{1,6}\s*(.+)$').firstMatch(trimmed);
    if (heading != null) {
      final title = heading.group(1)!.toUpperCase();
      if (_matchesAny(title, _urgentKeywords)) {
        return const _Classification(BlockKind.urgent, null);
      }
      if (_matchesAny(title, _protocolKeywords)) {
        return const _Classification(BlockKind.protocol, null);
      }
      if (_matchesAny(title, _criticalKeywords)) {
        return const _Classification(BlockKind.critical, null);
      }
    }

    return null;
  }

  static bool _startsWithEmoji(String line, String emoji) {
    if (line.startsWith(emoji)) return true;
    // With variation selector
    if (line.startsWith('$emoji\uFE0F')) return true;
    return false;
  }

  static String? _stripEmojiHeading(String line) {
    // Drop leading emoji + variation selector + optional "ACİL EYLEM:" label
    // so any trailing content on the same line becomes the block body.
    var s = line.replaceFirst(
        RegExp(r'^[⚠📋⚡]\uFE0F?\s*'), '');
    // Strip optional uppercase label + colon
    final labelMatch =
        RegExp(r'^[A-ZÇĞİÖŞÜ][A-ZÇĞİÖŞÜ\s]*:?\s*', unicode: true)
            .firstMatch(s);
    if (labelMatch != null) {
      s = s.substring(labelMatch.end);
    }
    final trimmed = s.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? _stripHeadingPrefix(String s) {
    // "ACİL:" veya "ACİL EYLEM:" gibi başlık kelimelerini atla, içeriği döndür.
    final match =
        RegExp(r'^\s*[A-ZÇĞİÖŞÜ ]+:?\s*', unicode: true).firstMatch(s);
    if (match == null) return s.trim();
    final rest = s.substring(match.end).trim();
    return rest.isEmpty ? null : rest;
  }

  static String _stripListMarker(String s) {
    final trimmed = s.trimLeft();
    // "1." "01." "1)" "- " "• "
    final numbered = RegExp(r'^\d+[\.\)]\s*').firstMatch(trimmed);
    if (numbered != null) return trimmed.substring(numbered.end).trim();
    final bullet = RegExp(r'^[\-•]\s+').firstMatch(trimmed);
    if (bullet != null) return trimmed.substring(bullet.end).trim();
    return trimmed.trim();
  }

  static String _stripDashMarker(String s) {
    final trimmed = s.trimLeft();
    final dash = RegExp(r'^[—\-–]\s*').firstMatch(trimmed);
    if (dash != null) return trimmed.substring(dash.end).trim();
    return trimmed.trim();
  }

  static bool _matchesAny(String haystack, List<String> needles) {
    for (final n in needles) {
      if (haystack.contains(n)) return true;
    }
    return false;
  }

  static bool _isDisclaimerOnly(ResponseBlock b) {
    if (b is! PlainBlock) return false;
    final t = b.text.toLowerCase();
    return t.contains('⚕️') &&
        (t.contains('profesyonel') || t.contains('professional'));
  }

  static const List<String> _urgentKeywords = [
    'ACİL',
    'ACIL',
    'EYLEM',
    'URGENT',
    'EMERGENCY',
    'IMMEDIATE',
  ];

  static const List<String> _protocolKeywords = [
    'PROTOKOL',
    'PROTOCOL',
    'ADIM',
    'STEP',
    'PROSEDÜR',
    'PROCEDURE',
    'SONRA',
    'SONRASI',
  ];

  static const List<String> _criticalKeywords = [
    'KRİTİK',
    'KRITIK',
    'CRITICAL',
    'UYARI',
    'WARNING',
    'TEHLİKE',
    'DANGER',
  ];
}

class _Classification {
  final BlockKind kind;
  final String? inlineContent;
  const _Classification(this.kind, this.inlineContent);
}
