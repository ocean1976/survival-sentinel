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
    final q = query.toLowerCase();

    Skill? best;
    int bestScore = 0;
    for (final skill in _skills) {
      int score = 0;
      for (final kw in skill.keywords) {
        if (kw.isEmpty) continue;
        if (q.contains(kw)) score += kw.length;
      }
      if (score > bestScore) {
        bestScore = score;
        best = skill;
      }
    }
    return best;
  }
}
