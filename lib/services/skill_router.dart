import 'package:flutter/services.dart';
import '../models/skill.dart';

class SkillRouter {
  final String language;
  final List<Skill> _skills = [];
  bool _loaded = false;

  SkillRouter({this.language = 'tr'});

  Future<void> load() async {
    if (_loaded) return;

    const ids = [
      'earthquake',
      'fire',
      'first_aid',
      'water',
      'shelter',
      'flood',
      'tornado',
      'wildfire',
      'tsunami',
      'blizzard',
      'heatstroke',
      'fracture',
      'drowning',
      'lost_wilderness',
      'signaling',
      'nuclear',
      'chemical_attack',
      'pandemic',
      'evacuation',
      'blackout',
    ];
    for (final id in ids) {
      try {
        final raw = await rootBundle.loadString('assets/skills/$language/$id.md');
        _skills.add(Skill.parse(id, raw));
      } catch (_) {
        // Skill dosyası bulunamadı — sessizce atla
      }
    }
    _loaded = true;
  }

  Skill? match(String query) {
    if (_skills.isEmpty) return null;
    final q = _normalize(query);

    Skill? best;
    int bestScore = 0;
    for (final skill in _skills) {
      int score = 0;
      for (final kw in skill.keywords) {
        if (kw.isEmpty) continue;
        final nkw = _normalize(kw);
        if (nkw.isEmpty) continue;
        if (q.contains(nkw)) score += nkw.length;
      }
      if (score > bestScore) {
        bestScore = score;
        best = skill;
      }
    }
    return best;
  }

  /// Türkçe + İngilizce robust eşleşme için normalleştirme:
  /// - küçük harfe çevirir (Türkçe kuralları)
  /// - ı/İ/ç/ğ/ö/ş/ü → i/c/g/o/s/u
  /// - alfanumerik olmayan karakterleri boşluğa çevirir (noktalama/emoji temizliği)
  /// - birden çok boşluğu tek boşluğa indirir
  static String _normalize(String input) {
    var s = input.toLowerCase();
    const replacements = {
      'ı': 'i',
      'İ': 'i',
      'i̇': 'i',
      'ğ': 'g',
      'Ğ': 'g',
      'ü': 'u',
      'Ü': 'u',
      'ş': 's',
      'Ş': 's',
      'ö': 'o',
      'Ö': 'o',
      'ç': 'c',
      'Ç': 'c',
      'â': 'a',
      'î': 'i',
      'û': 'u',
    };
    replacements.forEach((from, to) => s = s.replaceAll(from, to));
    s = s.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s;
  }
}
