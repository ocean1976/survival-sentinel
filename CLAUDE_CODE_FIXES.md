# Haven Protocol — 6 Bug Fix Talimatı

**Hedef:** Aşağıdaki 6 sorunu sırayla düzelt. Her bir fix için ilgili dosyayı önce `view` ile oku, sonra düzelt.

---

## FIX 1 — Yazarken chat aşağı kaymıyor (typing sırasında scroll donuyor)

**Dosya:** `lib/screens/chat_screen.dart`

**Sorun:** AI yanıtı stream / typing animation'la yazılırken `ScrollController` yeni eklenen karaktere doğru kaymıyor. Animasyon bitince elle kaydırabiliyor.

**Sebep:** Muhtemelen scroll yalnızca `setState` sonunda bir kez tetikleniyor; her chunk geldiğinde tetiklenmiyor. Veya `addPostFrameCallback` kullanılmıyor.

**Yapılacaklar:**

1. `ChatScreen`'de bir `ScrollController _scrollController = ScrollController();` olduğunu doğrula. Yoksa ekle ve `ListView`'e bağla.
2. Şu helper'ı ekle:

```dart
void _scrollToBottom() {
  // Layout güncellendikten sonra kaydır
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    }
  });
}
```

3. AI yanıtı yazılırken (typing animation veya token stream'inde) **her token / her chunk eklendikten sonra** `_scrollToBottom()` çağır. Sadece mesaj tamamen bittiğinde değil, **her setState'ten sonra** çağrılmalı.

4. Kullanıcı mesaj gönderdiğinde de çağır (input boşaltıldıktan hemen sonra).

5. `dispose()` içine `_scrollController.dispose();` ekle.

**Test:** Uzun bir AI yanıtı üretirken parmağı ekrandan çek; yanıt yazıldıkça sayfa otomatik aşağı kaymalı.

---

## FIX 2 — Settings sayfası açılmıyor

**Dosyalar:** `lib/screens/settings_screen.dart`, `lib/screens/chat_screen.dart` (settings butonu nereden tetikleniyorsa), `lib/app.dart` (route varsa)

**Sorun:** Settings butonuna basıldığında ekran açılmıyor.

**Olası sebepler ve sırayla kontrol:**

1. **SettingsScreen dosyası boş veya hatalı mı?**
   - `view lib/screens/settings_screen.dart` ile bak. Boşsa veya `build()` metodu yoksa minimal bir scaffold ile doldur.

2. **Navigation çağrısı yanlış mı?**
   - Chat screen'deki settings ikonunun `onPressed`'inde şu şekilde olmalı:
   ```dart
   Navigator.of(context).push(
     MaterialPageRoute(builder: (_) => const SettingsScreen()),
   );
   ```
   - `Navigator.pushNamed(context, '/settings')` kullanılıyorsa `app.dart`'taki `routes:` haritasında `/settings` tanımlı mı kontrol et.

3. **Import eksik mi?**
   - `chat_screen.dart` dosyasının üstünde `import 'settings_screen.dart';` var mı kontrol et.

4. **Buton hiç tetikleniyor mu?**
   - `onPressed` başına `print('SETTINGS TAPPED');` ekleyip Flutter console'da görüldüğünü doğrula. Görünmüyorsa buton bir başka widget'ın altında kalmış demektir (Stack overlap).

**Minimal çalışan SettingsScreen iskeleti** (boşsa bunu kullan):

```dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC5CCC4),
      appBar: AppBar(
        title: const Text('AYARLAR'),
        backgroundColor: const Color(0xFFA8B2A4),
        foregroundColor: const Color(0xFF283826),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Karanlık Mod'),
            trailing: Switch(
              value: false,
              onChanged: (_) {}, // TODO: theme controller bağla
            ),
          ),
          ListTile(
            title: const Text('Dil'),
            subtitle: const Text('Türkçe'),
            onTap: () {}, // TODO: language picker
          ),
          ListTile(
            title: const Text('Premium'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pushNamed('/premium');
            },
          ),
        ],
      ),
    );
  }
}
```

---

## FIX 3 — Premium sayfası açılmıyor

**Dosyalar:** `lib/screens/premium_screen.dart` (yoksa oluştur), `lib/app.dart` (route)

**Sorun:** Premium butonu tıklanınca ekran gelmiyor.

**Yapılacaklar:**

1. `lib/screens/premium_screen.dart` dosyasının var olup olmadığını kontrol et. Yoksa oluştur. Mevcutsa `view` ile içeriğine bak — boşsa veya hatalıysa düzelt.

2. Settings'ten Premium'a navigation:

```dart
onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const PremiumScreen()),
  );
},
```

3. **Minimal çalışan PremiumScreen** (`settings_premium_mockup.jsx`'teki tasarıma sadık ama Flutter):

```dart
import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC5CCC4),
      appBar: AppBar(
        title: const Text('[*] PREMIUM'),
        backgroundColor: const Color(0xFFA8B2A4),
        foregroundColor: const Color(0xFF283826),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Mevcut durum kartı
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFB8C0B0),
              border: Border.all(color: const Color(0xFFA0AA96)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Column(
              children: [
                Text('MEVCUT DURUM',
                    style: TextStyle(letterSpacing: 1.5, color: Color(0xFF5A6A56))),
                SizedBox(height: 4),
                Text('ÜCRETSİZ — SINIRLI ERİŞİM',
                    style: TextStyle(
                        color: Color(0xFF9B1B1B),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 3 fiyat tier butonu
          _buildTierButton(context, '\$5', 'Destekleyici'),
          const SizedBox(height: 8),
          _buildTierButton(context, '\$10', 'Geliştirici Destekçisi'),
          const SizedBox(height: 8),
          _buildTierButton(context, '\$20', 'Patron'),
          const SizedBox(height: 16),
          const Text(
            'Üç seçenek de aynı sınırsız erişimi verir. Yüksek tier seçmek geliştiriciyi destekler.',
            style: TextStyle(fontSize: 11, color: Color(0xFF5A6A56)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTierButton(BuildContext context, String price, String label) {
    return ElevatedButton(
      onPressed: () {}, // TODO: in_app_purchase entegrasyonu
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3D6B35),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(letterSpacing: 1)),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
```

---

## FIX 4 — Her soruda "Demo modundasınız" diyor (gerçek modelden yanıt almıyor)

**Dosyalar:** `lib/services/ai_service.dart`, `lib/services/ai_service_mobile.dart`, `lib/services/ai_service_web.dart`, `lib/main.dart`

**Sorun:** Mobil cihazda dahi `ai_service_web.dart` (mock) çağrılıyor — yani conditional import yanlış çalışıyor veya web service tüm platformlarda yükleniyor.

**Beklenen davranış:** Demo mode YALNIZCA web platformunda devreye girmeli. Android cihazda gerçek Gemma 2 modeli yanıtlamalı. Yanıtın başında "Demo modundasınız" gibi bir uyarı OLMAMALI.

**Yapılacaklar:**

1. `view lib/services/ai_service.dart` ile abstract interface'i kontrol et. Conditional import şu şekilde olmalı:

```dart
// ai_service.dart
import 'ai_service_stub.dart'
    if (dart.library.io) 'ai_service_mobile.dart'
    if (dart.library.html) 'ai_service_web.dart';

// veya factory pattern:
abstract class AIService {
  Future<void> initialize();
  Future<String> generateResponse(String userMessage);
  static AIService create() => createAIService(); // platform-specific
}
```

2. `ai_service_mobile.dart` içinde "demo" / "mock" stringi GEÇMEMELI. Bu dosya Gemma modelini yüklemeli ve gerçek inference yapmalı. Eğer model henüz indirilmemişse hata fırlatmalı, demo'ya düşmemeli.

3. `ai_service_web.dart` içindeki demo yanıtının başındaki **"Demo modundasınız"** prefix'ini kaldır. Onun yerine: Web'de buildContext'inde küçük bir banner göster (chat screen'in üstünde): `[!] WEB ÖNİZLEME — Gerçek AI yanıtı için Android APK kullanın`.

4. **Acil çözüm — `main.dart` veya servis seçim noktasında platform check:**

```dart
import 'package:flutter/foundation.dart' show kIsWeb;

AIService createAIService() {
  if (kIsWeb) {
    return AIServiceWeb();
  }
  return AIServiceMobile();
}
```

5. **APK'da hâlâ "Demo modundasınız" çıkıyorsa** — `flutter analyze` çalıştır, sonra:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

Build cache'i Phi-3 dönemindeki eski mock'u tutuyor olabilir.

6. **`ai_service_mobile.dart` içinde model bulunamazsa fallback:**

```dart
@override
Future<String> generateResponse(String userMessage) async {
  if (!_modelLoaded) {
    // demo'ya düşme — kullanıcıya net hata ver
    return 'Model henüz hazır değil. Lütfen ayarlardan modeli indirin.';
  }
  // ... gerçek inference
}
```

---

## FIX 5 — Yazım hatası anlamıyor ("deprm" yazınca yakalamıyor)

**Dosya:** `lib/services/skill_router.dart`

**Sorun:** `selectSkill` sadece `messageLower.contains(keyword.toLowerCase())` ile literal eşleşme arıyor. "deprem" yerine "deprm", "depremm", "deprem oldu" gibi varyantları yakalayamıyor.

**Çözüm:** Levenshtein distance + Türkçe karakter normalizasyonu + token bazlı kontrol.

**Yapılacaklar:**

1. `lib/utils/text_utils.dart` adında yeni bir helper dosyası oluştur:

```dart
class TextUtils {
  /// Türkçe karakterleri ASCII'ye çevirir
  static String normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .replaceAll('İ', 'i')
        .replaceAll(RegExp(r'[^\w\s]'), ' ') // noktalama temizle
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// İki kelime arasındaki Levenshtein distance
  static int levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final matrix = List.generate(
      a.length + 1,
      (_) => List.filled(b.length + 1, 0),
    );

    for (var i = 0; i <= a.length; i++) matrix[i][0] = i;
    for (var j = 0; j <= b.length; j++) matrix[0][j] = j;

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
  /// Threshold: keyword uzunluğunun ~%30'u kadar tolerans (min 1, max 3)
  static bool fuzzyContains(String message, String keyword) {
    final normMsg = normalize(message);
    final normKey = normalize(keyword);

    // 1. Direkt substring eşleşme — en hızlı
    if (normMsg.contains(normKey)) return true;

    // 2. Token bazlı fuzzy
    final tokens = normMsg.split(' ');
    final threshold = (normKey.length * 0.3).round().clamp(1, 3);

    for (final token in tokens) {
      if (token.length < 3) continue; // çok kısa kelimeleri atla
      // Hem tam kelime hem de keyword başlıyor mu kontrol
      if (token.startsWith(normKey.substring(0, (normKey.length * 0.6).round()))) {
        return true;
      }
      if (levenshtein(token, normKey) <= threshold) return true;
    }
    return false;
  }
}
```

2. `skill_router.dart` içindeki `selectSkill` metodunu güncelle:

```dart
import '../utils/text_utils.dart';

SkillFile selectSkill(String userMessage) {
  int bestScore = 0;
  SkillFile? bestSkill;

  for (final skill in _skills.values) {
    int score = 0;
    for (final keyword in skill.keywords) {
      if (TextUtils.fuzzyContains(userMessage, keyword)) {
        score++;
      }
    }
    if (skill.priority == 'high') score += 2;

    if (score > bestScore) {
      bestScore = score;
      bestSkill = skill;
    }
  }

  // Hiç eşleşme yoksa fallback
  return bestSkill ?? _skills['general_survival']!;
}
```

3. Skill keyword listelerini de **kısaltılmış varyantlarla** zenginleştir. `assets/skills/tr/earthquake.md` frontmatter'ında:

```yaml
keywords: [deprem, depre, sarsinti, sarsıntı, zelzele, enkaz, artci, artçı, cokme, çökme, bina cokmesi, fay, tsunami, earthquake, aftershock]
```

Not: keyword'lerde Türkçe karakterli ve karaktersiz versiyonlarını **ikisini birden** koy. Çünkü kullanıcı bazen "sarsinti" yazıyor bazen "sarsıntı".

4. Test:
```dart
// test/skill_router_test.dart
test('fuzzy matches deprm to deprem', () {
  expect(TextUtils.fuzzyContains('deprm oldu ne yapmlyim', 'deprem'), isTrue);
});

test('fuzzy matches yangn to yangin', () {
  expect(TextUtils.fuzzyContains('evde yangn cikti', 'yangın'), isTrue);
});
```

---

## FIX 6 — Sadece Türkçe anlıyor (İngilizce / başka dil çalışmıyor)

**Dosyalar:** `lib/services/skill_router.dart`, `lib/utils/prompt_builder.dart`, `lib/main.dart`

**Sorun:** Skill router yalnızca Türkçe skill dosyalarını yüklüyor; system prompt da hardcoded TR.

**Yapılacaklar:**

1. **Otomatik dil tespiti** — `text_utils.dart`'a ekle:

```dart
/// Çok basit dil tespiti: TR-spesifik karakter veya kelime varsa TR, yoksa EN
static String detectLanguage(String text) {
  final lower = text.toLowerCase();

  // Türkçeye özgü karakterler
  if (RegExp(r'[ğüşıöçĞÜŞİÖÇ]').hasMatch(text)) return 'tr';

  // Türkçe stop word'ler
  const trWords = ['ne', 'nasıl', 'nerede', 'oldu', 'var', 'bir', 'için', 'ile',
                   'değil', 'ben', 'sen', 'biz', 'siz', 'yardim', 'yardım',
                   'lutfen', 'lütfen', 'merhaba'];
  for (final w in trWords) {
    if (RegExp('\\b$w\\b').hasMatch(lower)) return 'tr';
  }

  // İngilizce stop word'ler
  const enWords = ['what', 'how', 'where', 'is', 'are', 'the', 'help',
                   'please', 'hello', 'should', 'can', 'i', 'me', 'you'];
  for (final w in enWords) {
    if (RegExp('\\b$w\\b').hasMatch(lower)) return 'en';
  }

  // Default: TR (kullanıcı kitlesi)
  return 'tr';
}
```

2. **SkillRouter — her iki dildeki dosyaları yükle:**

```dart
class SkillRouter {
  final Map<String, SkillFile> _skillsTR = {};
  final Map<String, SkillFile> _skillsEN = {};

  Future<void> loadAll() async {
    await _loadLanguage('tr', _skillsTR);
    await _loadLanguage('en', _skillsEN);
  }

  Future<void> _loadLanguage(String lang, Map<String, SkillFile> target) async {
    final ids = ['earthquake', 'first_aid', 'fire_wildfire',
                 'water_purification', 'shelter_building', 'general_survival',
                 /* diğer skill'ler */];
    for (final id in ids) {
      try {
        final content = await rootBundle.loadString('assets/skills/$lang/$id.md');
        final skill = SkillFile.parse(content);
        target[skill.id] = skill;
      } catch (_) {
        // dosya yoksa atla — TR'de var EN'de yok olabilir, vice versa
      }
    }
  }

  /// Mesajın diline göre doğru skill setinden seçim yapar
  ({SkillFile skill, String language}) selectSkill(String userMessage) {
    final lang = TextUtils.detectLanguage(userMessage);
    final pool = lang == 'en' ? _skillsEN : _skillsTR;

    int bestScore = 0;
    SkillFile? bestSkill;

    for (final skill in pool.values) {
      int score = 0;
      for (final keyword in skill.keywords) {
        if (TextUtils.fuzzyContains(userMessage, keyword)) score++;
      }
      if (skill.priority == 'high') score += 2;
      if (score > bestScore) {
        bestScore = score;
        bestSkill = skill;
      }
    }

    final fallback = pool['general_survival'] ??
                     _skillsTR['general_survival']!;
    return (skill: bestSkill ?? fallback, language: lang);
  }
}
```

3. **PromptBuilder — dil parametresini kullan:**

```dart
static String build({
  required String userMessage,
  required String skillContent,
  required String language, // 'tr' veya 'en'
}) {
  final systemPrompt = language == 'en' ? _systemPromptEN : _systemPromptTR;
  final fullSystem = systemPrompt.replaceAll('{SKILL_CONTENT}', skillContent);
  return '<start_of_turn>user\n$fullSystem\n\nKullanıcı: $userMessage<end_of_turn>\n<start_of_turn>model\n';
}
```

4. **AI service çağrı zinciri** (`ai_service_mobile.dart` içinde):

```dart
@override
Future<String> generateResponse(String userMessage) async {
  final selection = _skillRouter.selectSkill(userMessage);
  final prompt = PromptBuilder.build(
    userMessage: userMessage,
    skillContent: selection.skill.content,
    language: selection.language, // ← otomatik tespit edilen dil
  );
  return await _llama.complete(prompt);
}
```

5. **EN skill dosyalarını oluştur** — şimdilik en azından şu 3'ü olsun, kalanı sonra:
   - `assets/skills/en/earthquake.md`
   - `assets/skills/en/first_aid.md`
   - `assets/skills/en/general_survival.md` (fallback)

   Tek bir EN fallback bile olsa "How do I survive a fire?" gibi soruda EN cevap üretebilir hale gelir.

---

## ÖZET — Uygulama Sırası

```
1. FIX 1 → chat_screen.dart scroll fix (en görünür hata)
2. FIX 2 → settings_screen.dart oluştur/düzelt
3. FIX 3 → premium_screen.dart oluştur
4. FIX 4 → ai_service.dart conditional import + flutter clean
5. FIX 5 → text_utils.dart oluştur, skill_router.dart fuzzy match'e geçir
6. FIX 6 → dil tespiti, EN skill yükleme, EN fallback dosyası

Her fix sonrası:
  flutter analyze
  flutter run -d <android-device-id>
  Manuel test
```

## Test senaryoları

| Test | Beklenti |
|------|----------|
| AI uzun yanıt verirken parmağı çek | Sayfa otomatik aşağı kayıyor |
| Settings ikonuna bas | Ayarlar ekranı açılıyor |
| Settings'ten Premium'a bas | Premium ekranı açılıyor, 3 tier görünüyor |
| Android APK'da soru sor | "Demo modundasınız" YOK, gerçek AI yanıtı var |
| "deprm oldu ne yapmlyim" yaz | Earthquake skill seçiliyor, deprem rehberi geliyor |
| "How do I survive an earthquake?" yaz | EN dilde yanıt geliyor |

---

## Build Komutları

```bash
# Her fix'ten sonra:
flutter analyze

# Test çalıştır:
flutter test

# Android'de canlı test:
flutter run -d <device-id>

# Release APK:
flutter clean
flutter pub get
flutter build apk --release
```
