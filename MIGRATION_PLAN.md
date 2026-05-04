# Survival Sentinel — Skill Sistemine Geçiş Planı

**Tarih:** Nisan 2026  
**Mevcut Durum:** Phi-3 + RAG planı (%30 tamamlanmış)  
**Hedef:** Gemma 4 + Skill dosyaları sistemi  
**Tahmini Süre:** Claude Code ile 3-4 gün (günde 2-3 saat)

---

## 1. DEĞİŞTİRİLECEK MEVCUT DOSYALAR

### 1.1 `lib/ai_service_mobile.dart`
**Durum:** Phi-3 prompt formatı hardcoded  
**Değişiklik:** Gemma 4 prompt formatına geçiş + PromptBuilder entegrasyonu

```dart
// ESKİ (Phi-3 formatı):
final formattedPrompt = '<|system|>\nYou are...<|end|>\n<|user|>\n$prompt<|end|>\n<|assistant|>';

// YENİ (Gemma 4 formatı — PromptBuilder üzerinden):
final skillContent = await _skillRouter.selectSkill(prompt);
final formattedPrompt = PromptBuilder.build(
  userMessage: prompt,
  skillContent: skillContent.content,
  language: _currentLanguage,
);
```

**Ayrıca değişecekler:**
- Model dosya adı: `phi-3-mini-4k-instruct-q4.gguf` → Gemma 4 GGUF dosya adı
- `contextSize: 2048` → `contextSize: 4096` (Gemma 4'ün kapasitesine göre)
- `stopSequences: ['<|end|>', '<|user|>']` → `stopSequences: ['<end_of_turn>']`
- `temperature`, `topP` değerleri Gemma 4 için optimize edilecek

### 1.2 `lib/ai_service.dart`
**Durum:** Sadece `generateResponse(String prompt)` metodu var  
**Değişiklik:** SkillRouter referansı eklenmeli

```dart
// YENİ: AI Service içinde SkillRouter başlatma
class AIService {
  late final AIServicePlatform _platform;
  late final SkillRouter _skillRouter;  // ← YENİ
  
  Future<void> initialize() async {
    await _skillRouter.loadSkills();  // ← YENİ: Skill dosyalarını yükle
    await _platform.initialize();
  }
}
```

### 1.3 `lib/main.dart`
**Durum:** ~400 satır, tüm UI + logic tek dosyada  
**Değişiklik:** Minimal — sadece `_initializeAI()` metoduna skill yükleme eklenir

```dart
Future<void> _initializeAI() async {
  setState(() => _isLoading = true);
  
  await _aiService.initialize();  // Bu zaten var, içinde skill yükleme de olacak
  
  setState(() {
    _isLoading = false;
    _isModelLoaded = true;
  });
}
```

**NOT:** main.dart'ı şimdilik refactor etme. Çalışıyor, dokunma. Sadece gerekli minimum değişikliği yap.

### 1.4 `pubspec.yaml`
**Değişiklik:** Skill asset klasörlerini ekle

```yaml
# ESKİ:
flutter:
  assets:
    - assets/models/phi-3-mini-4k-instruct-q4.gguf

# YENİ:
flutter:
  assets:
    - assets/models/    # Gemma 4 GGUF (gitignore'da)
    - assets/skills/tr/
    - assets/skills/en/
```

### 1.5 `.gitignore`
**Değişiklik:** Gemma 4 model dosyası eklenmeli (Phi-3 referansı varsa güncelle)

```
# AI Models (çok büyük, Git'e eklenmez)
assets/models/*.gguf
```

---

## 2. YENİ OLUŞTURULACAK DOSYALAR

### 2.1 `lib/services/skill_router.dart`
**Amaç:** Kullanıcı sorusunu analiz edip doğru skill dosyasını seçer

```dart
class SkillRouter {
  final Map<String, SkillFile> _skills = {};
  
  /// Uygulama başlangıcında tüm skill dosyalarını yükler
  Future<void> loadSkills(String language) async {
    final skillFiles = ['earthquake', 'first_aid', 'fire_wildfire', ...];
    
    for (final id in skillFiles) {
      final content = await rootBundle.loadString('assets/skills/$language/$id.md');
      final skill = SkillFile.parse(content);
      _skills[skill.id] = skill;
    }
  }
  
  /// Kullanıcı mesajına en uygun skill dosyasını döndürür
  SkillFile selectSkill(String userMessage) {
    final messageLower = userMessage.toLowerCase();
    int bestScore = 0;
    SkillFile? bestSkill;
    
    for (final skill in _skills.values) {
      int score = 0;
      for (final keyword in skill.keywords) {
        if (messageLower.contains(keyword.toLowerCase())) {
          score++;
        }
      }
      if (skill.priority == 'high') score += 2;
      
      if (score > bestScore) {
        bestScore = score;
        bestSkill = skill;
      }
    }
    
    return bestSkill ?? _skills['general_survival']!;
  }
}
```

### 2.2 `lib/services/prompt_builder.dart`
**Amaç:** System prompt + skill context + kullanıcı sorusunu birleştirir

```dart
class PromptBuilder {
  static const String _systemPromptTR = '''
Sen "Sentinel" adında bir offline hayatta kalma asistanısın...
[SYSTEM_PROMPT.md'deki Türkçe prompt]
''';

  static const String _systemPromptEN = '''
You are "Sentinel", an offline survival assistant...
[SYSTEM_PROMPT.md'deki İngilizce prompt]
''';

  static String build({
    required String userMessage,
    required String skillContent,
    String language = 'tr',
  }) {
    final systemPrompt = language == 'tr' ? _systemPromptTR : _systemPromptEN;
    final fullSystem = systemPrompt.replaceAll('{SKILL_CONTENT}', skillContent);
    
    // Gemma 4 chat template
    return '<start_of_turn>user\n$fullSystem\n$userMessage<end_of_turn>\n<start_of_turn>model\n';
  }
}
```

### 2.3 `lib/models/skill.dart`
**Amaç:** Skill dosyası veri modeli

```dart
class SkillFile {
  final String id;
  final String title;
  final List<String> keywords;
  final String priority;
  final String language;
  final String source;
  final String content;
  
  SkillFile({
    required this.id,
    required this.title,
    required this.keywords,
    required this.priority,
    required this.language,
    required this.source,
    required this.content,
  });
  
  /// Markdown dosyasından YAML frontmatter parse eder
  factory SkillFile.parse(String rawMarkdown) {
    // --- ile başlayan frontmatter'ı ayır
    // YAML'ı parse et
    // İçeriği döndür
  }
}
```

### 2.4 `lib/services/ai_service_mobile.dart` → Güncelleme (yeni referanslar)
**Not:** Bu zaten var ama SkillRouter ve PromptBuilder import'ları eklenmeli.

---

## 3. OLUŞTURULACAK SKILL DOSYALARI

### Klasör Yapısı:
```
assets/
└── skills/
    ├── tr/
    │   ├── earthquake.md         ← Faz 1
    │   ├── first_aid.md          ← Faz 1
    │   ├── fire_wildfire.md      ← Faz 1
    │   ├── water_purification.md ← Faz 1
    │   ├── shelter_building.md   ← Faz 1
    │   ├── flood.md              ← Faz 2
    │   ├── nuclear.md            ← Faz 2
    │   ├── wilderness_survival.md ← Faz 2
    │   ├── fire_making.md        ← Faz 2
    │   ├── psychology.md         ← Faz 2
    │   ├── pandemic.md           ← Faz 3
    │   ├── navigation.md         ← Faz 3
    │   ├── signaling.md          ← Faz 3
    │   ├── edible_plants.md      ← Faz 3
    │   ├── volcano.md            ← Faz 3
    │   ├── urban_survival.md     ← Faz 3
    │   ├── desert_survival.md    ← Faz 3
    │   ├── winter_survival.md    ← Faz 3
    │   ├── tropical_survival.md  ← Faz 3
    │   ├── civil_unrest.md       ← Faz 3
    │   └── general_survival.md   ← Fallback
    └── en/
        └── ... (aynı 21 dosya İngilizce)
```

---

## 4. SİLİNECEK / TEMİZLENECEK DOSYALAR

| Dosya | Aksiyon | Neden |
|-------|---------|-------|
| `RAG_DOKUMAN_SABLONU.md` | ❌ Sil | RAG yaklaşımı terk edildi |
| `KALAN_ISLER_LISTESI.md` | 🔄 Güncelle | RAG referanslarını skill ile değiştir |
| `PROJE_DURUMU.md` | 🔄 Güncelle | Phi-3 → Gemma 4, RAG → Skill |
| `CURSOR_DEVIR_TESLIM.md` | 🔄 Güncelle | Yeni mimariyi yansıtmalı |
| `OTURUM_OZETI.md` | ⬜ Olduğu gibi bırak | Tarihsel kayıt |
| Root'taki mockup PNG'leri (11 adet) | ❌ Sil veya `docs/` klasörüne taşı | Root'u temizle |

---

## 5. UYGULAMA SIRASI (Claude Code için)

### Adım 1: Altyapı (İlk oturum — ~1 saat)
```
□ lib/models/skill.dart oluştur
□ lib/services/skill_router.dart oluştur
□ lib/services/prompt_builder.dart oluştur
□ pubspec.yaml'a skill asset'lerini ekle
□ assets/skills/tr/ ve assets/skills/en/ klasörlerini oluştur
□ general_survival.md fallback dosyasını yaz (TR + EN)
```

### Adım 2: AI Geçişi (İlk oturum devamı — ~1 saat)
```
□ ai_service_mobile.dart → Gemma 4 prompt formatına güncelle
□ ai_service_mobile.dart → SkillRouter + PromptBuilder entegre et
□ ai_service.dart → SkillRouter başlatma ekle
□ main.dart → _initializeAI() skill yükleme ekle
□ .gitignore → Gemma 4 model dosyası ekle
□ Web'de test et (demo mode hâlâ çalışmalı)
```

### Adım 3: İlk 5 Skill Dosyası (2. oturum — ~2 saat)
```
□ assets/skills/tr/earthquake.md → FEMA kaynaklarından
□ assets/skills/tr/first_aid.md → FM 21-76'dan
□ assets/skills/tr/fire_wildfire.md → FEMA kaynaklarından
□ assets/skills/tr/water_purification.md → FM 21-76'dan
□ assets/skills/tr/shelter_building.md → FM 21-76'dan
□ Her dosyada YAML frontmatter + keywords + source doğrula
□ Token sayısı kontrol (2000-3000 arası)
```

### Adım 4: Temizlik (2. oturum devamı — ~30 dk)
```
□ RAG_DOKUMAN_SABLONU.md sil
□ PROJE_DURUMU.md güncelle (Gemma 4 + Skill sistemi)
□ KALAN_ISLER_LISTESI.md güncelle
□ Mockup PNG'leri docs/ klasörüne taşı veya sil
□ README.md yaz (proje açıklaması)
□ Git commit: "refactor: Migrate from RAG/Phi-3 to Skill/Gemma4 architecture"
```

### Adım 5: Android Test (3. oturum — MacBook geldiğinde)
```
□ Gemma 4 GGUF modelini indir
□ flutter build apk --debug
□ Gerçek cihazda test
□ Skill routing doğru çalışıyor mu?
□ AI yanıtları bağlam-duyarlı mı?
□ Performans kabul edilebilir mi?
```

---

## 6. DOKUNULMAYACAK DOSYALAR

Bu dosyalar çalışıyor, skill geçişi sırasında değiştirme:

```
□ main.dart → UI kodu (minimal değişiklik hariç)
□ ai_service_web.dart → Demo mode olduğu gibi kalabilir
□ android/ → Platform kodu
□ ios/ → Platform kodu  
□ web/ → Platform kodu
□ .github/workflows/ → CI/CD (sonra düzeltilir)
□ LighthousePainter → Custom ikon kodu
□ ChatMessage model → Mesaj yapısı
```

---

## 7. BAĞIMLILIKLAR (pubspec.yaml)

### Mevcut (kalacak):
```yaml
llama_cpp_dart: ^0.0.9      # AI runtime
path_provider: ^2.1.5        # Dosya yolları
```

### Eklenecek:
```yaml
yaml: ^3.1.0                 # YAML frontmatter parse (skill dosyaları için)
```

### Gelecekte eklenecek (şimdi değil):
```yaml
shared_preferences: ^2.2.2   # Soru limiti, SOS timer, dil tercihi
```

---

## 8. RİSKLER VE ÇÖZÜMLERİ

| Risk | Olasılık | Çözüm |
|------|----------|-------|
| Gemma 4 GGUF henüz yok veya llama_cpp_dart desteklemiyor | Orta | Gemma 2 GGUF kullan (zaten destekleniyor) |
| Skill dosyası context window'a sığmıyor | Düşük | Dosyayı kısalt, max 2000 token |
| Keyword matching yanlış skill seçiyor | Orta | Test ve keyword fine-tuning ile düzelt |
| Model yükleme çok yavaş | Düşük | contextSize küçült, threads artır |
| APK boyutu çok büyük (~2.5 GB) | Kesin | İlk açılışta model indirme stratejisi |

---

## 9. BAŞARI KRİTERLERİ

Geçiş tamamlandı sayılması için:

```
□ "Deprem oldu ne yapmalıyım?" → earthquake.md seçilir, bağlam-duyarlı yanıt
□ "How to purify water?" → water_purification.md (EN) seçilir
□ "Ormanda kayboldum" → wilderness_survival.md seçilir
□ "Merhaba nasılsın?" → general_survival.md (fallback) seçilir
□ Web demo mode hâlâ çalışıyor
□ Flutter analyze hata vermiyor
□ 5 temel skill dosyası (TR) mevcut ve doğru formatta
```
