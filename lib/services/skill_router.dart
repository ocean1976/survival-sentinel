import 'package:flutter/services.dart';
import '../models/skill.dart';
import '../utils/text_utils.dart';

class SkillRouter {
  final String language;
  final Map<String, List<Skill>> _pools = {}; // 'tr' -> [...], 'en' -> [...]
  bool _loaded = false;

  SkillRouter({this.language = 'tr'});

  static const _ids = [
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
    'general_survival',
  ];

  Future<void> load() async {
    if (_loaded) return;
    await _loadLanguage('tr');
    await _loadLanguage('en');
    _loaded = true;
  }

  Future<void> _loadLanguage(String lang) async {
    final skills = <Skill>[];
    for (final id in _ids) {
      try {
        final raw = await rootBundle.loadString('assets/skills/$lang/$id.md');
        skills.add(Skill.parse(id, raw));
      } catch (_) {
        // Dosya yoksa atla
      }
    }
    _pools[lang] = skills;
  }

  /// Mesajın diline ve içeriğine göre en iyi skill'i seç.
  /// Dil otomatik tespit edilir.
  Skill? match(String query) {
    final detectedLang = TextUtils.detectLanguage(query);
    final pool = _pools[detectedLang] ?? _pools[language] ?? [];
    if (pool.isEmpty) return null;

    Skill? best;
    int bestScore = 0;
    for (final skill in pool) {
      int score = 0;
      for (final kw in skill.keywords) {
        if (kw.isEmpty) continue;
        if (TextUtils.fuzzyContains(query, kw)) {
          score += kw.length;
        }
      }
      if (score > bestScore) {
        bestScore = score;
        best = skill;
      }
    }

    // Tespit edilen dilde bulunamadıysa diğer dilde dene
    if (best == null) {
      final fallbackLang = detectedLang == 'en' ? 'tr' : 'en';
      final fallbackPool = _pools[fallbackLang] ?? [];
      for (final skill in fallbackPool) {
        int score = 0;
        for (final kw in skill.keywords) {
          if (kw.isEmpty) continue;
          if (TextUtils.fuzzyContains(query, kw)) {
            score += kw.length;
          }
        }
        if (score > bestScore) {
          bestScore = score;
          best = skill;
        }
      }
    }

    return best;
  }
}
