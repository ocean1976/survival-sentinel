class Skill {
  final String id;
  final String title;
  final List<String> keywords;
  final List<String> sources;
  final String body;

  Skill({
    required this.id,
    required this.title,
    required this.keywords,
    required this.sources,
    required this.body,
  });

  factory Skill.parse(String id, String raw) {
    final lines = raw.split('\n');
    String title = id;
    List<String> keywords = [];
    List<String> sources = [];
    int bodyStart = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        bodyStart = i + 1;
        break;
      }
      final match = RegExp(r'^#\s*(\w+):\s*(.+)$').firstMatch(line);
      if (match == null) {
        bodyStart = i;
        break;
      }
      final key = match.group(1)!.toLowerCase();
      final value = match.group(2)!.trim();
      switch (key) {
        case 'title':
          title = value;
          break;
        case 'keywords':
          keywords = value.split(',').map((s) => s.trim().toLowerCase()).toList();
          break;
        case 'sources':
          sources = value.split(',').map((s) => s.trim()).toList();
          break;
      }
    }

    final body = lines.sublist(bodyStart).join('\n').trim();
    return Skill(
      id: id,
      title: title,
      keywords: keywords,
      sources: sources,
      body: body,
    );
  }
}
