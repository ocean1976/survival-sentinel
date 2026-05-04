/// Türkçe/İngilizce metin normalizasyonu ve fuzzy eşleşme.
class TextUtils {
  /// Türkçe karakterleri ASCII'ye çevirir, küçük harfe alır, noktalama temizler.
  static String normalize(String input) {
    var s = input.toLowerCase();
    const replacements = {
      'ı': 'i', 'İ': 'i', 'i̇': 'i',
      'ğ': 'g', 'Ğ': 'g',
      'ü': 'u', 'Ü': 'u',
      'ş': 's', 'Ş': 's',
      'ö': 'o', 'Ö': 'o',
      'ç': 'c', 'Ç': 'c',
      'â': 'a', 'î': 'i', 'û': 'u',
    };
    replacements.forEach((from, to) => s = s.replaceAll(from, to));
    s = s.replaceAll(RegExp(r'[^\w\s]'), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s;
  }

  /// Levenshtein distance between two strings.
  static int levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final matrix = List.generate(
      a.length + 1,
      (_) => List.filled(b.length + 1, 0),
    );

    for (var i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }
    for (var j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= a.length; i++) {
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((v, e) => v < e ? v : e);
      }
    }
    return matrix[a.length][b.length];
  }

  /// Mesajdaki herhangi bir token, keyword'e fuzzy yakın mı?
  /// Threshold: keyword uzunluğunun ~%30'u (min 1, max 3).
  static bool fuzzyContains(String message, String keyword) {
    final normMsg = normalize(message);
    final normKey = normalize(keyword);
    if (normKey.isEmpty) return false;

    // 1. Direkt substring eşleşme
    if (normMsg.contains(normKey)) return true;

    // 2. Token bazlı fuzzy
    final tokens = normMsg.split(' ');
    final threshold = (normKey.length * 0.3).round().clamp(1, 3);
    final prefixLen = (normKey.length * 0.6).round().clamp(1, normKey.length);

    for (final token in tokens) {
      if (token.length < 3) continue;
      // Prefix match
      if (token.startsWith(normKey.substring(0, prefixLen))) return true;
      // Levenshtein
      if (levenshtein(token, normKey) <= threshold) return true;
    }
    return false;
  }

  /// Basit dil tespiti: TR-spesifik karakter/kelime varsa TR, yoksa EN.
  static String detectLanguage(String text) {
    final lower = text.toLowerCase();

    // Türkçeye özgü karakterler
    if (RegExp(r'[ğüşıöçĞÜŞİÖÇ]').hasMatch(text)) return 'tr';

    // Türkçe stop word'ler
    const trWords = [
      'nasıl', 'nerede', 'oldu', 'var', 'bir', 'için', 'ile',
      'değil', 'ben', 'sen', 'biz', 'siz', 'yardim', 'yardım',
      'lutfen', 'lütfen', 'merhaba', 'yapmalıyım', 'yapmaliyim',
    ];
    for (final w in trWords) {
      if (RegExp('\\b$w\\b').hasMatch(lower)) return 'tr';
    }

    // İngilizce stop word'ler
    const enWords = [
      'what', 'how', 'where', 'is', 'are', 'the', 'help',
      'please', 'hello', 'should', 'can', 'do', 'my', 'me', 'you',
      'survive', 'emergency', 'earthquake', 'fire', 'flood',
    ];
    for (final w in enWords) {
      if (RegExp('\\b$w\\b').hasMatch(lower)) return 'en';
    }

    // Default: TR
    return 'tr';
  }
}
