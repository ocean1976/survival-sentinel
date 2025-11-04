# Survival Sentinel - Cursor Devir-Teslim Dokümanı

**Tarih:** 3 Kasım 2025  
**Proje Durumu:** %30 Tamamlandı  
**GitHub:** https://github.com/ocean1976/survival-sentinel  
**Geliştirme Yaklaşımı:** Vibe Coding (Kullanıcı teknik bilgisi yok, doğal dille yönlendiriyor)

---

## 📋 İÇİNDEKİLER

1. [Proje Özeti](#proje-özeti)
2. [Teknik Mimari](#teknik-mimari)
3. [Dosya Yapısı](#dosya-yapısı)
4. [Kod Açıklamaları](#kod-açıklamaları)
5. [Tamamlanan İşler](#tamamlanan-işler)
6. [Kalan İşler](#kalan-işler)
7. [Cursor İçin Talimatlar](#cursor-için-talimatlar)
8. [Sorun Giderme](#sorun-giderme)

---

## 🎯 PROJE ÖZETİ

### Uygulama Adı
**Survival Sentinel: Offline AI**

### Konsept
Acil durumlarda kullanılabilecek, **tamamen offline** çalışan AI destekli hayatta kalma rehberi uygulaması.

### Temel Özellikler
1. **Offline AI:** Microsoft Phi-3 Mini modeli (2.3 GB, GGUF format)
2. **Freemium Model:** 20 ücretsiz soru, sonra ödeme
3. **SOS Modu:** 48 saat ücretsiz sınırsız erişim
4. **Retro Military Tasarım:** Terminal tarzı, askeri estetik
5. **Çoklu Dil:** Türkçe ve İngilizce

### Hedef Platform
- **Birincil:** Android (API 21+)
- **İkincil:** iOS (gelecekte)
- **Test:** Web (demo mode)

### Hedef Kitle
- Doğa sporları yapanlar
- Kamp/trekking meraklıları
- Acil durum hazırlığı yapanlar
- Hayatta kalma bilgisi arayanlar

---

## 🏗️ TEKNİK MİMARİ

### Framework & Dil
- **Framework:** Flutter 3.24.0+
- **Dil:** Dart 3.5.4+
- **Platform:** Cross-platform (Android, iOS, Web)

### AI Model
- **Model:** Microsoft Phi-3-mini-4k-instruct
- **Format:** GGUF (Q4 quantization)
- **Boyut:** 2.23 GB
- **Kütüphane:** `llama_cpp_dart` (v0.0.9)
- **Context:** 4096 tokens
- **Threads:** 4

### Mimari Pattern
**Platform-Specific Architecture:**
```
ai_service.dart (Interface)
    ├── ai_service_mobile.dart (Android/iOS - Real AI)
    └── ai_service_web.dart (Web - Mock AI)
```

**Neden?**
- `llama_cpp_dart` native C++ kütüphanesi kullanıyor
- Web'de çalışmaz (WebAssembly desteği yok)
- Conditional imports ile platform ayrımı yapılıyor

### Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  llama_cpp_dart: ^0.0.9      # AI model için
  path_provider: ^2.1.5        # Dosya yolları için
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

### Assets
```yaml
assets:
  - assets/models/phi-3-mini-4k-instruct-q4.gguf
```

**NOT:** Model dosyası GitHub'da YOK (`.gitignore`'da), 2.3 GB çok büyük.

---

## 📁 DOSYA YAPISI

```
survival_sentinel/
│
├── lib/
│   ├── main.dart                    # Ana uygulama, UI kodu
│   ├── ai_service.dart              # AI service interface
│   ├── ai_service_mobile.dart       # Mobil AI implementasyonu
│   └── ai_service_web.dart          # Web mock implementasyonu
│
├── assets/
│   └── models/
│       ├── .gitkeep                 # Klasör Git'te kalması için
│       └── phi-3-mini-4k-instruct-q4.gguf  # AI model (local'de)
│
├── .github/
│   └── workflows/
│       └── build-apk.yml            # GitHub Actions (şu an çalışmıyor)
│
├── android/                         # Android platform kodu
├── ios/                             # iOS platform kodu (boş)
├── web/                             # Web platform kodu
│
├── pubspec.yaml                     # Paket yapılandırması
├── .gitignore                       # Git ignore kuralları
├── .gitattributes                   # Git LFS yapılandırması
│
├── PROJE_DURUMU.md                  # Proje durumu raporu
├── OTURUM_OZETI.md                  # Oturum özeti
├── RAG_DOKUMAN_SABLONU.md           # RAG doküman şablonu
└── README.md                        # Proje açıklaması (yok, eklenecek)
```

---

## 💻 KOD AÇIKLAMALARI

### 1. main.dart (Ana Uygulama)

**Satır Sayısı:** ~400  
**Sorumluluklar:**
- UI rendering
- Chat arayüzü
- Kullanıcı etkileşimleri
- AI service ile iletişim

**Önemli Sınıflar:**

#### `SurvivalSentinelApp` (StatelessWidget)
```dart
class SurvivalSentinelApp extends StatelessWidget {
  // MaterialApp yapılandırması
  // Tema: Courier font, #D6D9D0 background
  // Mobile-first: maxWidth 480px
}
```

#### `ChatScreen` (StatefulWidget)
```dart
class ChatScreen extends StatefulWidget {
  // Ana chat ekranı
  // State management
}
```

#### `_ChatScreenState` (State)
**Önemli değişkenler:**
```dart
final AIService _aiService = AIService();  // AI servisi
bool _isSOSActive = false;                 // SOS modu (henüz fonksiyonel değil)
bool _isLoading = false;                   // Yükleme durumu
bool _isModelLoaded = false;               // Model yüklendi mi?
List<ChatMessage> _messages = [];          // Mesaj listesi
```

**Önemli metodlar:**
```dart
void _initializeAI()              // Model yükleme
void _sendMessage()               // Mesaj gönderme
void _addMessage()                // Mesaj ekleme
void _scrollToBottom()            // Scroll kontrolü
```

**UI Bileşenleri:**
```dart
Widget _buildHeader()             // Üst bar (logo, SOS butonu)
Widget _buildChatArea()           // Mesaj listesi
Widget _buildInputArea()          // Mesaj giriş alanı
Widget _buildUserMessage()        // Kullanıcı mesajı balonu
Widget _buildAIResponse()         // AI cevap balonu
Widget _buildTypingIndicator()    // "Thinking..." göstergesi
Widget _buildLoadingScreen()      // Model yükleme ekranı
```

#### `LighthousePainter` (CustomPainter)
```dart
class LighthousePainter extends CustomPainter {
  // Deniz feneri ikonu çizimi
  // CustomPaint ile vektörel çizim
  // Renk: #2E402F (koyu yeşil), #F8E58A (sarı)
}
```

**Tasarım Sistemi:**
```dart
// Renk Paleti
Color(0xFFD6D9D0)  // Background (açık gri)
Color(0xFFF5F1E6)  // Chat panel (krem)
Color(0xFF2E402F)  // Dark green (koyu yeşil)
Color(0xFFD67B37)  // Orange (turuncu)
Color(0xFFD9534F)  // Red (kırmızı)

// Font
fontFamily: 'Courier'  // Terminal hissi
```

---

### 2. ai_service.dart (Interface)

**Satır Sayısı:** ~30  
**Sorumluluk:** Platform-agnostic AI service interface

```dart
class AIService {
  late final AIServicePlatform _platform;
  bool _isInitialized = false;

  AIService() {
    // Conditional import ile platform seçimi
    _platform = AIServicePlatform();
  }

  Future<void> initialize() async {
    // Model yükleme
  }

  Future<String> generateResponse(String prompt) async {
    // AI cevap üretme
  }

  void dispose() {
    // Cleanup
  }
}
```

**Conditional Import:**
```dart
import 'ai_service_mobile.dart' if (dart.library.html) 'ai_service_web.dart';
```

**Nasıl çalışır?**
- Dart compiler platform'u tespit eder
- Mobile: `ai_service_mobile.dart` import edilir
- Web: `ai_service_web.dart` import edilir

---

### 3. ai_service_mobile.dart (Mobil AI)

**Satır Sayısı:** ~70  
**Sorumluluk:** Gerçek Phi-3 AI implementasyonu

```dart
class AIServicePlatform {
  LlamaCpp? _llama;

  Future<void> initialize() async {
    // 1. Model dosyasını asset'ten geçici dizine kopyala
    final tempDir = await getTemporaryDirectory();
    final modelPath = '${tempDir.path}/phi-3-mini-4k-instruct-q4.gguf';
    
    if (!await File(modelPath).exists()) {
      final data = await rootBundle.load('assets/models/...');
      await File(modelPath).writeAsBytes(bytes);
    }

    // 2. LlamaCpp instance oluştur
    _llama = LlamaCpp(
      modelPath: modelPath,
      contextSize: 2048,    // Token limiti
      threads: 4,           // CPU thread sayısı
    );
  }

  Future<String> generateResponse(String prompt) async {
    // Phi-3 özel prompt formatı
    final formattedPrompt = '''<|system|>
You are an emergency survival assistant...
<|end|>
<|user|>
$prompt<|end|>
<|assistant|>
''';

    final response = await _llama!.complete(
      formattedPrompt,
      maxTokens: 512,
      temperature: 0.7,
      topP: 0.9,
      stopSequences: ['<|end|>', '<|user|>'],
    );

    return response.trim();
  }
}
```

**Önemli Parametreler:**
- `contextSize: 2048` - Bellek optimizasyonu için 4k yerine 2k
- `threads: 4` - Çoğu mobil cihazda optimal
- `temperature: 0.7` - Yaratıcılık vs tutarlılık dengesi
- `topP: 0.9` - Nucleus sampling

---

### 4. ai_service_web.dart (Web Mock)

**Satır Sayısı:** ~25  
**Sorumluluk:** Web için demo AI

```dart
class AIServicePlatform {
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock initialization
  }

  Future<String> generateResponse(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    return '''🌐 WEB DEMO MODE
This is a demo response. Real AI only works on Android/iOS.
Your question: "$prompt"''';
  }

  void dispose() {
    // No-op
  }
}
```

---

### 5. .github/workflows/build-apk.yml

**Durum:** ❌ Çalışmıyor  
**Sorun:** Native build issues (llama_cpp_dart)

```yaml
name: Build Android APK

on:
  push:
    branches: [ master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v4
      
    - name: Set up Java
      uses: actions/setup-java@v4
      with:
        distribution: 'zulu'
        java-version: '17'
        
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        channel: 'stable'
    
    - name: Create model directory
      run: mkdir -p assets/models
    
    - name: Download Phi-3 model
      run: |
        wget https://huggingface.co/.../phi-3-mini-4k-instruct-q4.gguf \
          -O assets/models/phi-3-mini-4k-instruct-q4.gguf
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Build APK
      run: flutter build apk --release
      
    - name: Upload APK artifact
      uses: actions/upload-artifact@v4
      with:
        name: survival-sentinel-release
        path: build/app/outputs/flutter-apk/app-release.apk
```

**Neden başarısız?**
- `llama_cpp_dart` native C++ kütüphanesi
- GitHub Actions'ta NDK yapılandırması eksik
- Build APK adımında hata veriyor

**Çözüm:** Local build (Flutter SDK + Android Studio)

---

## ✅ TAMAMLANAN İŞLER

### 1. Proje Altyapısı
- [x] Flutter projesi oluşturuldu
- [x] GitHub repository kuruldu
- [x] Version control aktif
- [x] `.gitignore` yapılandırıldı
- [x] Git LFS yapılandırıldı (kullanılmadı)

### 2. UI/UX Tasarımı
- [x] Retro military terminal tasarımı
- [x] Renk paleti belirlendi
- [x] Custom lighthouse icon (CustomPaint)
- [x] Chat arayüzü kodlandı
- [x] Responsive design (maxWidth: 480px)
- [x] Loading states
- [x] Typing indicator

### 3. AI Entegrasyonu
- [x] Phi-3 Mini modeli indirildi (2.3 GB)
- [x] `llama_cpp_dart` paketi eklendi
- [x] Platform-specific architecture
- [x] Model yükleme kodu
- [x] AI chat fonksiyonalitesi
- [x] Phi-3 prompt formatı
- [x] Web demo mode

### 4. Deployment
- [x] Web preview deploy edildi
- [x] GitHub Actions workflow oluşturuldu (çalışmıyor)

### 5. Dokümantasyon
- [x] Proje durumu raporu
- [x] Oturum özeti
- [x] RAG doküman şablonu
- [x] Kalan işler listesi
- [x] Cursor devir-teslim dokümanı

---

## ❌ KALAN İŞLER (Öncelik Sırasına Göre)

### 🔴 KRİTİK ÖNCELİK

#### 1. APK Build & Test
**Durum:** Yapılmadı  
**Zorluk:** ⭐⭐⭐⭐☆  
**Süre:** 1-2 saat (ilk kez)

**Gereksinimler:**
- Flutter SDK kurulumu
- Android Studio kurulumu
- Android SDK yapılandırması
- Model dosyası (2.3 GB)

**Adımlar:**
1. Flutter SDK kur (https://docs.flutter.dev/get-started/install)
2. Android Studio kur
3. `flutter doctor` çalıştır, eksikleri tamamla
4. Projeyi clone et: `git clone https://github.com/ocean1976/survival-sentinel.git`
5. Model dosyasını `assets/models/` klasörüne kopyala
6. `flutter pub get` çalıştır
7. Android cihaz/emulator bağla
8. `flutter build apk --release` çalıştır
9. APK'yı test et

**Beklenen Sonuç:**
- APK dosyası: `build/app/outputs/flutter-apk/app-release.apk`
- Boyut: ~2.5 GB (model dahil)

**Olası Sorunlar:**
- Dart SDK version mismatch → `flutter upgrade`
- Android SDK not found → Android Studio'da SDK Manager
- Model yükleme hatası → Dosya yolu kontrolü
- Build timeout → Sabırlı ol, 10-15 dakika sürebilir

---

#### 2. Tasarım Düzenlemeleri
**Durum:** Mockup istenen gibi değil  
**Zorluk:** ⭐⭐⭐☆☆  
**Süre:** 2-3 saat

**Yapılacaklar:**
- [ ] Mockup ile mevcut tasarımı karşılaştır
- [ ] Renk tonlarını ayarla
- [ ] İkon boyutlarını düzenle
- [ ] Font boyutlarını optimize et
- [ ] Spacing/padding düzeltmeleri
- [ ] Animasyon iyileştirmeleri

**Gerekli:**
- Mockup ekran görüntüleri
- İstenen değişikliklerin listesi

**Dosyalar:**
- `lib/main.dart` (tüm UI kodu burada)

---

### 🟡 YÜKSEK ÖNCELİK

#### 3. 20 Soru Limiti Sistemi
**Zorluk:** ⭐⭐⭐☆☆  
**Süre:** 3-4 saat

**Teknik Yaklaşım:**
```dart
// shared_preferences paketi ekle
import 'package:shared_preferences/shared_preferences.dart';

class QuestionCounter {
  static const String _key = 'question_count';
  static const int _limit = 20;

  Future<int> getCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  Future<void> increment() async {
    final prefs = await SharedPreferences.getInstance();
    final count = await getCount();
    await prefs.setInt(_key, count + 1);
  }

  Future<bool> hasReachedLimit() async {
    return await getCount() >= _limit;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, 0);
  }
}
```

**Entegrasyon:**
```dart
// _sendMessage() metodunda
Future<void> _sendMessage() async {
  if (await _questionCounter.hasReachedLimit() && !_isPremium) {
    _showPaywallDialog();
    return;
  }
  
  await _questionCounter.increment();
  // ... normal flow
}
```

**UI:**
- Kalan soru sayısı göstergesi (header'da)
- Paywall dialog (20 soru dolunca)
- "Satın Al" butonu

---

#### 4. SOS 48 Saat Modu
**Zorluk:** ⭐⭐⭐☆☆  
**Süre:** 3-4 saat

**Teknik Yaklaşım:**
```dart
class SOSMode {
  static const String _keyActive = 'sos_active';
  static const String _keyExpiry = 'sos_expiry';
  static const Duration _duration = Duration(hours: 48);

  Future<void> activate() async {
    final prefs = await SharedPreferences.getInstance();
    final expiry = DateTime.now().add(_duration);
    
    await prefs.setBool(_keyActive, true);
    await prefs.setString(_keyExpiry, expiry.toIso8601String());
  }

  Future<bool> isActive() async {
    final prefs = await SharedPreferences.getInstance();
    final active = prefs.getBool(_keyActive) ?? false;
    
    if (!active) return false;
    
    final expiryStr = prefs.getString(_keyExpiry);
    if (expiryStr == null) return false;
    
    final expiry = DateTime.parse(expiryStr);
    if (DateTime.now().isAfter(expiry)) {
      await deactivate();
      return false;
    }
    
    return true;
  }

  Future<Duration> getRemainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryStr = prefs.getString(_keyExpiry);
    if (expiryStr == null) return Duration.zero;
    
    final expiry = DateTime.parse(expiryStr);
    return expiry.difference(DateTime.now());
  }

  Future<void> deactivate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyActive);
    await prefs.remove(_keyExpiry);
  }
}
```

**UI:**
- SOS butonu fonksiyonelliği
- Countdown timer gösterimi
- "SOS Aktif" göstergesi

---

#### 5. Settings Ekranı
**Zorluk:** ⭐⭐⭐☆☆  
**Süre:** 4-5 saat

**Yeni Dosya:** `lib/settings_screen.dart`

```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // Dil Seçimi
          ListTile(
            title: Text('Language'),
            subtitle: Text('English'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => _showLanguageDialog(context),
          ),
          
          Divider(),
          
          // Privacy Policy
          ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.open_in_new),
            onTap: () => _launchURL('https://...'),
          ),
          
          // Terms of Use
          ListTile(
            title: Text('Terms of Use'),
            trailing: Icon(Icons.open_in_new),
            onTap: () => _launchURL('https://...'),
          ),
          
          Divider(),
          
          // About
          ListTile(
            title: Text('About'),
            subtitle: Text('Version 1.0.0'),
            onTap: () => _showAboutDialog(context),
          ),
          
          // Satın Alma Durumu
          ListTile(
            title: Text('Purchase Status'),
            subtitle: Text(_isPremium ? 'Premium' : 'Free (20 questions)'),
          ),
        ],
      ),
    );
  }
}
```

**main.dart'ta:**
```dart
// Settings ikonu tıklanınca
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SettingsScreen()),
  );
}
```

---

#### 6. Dil Değiştirme (TR/EN)
**Zorluk:** ⭐⭐⭐⭐☆  
**Süre:** 5-6 saat

**Paket:** `flutter_localizations`

**pubspec.yaml:**
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
```

**Yeni Dosyalar:**
- `lib/l10n/app_en.arb` (İngilizce)
- `lib/l10n/app_tr.arb` (Türkçe)

**app_en.arb:**
```json
{
  "appTitle": "Survival Sentinel",
  "sosButton": "SOS",
  "messagePlaceholder": "Message",
  "thinking": "Thinking...",
  "loadingModel": "Loading AI model...",
  "settings": "Settings",
  "privacyPolicy": "Privacy Policy",
  "termsOfUse": "Terms of Use"
}
```

**app_tr.arb:**
```json
{
  "appTitle": "Hayatta Kalma Rehberi",
  "sosButton": "SOS",
  "messagePlaceholder": "Mesaj",
  "thinking": "Düşünüyor...",
  "loadingModel": "AI modeli yükleniyor...",
  "settings": "Ayarlar",
  "privacyPolicy": "Gizlilik Politikası",
  "termsOfUse": "Kullanım Şartları"
}
```

**main.dart:**
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: _selectedLocale, // SharedPreferences'ten yüklenecek
  // ...
)

// Kullanım:
Text(AppLocalizations.of(context)!.appTitle)
```

---

#### 7. Typing Animasyonu
**Zorluk:** ⭐⭐⭐☆☆  
**Süre:** 2-3 saat

**Teknik Yaklaşım:**
```dart
class TypingText extends StatefulWidget {
  final String text;
  final Duration speed;

  const TypingText({
    required this.text,
    this.speed = const Duration(milliseconds: 50),
  });

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayedText = '';
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText + (_currentIndex < widget.text.length ? '|' : ''),
      style: TextStyle(/* ... */),
    );
  }
}
```

**Kullanım:**
```dart
// _buildAIResponse() metodunda
TypingText(text: message.text)
```

---

### 🟢 ORTA ÖNCELİK

#### 8. Privacy Policy
**Zorluk:** ⭐⭐☆☆☆  
**Süre:** 2-3 saat

**Yaklaşım:**
1. Privacy Policy metni yaz (template kullan)
2. HTML sayfası oluştur
3. GitHub Pages'te yayınla
4. Link'i Settings'e ekle

**Template:** https://www.privacypolicygenerator.info/

**Gerekli Bilgiler:**
- Uygulama adı
- Geliştirici adı/şirket
- İletişim e-postası
- Toplanan veriler (minimal - offline app)
- Üçüncü taraf servisler (Google Play Billing)

---

#### 9. Terms of Use
**Zorluk:** ⭐⭐☆☆☆  
**Süre:** 2-3 saat

**Yaklaşım:**
1. Terms of Use metni yaz
2. HTML sayfası oluştur
3. GitHub Pages'te yayınla
4. Link'i Settings'e ekle

**Template:** https://www.termsofusegenerator.net/

---

#### 10. RAG Dokümanları
**Zorluk:** ⭐⭐⭐⭐☆  
**Süre:** 10-15 saat

**Şablon:** `RAG_DOKUMAN_SABLONU.md`

**Kategoriler:**
- Doğal Afetler (Deprem, Sel, Yangın, vb.)
- İlk Yardım (Kanama, Kırık, Yanık, vb.)
- Hayatta Kalma (Su bulma, Barınak, Ateş, vb.)
- Özel Durumlar (Kaybolma, Vahşi hayvan, vb.)

**Toplam:** 50-60 doküman

**RAG Sistemi:**
- Vektör veritabanı (Chroma, FAISS)
- Embedding model (sentence-transformers)
- Retrieval logic
- Context injection

**NOT:** Bu büyük bir iş, aşamalı yapılabilir.

---

### 🔵 DÜŞÜK ÖNCELİK

#### 11. In-App Purchase
**Zorluk:** ⭐⭐⭐⭐⭐  
**Süre:** 6-8 saat

**Paket:** `in_app_purchase`

**pubspec.yaml:**
```yaml
dependencies:
  in_app_purchase: ^3.1.11
```

**Google Play Console:**
1. Developer hesabı aç ($25)
2. Uygulama oluştur
3. In-app product oluştur
   - Product ID: `unlimited_access`
   - Fiyat: $4.99 (örnek)
   - Açıklama: "Sınırsız soru sorma"

**Kod:**
```dart
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  
  Future<void> buyProduct() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      {'unlimited_access'},
    );
    
    final product = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: product);
    
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
  
  Future<bool> isPremium() async {
    // Purchase verification logic
  }
}
```

**Güvenlik:**
- Server-side receipt validation (backend gerekli)
- Veya Google Play Billing Library

---

#### 12-14. Google Play, İkon, Optimizasyon
**Detaylar:** `KALAN_ISLER_LISTESI.md` dosyasında

---

## 🎯 CURSOR İÇİN TALİMATLAR

### Başlangıç Adımları

#### 1. Projeyi İndir
```bash
git clone https://github.com/ocean1976/survival-sentinel.git
cd survival-sentinel
```

#### 2. Model Dosyasını Ekle
```bash
# Model dosyasını Hugging Face'ten indir
# Veya kullanıcıdan al
# Konumu: assets/models/phi-3-mini-4k-instruct-q4.gguf
```

#### 3. Dependencies Yükle
```bash
flutter pub get
```

#### 4. Çalıştır
```bash
# Web (demo mode)
flutter run -d chrome

# Android (gerçek AI)
flutter run -d <device_id>
```

#### 5. Build
```bash
# APK
flutter build apk --release

# iOS (gelecekte)
flutter build ios --release
```

---

### Kod Değişikliği Yaparken

#### Tasarım Değişiklikleri
**Dosya:** `lib/main.dart`

**Renk değiştirme:**
```dart
// Mevcut:
Color(0xFFD6D9D0)  // Background

// Değiştirmek için:
// 1. Color kodunu bul (Ctrl+F)
// 2. Yeni renk kodunu yaz
// 3. Hot reload (r tuşu)
```

**Font değiştirme:**
```dart
// Mevcut:
fontFamily: 'Courier'

// Değiştirmek için:
// 1. pubspec.yaml'a font ekle
// 2. fontFamily değiştir
```

**Spacing değiştirme:**
```dart
// Padding/Margin değerlerini ayarla
EdgeInsets.symmetric(horizontal: 20, vertical: 14)
```

---

#### Yeni Özellik Eklerken

**Örnek: 20 Soru Limiti**

1. **Paket ekle:**
```yaml
# pubspec.yaml
dependencies:
  shared_preferences: ^2.2.2
```

2. **Service oluştur:**
```dart
// lib/services/question_counter.dart
class QuestionCounter {
  // ... kod yukarıda
}
```

3. **main.dart'a entegre et:**
```dart
class _ChatScreenState extends State<ChatScreen> {
  final QuestionCounter _counter = QuestionCounter();
  
  Future<void> _sendMessage() async {
    if (await _counter.hasReachedLimit()) {
      _showPaywall();
      return;
    }
    await _counter.increment();
    // ... devam
  }
}
```

4. **Test et:**
```bash
flutter run
# 20 soru sor
# Paywall görmeli
```

---

### Hata Ayıklama

#### "Model yüklenemedi" Hatası
```dart
// ai_service_mobile.dart'ta log ekle
print('Model path: $modelPath');
print('File exists: ${await File(modelPath).exists()}');
```

#### "Dart SDK version mismatch"
```bash
flutter upgrade
flutter pub get
```

#### "Build failed"
```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

### Test Senaryoları

#### 1. UI Testi
- [ ] Uygulama açılıyor mu?
- [ ] Deniz feneri ikonu görünüyor mu?
- [ ] SOS butonu var mı?
- [ ] Mesaj gönderme çalışıyor mu?

#### 2. AI Testi
- [ ] Model yükleniyor mu?
- [ ] AI cevap veriyor mu?
- [ ] Cevaplar mantıklı mı?
- [ ] Offline çalışıyor mu? (interneti kapat)

#### 3. Özellik Testi
- [ ] 20 soru limiti çalışıyor mu?
- [ ] SOS modu aktif oluyor mu?
- [ ] Settings açılıyor mu?
- [ ] Dil değişiyor mu?

---

## 🐛 SORUN GİDERME

### Problem: Flutter SDK bulunamadı
**Çözüm:**
```bash
# PATH'e ekle
export PATH="$PATH:/path/to/flutter/bin"

# Veya Windows'ta:
# Sistem Değişkenleri → Path → Ekle
```

---

### Problem: Android SDK bulunamadı
**Çözüm:**
1. Android Studio'yu aç
2. Tools → SDK Manager
3. Android SDK yükle
4. ANDROID_HOME ortam değişkenini ayarla

---

### Problem: Model dosyası çok büyük
**Çözüm:**
- Q3 quantization kullan (daha küçük)
- Veya on-demand download (ilk açılışta indir)

---

### Problem: APK çok büyük (>2.5 GB)
**Çözüm:**
- Normal! Model 2.3 GB
- ProGuard ile küçültme (minimal etki)
- App Bundle kullan (Google Play)

---

### Problem: AI çok yavaş
**Çözüm:**
```dart
// threads sayısını artır
LlamaCpp(
  modelPath: modelPath,
  contextSize: 2048,
  threads: 6,  // 4 yerine 6
);
```

---

### Problem: Memory leak
**Çözüm:**
```dart
@override
void dispose() {
  _aiService.dispose();  // Mutlaka dispose et
  super.dispose();
}
```

---

## 📚 KAYNAKLAR

### Dokümantasyon
- Flutter: https://docs.flutter.dev
- Dart: https://dart.dev/guides
- llama_cpp_dart: https://pub.dev/packages/llama_cpp_dart
- Phi-3: https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf

### GitHub
- Repository: https://github.com/ocean1976/survival-sentinel
- Issues: https://github.com/ocean1976/survival-sentinel/issues

### Manus Oturum
- Oturum Özeti: `OTURUM_OZETI.md`
- Proje Durumu: `PROJE_DURUMU.md`
- Kalan İşler: `KALAN_ISLER_LISTESI.md`

---

## 🎯 CURSOR İÇİN ÖZETİ PROMPT

**Cursor'a şunu söyle:**

```
Survival Sentinel projesini devralıyorum. 

Proje Bilgileri:
- Flutter/Dart cross-platform app
- Offline AI (Phi-3 Mini, 2.3 GB GGUF)
- Freemium model (20 free questions)
- Retro military terminal design
- %30 tamamlandı

GitHub: https://github.com/ocean1976/survival-sentinel

Yapılacaklar:
1. APK build (Flutter SDK + Android Studio gerekli)
2. Tasarım düzenlemeleri (mockup'a göre)
3. 20 soru limiti sistemi
4. SOS 48 saat modu
5. Settings ekranı
6. Dil değiştirme (TR/EN)
7. Typing animasyonu
8. Privacy Policy & Terms
9. RAG dokümanları
10. In-App Purchase
11. Google Play yayınlama

Öncelik: APK build → Tasarım → Özellikler

Detaylı bilgi: CURSOR_DEVIR_TESLIM.md dosyasında.

Başlayalım!
```

---

## ✅ KONTROL LİSTESİ

Cursor'un yapması gerekenler:

- [ ] Projeyi GitHub'dan clone et
- [ ] Flutter SDK kurulumunu kontrol et
- [ ] Model dosyasını assets/models/ klasörüne ekle
- [ ] `flutter pub get` çalıştır
- [ ] Web'de test et (`flutter run -d chrome`)
- [ ] APK build et (`flutter build apk --release`)
- [ ] Tasarım düzenlemelerini yap
- [ ] Özellikleri ekle (20 soru, SOS, Settings)
- [ ] Dil desteği ekle (TR/EN)
- [ ] Privacy Policy & Terms hazırla
- [ ] In-App Purchase entegre et
- [ ] Google Play'e yükle

---

**Devir-Teslim Tamamlandı!**  
**Tarih:** 3 Kasım 2025  
**Manus → Cursor**  
**Başarılar! 🚀**
