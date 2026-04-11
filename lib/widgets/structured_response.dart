import 'package:flutter/material.dart';
import '../models/parsed_response.dart';
import '../utils/theme.dart';

/// Rendering aligned to docs/chat_screen_design.jsx — §ACİL EYLEM block
/// is a padded tinted card, §PROTOKOL/KRİTİK have a divider between them,
/// every AI message closes with an inline disclaimer card + blinking-like
/// cursor glyph.
class StructuredResponse extends StatelessWidget {
  final String text;
  final HavenTheme theme;

  const StructuredResponse({
    super.key,
    required this.text,
    required this.theme,
  });

  bool get _isBunker => theme.mode == HavenMode.bunker;

  @override
  Widget build(BuildContext context) {
    final parsed = ParsedResponse.parse(text);

    if (!parsed.hasStructure) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: _bodyStyle),
          const SizedBox(height: 10),
          _inlineDisclaimer(),
        ],
      );
    }

    final widgets = <Widget>[];
    for (int i = 0; i < parsed.blocks.length; i++) {
      final block = parsed.blocks[i];
      widgets.add(_blockWidget(block));

      // Divider between PROTOKOL and KRİTİK blocks
      if (i + 1 < parsed.blocks.length) {
        final next = parsed.blocks[i + 1];
        final needsDivider = block.kind == BlockKind.protocol &&
            next.kind == BlockKind.critical;
        widgets.add(SizedBox(height: needsDivider ? 10 : 8));
        if (needsDivider) {
          widgets.add(Container(
            height: 1,
            color: theme.divider,
            margin: const EdgeInsets.only(bottom: 10),
          ));
        }
      }
    }
    widgets.add(const SizedBox(height: 10));
    widgets.add(_inlineDisclaimer());
    widgets.add(const SizedBox(height: 2));
    widgets.add(Text('█', style: TextStyle(color: theme.cursor, fontSize: 13)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  TextStyle get _bodyStyle => TextStyle(
        color: theme.messageText,
        fontSize: 13,
        height: 1.6,
      );

  Widget _blockWidget(ResponseBlock block) {
    switch (block.kind) {
      case BlockKind.urgent:
        return _urgent(block as UrgentBlock);
      case BlockKind.protocol:
        return _protocol(block as ProtocolBlock);
      case BlockKind.critical:
        return _critical(block as CriticalBlock);
      case BlockKind.plain:
        return Text((block as PlainBlock).text, style: _bodyStyle);
    }
  }

  Widget _urgent(UrgentBlock block) {
    final bg = _isBunker
        ? const Color(0xFF1A0C08)
        : const Color(0xFFF5E8E4);
    final border = _isBunker
        ? const Color(0xFF3A1818)
        : const Color(0xFFE8C8C0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '▲ ACİL EYLEM',
            style: TextStyle(
              color: theme.urgent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            block.text,
            style: _bodyStyle.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _protocol(ProtocolBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '» PROTOKOL',
          style: TextStyle(
            color: theme.protocol,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        for (int i = 0; i < block.steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(i + 1).toString().padLeft(2, '0')}.',
                  style: TextStyle(
                    color: theme.protocol,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.6,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(block.steps[i], style: _bodyStyle),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _critical(CriticalBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '◆ KRİTİK',
          style: TextStyle(
            color: theme.critical,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        for (final warning in block.warnings)
          Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '—',
                  style: TextStyle(
                    color: theme.critical,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.6,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(warning, style: _bodyStyle),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _inlineDisclaimer() {
    final bg = _isBunker
        ? const Color(0xFF0A0C06)
        : const Color(0xFFD8DCD4);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: theme.divider),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        '⚕️ Bu bilgi profesyonel yardımın yerini almaz.',
        style: TextStyle(
          color: theme.textMuted,
          fontSize: 10,
        ),
      ),
    );
  }
}
