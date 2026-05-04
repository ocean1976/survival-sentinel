# Haven Protocol — Claude Code Project Instructions

**Proje:** Survival Sentinel: Offline AI Survival Assistant  
**App İsmi:** Haven Protocol: Survival AI (Subtitle: Offline Emergency Guide)  
**Platform:** Android & iOS (Flutter/Dart)  
**AI Model:** Google Gemma 4 (GGUF, on-device, offline)  
**Repo:** https://github.com/ocean1976/survival-sentinel  
**Son Güncelleme:** Nisan 2026

---

## 1. PROJE ÖZETİ

Survival Sentinel, internet bağlantısı olmadan çalışan, afet ve acil durum senaryolarında kullanıcılara hayatta kalma rehberliği sunan bir mobil AI asistanıdır. Uygulama tamamen offline çalışır; on-device Gemma 4 modeli ve önceden hazırlanmış skill dosyaları ile kullanıcının sorularına bağlam-duyarlı yanıtlar üretir.

### Temel Felsefe
- **%100 Offline**: İnternet gerektirmez. Afet anında çalışmalıdır.
- **Hayat Kurtaran Bilgi**: Halüsinasyon minimize edilmeli, bilgi doğrulanmış kaynaklara dayanmalıdır.
- **Minimal Kaynak**: Telefon pili ve RAM tasarrufu önceliklidir.
- **Erişilebilirlik**: Panik halindeki bir insan bile kullanabilmeli.

---

## 2. TEKNİK MİMARİ

### 2.1 Tech Stack
```
Framework:      Flutter (Dart)
AI Model:       Google Gemma 4 (GGUF quantized, ~2-3 GB)
AI Runtime:     llama_cpp_dart (v0.0.9+)
State Mgmt:     setState (basit) veya Riverpod (ilerisi için)
Local Storage:  shared_preferences + path_provider
Platform:       Android (öncelik), iOS (sonra)
```

### 2.2 Dizin Yapısı
```
survival-sentinel/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app.dart                     # App widget, theme, routes
│   ├── services/
│   │   ├── ai_service.dart          # Abstract AI service interface
│   │   ├── ai_service_mobile.dart   # Gerçek Gemma 4 inference (Android/iOS)
│   │   ├── ai_service_web.dart      # Demo/mock mode (web preview)
│   │   └── skill_router.dart        # ⭐ YENİ: Kullanıcı sorusunu analiz edip doğru skill dosyasını seçer
│   ├── models/
│   │   ├── message.dart             # Chat message model
│   │   ├── skill.dart               # Skill dosyası model
│   │   └── app_state.dart           # Uygulama durumu (soru sayacı, SOS timer vb.)
│   ├── screens/
│   │   ├── chat_screen.dart         # Ana sohbet ekranı
│   │   ├── settings_screen.dart     # Ayarlar
│   │   ├── onboarding_screen.dart   # İlk açılış / model indirme
│   │   └── sos_screen.dart          # SOS modu
│   ├── widgets/
│   │   ├── message_bubble.dart      # Chat baloncuğu
│   │   ├── typing_indicator.dart    # Typing animasyonu
│   │   ├── sos_button.dart          # SOS butonu
│   │   └── lighthouse_icon.dart     # Custom deniz feneri ikonu
│   └── utils/
│       ├── constants.dart           # Renkler, fontlar, sabitler
│       ├── prompt_builder.dart      # ⭐ YENİ: System prompt + skill context birleştirici
│       └── localization.dart        # TR/EN dil desteği
├── assets/
│   ├── models/                      # Gemma 4 GGUF model dosyası (gitignore'da)
│   └── skills/                      # ⭐ YENİ: Skill dosyaları (Markdown)
│       ├── earthquake.md
│       ├── fire_wildfire.md
│       ├── flood.md
│       ├── nuclear.md
│       ├── pandemic.md
│       ├── volcano.md
│       ├── civil_unrest.md
│       ├── wilderness_survival.md
│       ├── first_aid.md
│       ├── water_purification.md
│       ├── shelter_building.md
│       ├── navigation.md
│       ├── fire_making.md
│       ├── edible_plants.md
│       ├── signaling.md
│       ├── psychology.md
│       ├── winter_survival.md
│       ├── desert_survival.md
│       ├── tropical_survival.md
│       └── urban_survival.md
├── android/
├── ios/
├── test/
├── pubspec.yaml
└── README.md
```

### 2.3 Skill Router Sistemi (RAG Yerine)

Eski mimari RAG (vektör DB + embedding) kullanıyordu. Yeni mimari daha basit ve offline-friendly:

```
Kullanıcı Sorusu
      │
      ▼
┌─────────────┐
│ SkillRouter  │ ← Keyword/intent matching ile doğru skill dosyasını seçer
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ PromptBuilder│ ← System prompt + seçilen skill içeriği + kullanıcı sorusu
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Gemma 4    │ ← On-device inference
└──────┬──────┘
       │
       ▼
   AI Yanıtı
```

**SkillRouter mantığı:**
1. Kullanıcı mesajındaki anahtar kelimeleri çıkar
2. Her skill dosyasının `keywords` listesiyle eşleştir
3. En yüksek eşleşme skoruna sahip skill(ler)i seç
4. Birden fazla skill gerekiyorsa, context window'a sığacak şekilde birleştir
5. Hiçbir skill eşleşmezse, genel hayatta kalma skill'ini kullan

**Skill dosyası formatı (Markdown):**
```markdown
---
id: earthquake
title: Deprem Hayatta Kalma Rehberi
keywords: [deprem, earthquake, sarsıntı, çökme, enkaz, artçı, bina, yıkım]
priority: high
language: tr
max_tokens: 1500
source: FEMA P-2064, FM 21-76, Ready.gov
---

# Deprem Anında Hayatta Kalma

## DEPREM SIRASINDA (İlk 0-60 saniye)
- ÇÖK-KAPAN-TUTUN: Yere çök, sağlam bir masanın altına gir, tutun.
- Dışarıdaysan: Binalardan, ağaçlardan, elektrik direklerinden uzaklaş.
...
```

### 2.4 AI Model Değişikliği: Phi-3 → Gemma 4

Mevcut kodda `ai_service_mobile.dart` Phi-3 prompt formatı kullanıyor. Gemma 4'e geçiş:

```dart
// ESKİ (Phi-3):
// final prompt = '<|system|>\n$systemPrompt<|end|>\n<|user|>\n$userMessage<|end|>\n<|assistant|>';

// YENİ (Gemma 4):
// Gemma 4'ün GGUF sürümüne göre prompt formatı güncellenecek.
// Gemma 2/4 chat template:
// <start_of_turn>user\n{message}<end_of_turn>\n<start_of_turn>model\n
final prompt = '<start_of_turn>user\n$systemPrompt\n\n$skillContext\n\nKullanıcı Sorusu: $userMessage<end_of_turn>\n<start_of_turn>model\n';
```

---

## 3. TASARIM PRENSİPLERİ

### 3.1 Görsel Stil
- **Retro military terminal** estetiği
- Monospace font (Courier / JetBrains Mono)
- Earth tones renk paleti:
  - Arka plan: `#D6D9D0` (açık haki)
  - Kağıt/kart: `#F5F1E6` (krem)
  - Ana yeşil: `#2E402F` (koyu askeri yeşil)
  - Vurgu turuncu: `#D67B37`
  - Tehlike kırmızı: `#D9534F`
- Custom deniz feneri (lighthouse) ikonu — CustomPaint ile

### 3.2 UX Kuralları
- Panik modunda kullanılabilirlik: Büyük butonlar, net metin, yüksek kontrast
- SOS butonu her zaman erişilebilir
- AI yanıtları terminal-tarzı typing animasyonu ile
- Offline olduğunu kullanıcıya açıkça göster (güven verici)
- Maksimum 2 tap ile kritik bilgiye ulaşılmalı

---

## 4. ÖZELLİKLER VE İŞ KURALLARI

### 4.1 Uygulama Konsepti
- Uygulama SADECE AI chat arayüzüdür. Statik rehber/okuma modu YOKTUR.
- Skill dosyaları kullanıcıya hiçbir zaman doğrudan gösterilmez.
- Skill dosyaları yalnızca Gemma 4'ün bağlamı (context) olarak kullanılır.
- Kullanıcı sorar → AI yanıtlar. Bu kadar.

### 4.2 Gelir Modeli (Freemium)
- **Ücretsiz:** 5 soru/gün (her gece sıfırlanır)
- **SOS modu:** 72 saat sınırsız (acil durumlar için)
- **Premium:** $4.99 tek seferlik, sınırsız soru
- Sayaç `shared_preferences` ile local'de tutulur

### 4.3 SOS Modu
- SOS butonu HER ZAMAN görünür (premium dahil)
- Ücretsiz kullanıcı basınca → 72 saat sınırsız erişim başlar
- Premium kullanıcı basınca → zaten sınırsız, ekstra etkisi yok
- Geri sayım timer gösterilir
- Süre bitince normal moda döner
- **Suistimali önleme:**
  - Cihaz başına 30 günde 1 kez kullanılabilir
  - İkinci kullanımda 60 gün bekleme süresi
  - Onay ekranı: "Bu özellik gerçek acil durumlar içindir. Devam?"
  - Kullanıcı uygulamayı silip tekrar yüklerse sıfırlanır (kabul edilebilir)

### 4.4 Dil Desteği
- Türkçe (varsayılan) ve İngilizce
- Skill dosyaları İngilizce (MVP). Gemma 4 kullanıcının diline çevirir.
- Türkçe yanıt kalitesi yetersizse ileride TR skill dosyaları eklenir.
- UI metinleri `localization.dart` üzerinden yönetilir
- AI system prompt dil seçimine göre değişir

---

## 5. MODEL İNDİRME STRATEJİSİ

Model (~2-3 GB) APK içine gömülemez. Strateji:

```
İlk Açılış → Onboarding Ekranı → "Model İndir" butonu → WiFi kontrolü →
İndirme (progress bar) → Doğrulama (checksum) → Hazır
```

- Model `getApplicationDocumentsDirectory()` altına kaydedilir
- İndirme sırasında resume/retry desteklenmeli
- Bir kez indirilince tekrar gerekmez
- Checksum doğrulaması yapılmalı

---

## 6. KURAL VE KISITLAMALAR

### Yapılmaması Gerekenler
- ❌ İnternet bağlantısı gerektiren bir özellik ekleme (core flow'da)
- ❌ Kullanıcı verisini sunucuya gönderme
- ❌ Tıbbi teşhis koyma veya kesin tıbbi tavsiye verme
- ❌ Model dosyasını Git repo'ya commit etme (gitignore'da)
- ❌ Skill dosyalarının içeriğini hardcode etme; her zaman assets'ten oku

### Yapılması Gerekenler
- ✅ Her AI yanıtının sonuna "Bu bilgi profesyonel yardımın yerini almaz" disclaimeri ekle
- ✅ Skill dosyalarının kaynağını belirt (FEMA, FM 21-76, CDC vb.)
- ✅ Pil tasarrufu: Model kullanılmadığında unload et
- ✅ Crash recovery: Chat geçmişini local'de sakla
- ✅ Erişilebilirlik: Büyük font, yüksek kontrast destekle

### Pil Optimizasyonu (KRİTİK — afette pil = hayat)

**AI Model yönetimi:**
- Model yalnızca kullanıcı soru sorduğunda aktif olmalı
- Yanıt üretildikten sonra `_llama?.dispose()` ile RAM'den çıkar
- Yeni soru geldiğinde tekrar yüklenir (2-3 saniye ek gecikme kabul edilebilir)
- `contextSize: 2048` — daha büyük yapma, pil yer
- `threads: 4` — cihaz çekirdeğinden fazla thread açma

```dart
// Yanıt üretildikten sonra:
Future<String> generateResponse(String prompt) async {
  await _loadModelIfNeeded();      // Lazım olduğunda yükle
  final response = await _llama!.complete(...);
  await _unloadModelIfIdle();      // 60 saniye inaktivite sonrası boşalt
  return response;
}
```

**Ekran:**
- Koyu tema varsayılan (OLED ekranlarda %30-40 pil tasarrufu)
- Settings'te açık/koyu tema seçimi
- Ekran otomatik kararması: 30 saniye inaktivitede parlaklık düşür
- Typing animasyonu hafif tutulur (ağır animasyon yok)

**Genel kurallar:**
- Arka plan servisi YASAK — app kapanınca hiçbir şey çalışmamalı
- GPS, Bluetooth, WiFi, kamera KULLANMA
- Bildirim sistemi EKLEME
- Wake lock KULLANMA (ekranı açık tutma)
- Ağır görseller/animasyonlar EKLEME

---

## 6.5 TIBBİ İÇERİK VE HUKUKİ KORUMA

### Tıbbi İçerik Kuralları

**6 medikal senaryo** (tıbbi listemiz 12'den 6'ya indirildi — yanlış müdahale riskini azaltmak için):

1. `severe_bleeding.md` — Kanama durdurma (basınç, turnike son çare)
2. `cpr.md` — CPR (AHA 2020+ protokolü, kompresyon-odaklı)
3. `choking.md` — Heimlich manevrası (yetişkin + çocuk)
4. `burns_first_aid.md` — Yanık ilk müdahale (1-2-3. derece)
5. `hypothermia_heatstroke.md` — Hipotermi ve sıcak çarpması
6. `shock_position.md` — Şok pozisyonu

**ÇIKARILAN tıbbi senaryolar (yüksek risk):**
- ❌ Snakebite (yılan sokması) — ülkeden ülkeye değişir, yanlış antikor riski
- ❌ Childbirth (doğum) — çok karmaşık, profesyonel gerekir
- ❌ Anaphylaxis (anafilaksi) — ilaç dozajı (epinefrin) gerektirir
- ❌ Fractures (kırık sabitleme) — yanlış sabitleme zarar verir
- ❌ CPR for infants — yetişkinden farklı, yanlış uygulama ölümcül
- ❌ Drug overdose — ilaç bilgisi gerektirir

### AI Kuralları (system_prompt'ta da var)
- ASLA tanı koyma
- ASLA ilaç dozajı verme
- ASLA "hastaneye gerek yok" deme
- Her tıbbi yanıtın başında ve sonunda 112/acil çağrı uyarısı

### Hukuki Koruma

**Privacy Policy ve Terms of Service'e ekle:**
- "Educational and informational purposes only"
- "Not a substitute for medical, legal, or professional advice"
- "User assumes all risk"
- "No warranty for accuracy in life-threatening situations"
- "Always contact emergency services first"

**App Store Kategorisi:**
- ❌ "Medical" veya "Health & Fitness" KATEGORİSİNE GİRME
- ✅ Doğru kategori: **"Reference"** veya **"Lifestyle"** veya **"Education"**
- Açıklamada: "An educational reference for emergency preparedness"
- Açıklamada KESİNLİKLE OLMASIN: "diagnose", "treat", "cure", "medical advice"

---

## 7. SKILL DOSYASI YAZIM KURALLARI

Her skill dosyası şu kurallara uymalıdır:

1. **YAML frontmatter** ile metadata (id, title, keywords, priority, source)
2. **Kompakt**: Gemma 4'ün context window'una sığmalı (~2000-3000 token max per skill)
3. **Actionable**: Soyut bilgi değil, adım adım talimat
4. **Doğrulanmış**: Kaynağı belirtilmiş (FEMA, US Army FM, CDC, WHO)
5. **İki dilde**: Türkçe ve İngilizce versiyonlar ayrı dosyalarda veya frontmatter'da `language` field'ı ile
6. **Öncelikli bilgi önce**: En kritik bilgi dosyanın başında olmalı (context kesilirse önemli kısım kalsın)

---

## 8. GELİŞTİRME AKIŞI

### Claude Code ile çalışırken:
1. Her değişiklikten önce ilgili dosyayı oku ve anla
2. Mevcut mimariyi boz**ma** — yeni dosya ekle veya mevcut dosyayı düzenle
3. Platform-specific code için conditional imports kullan
4. Her yeni özellik için test yaz (`test/` altına)
5. Commit mesajları: `feat:`, `fix:`, `refactor:`, `docs:` prefix kullan
6. Model dosyalarını ASLA commit etme

### Build komutları:
```bash
# Web preview (demo mode)
flutter run -d chrome

# Android debug APK
flutter build apk --debug

# Android release APK
flutter build apk --release

# iOS (macOS gerekir)
flutter build ios --release

# Analiz
flutter analyze

# Test
flutter test
```

---

## 9. ÖNCELİK SIRASI

```
1. [KRİTİK]  Gemma 4 model entegrasyonu (Phi-3 yerine)
2. [KRİTİK]  SkillRouter + PromptBuilder sistemi
3. [KRİTİK]  İlk 5 skill dosyası (deprem, yangın, ilk yardım, su, barınak)
4. [YÜKSEK]  Android APK build & gerçek cihaz testi
5. [YÜKSEK]  Typing animasyonu (terminal hissi)
6. [YÜKSEK]  5 soru/gün limiti + SOS 72 saat + Premium $4.99
7. [ORTA]    Settings ekranı + dil desteği
8. [ORTA]    Kalan skill dosyaları (15+ adet)
9. [DÜŞÜK]   In-app purchase ($4.99 tek seferlik premium)
10. [DÜŞÜK]  Play Store yayınlama
```

---

## 10. KAYNAKLAR

### Skill Dosyaları İçin Açık Kaynak Dökümanlar
- **FM 21-76** — US Army Survival Manual (Public Domain)
- **FM 3-05.70** — Güncellenmiş US Army Survival Manual
- **NWSS** — Nuclear War Survival Skills by Cresson Kearny (Public Domain)
- **FEMA P-2064** — "Are You Ready?" Citizen Preparedness Guide
- **Ready.gov** — Tüm afet rehberleri
- **CDC** — Pandemic preparedness guides
- **WHO** — Pandemic planning guidance

### Teknik Referanslar
- llama_cpp_dart: https://pub.dev/packages/llama_cpp_dart
- Gemma model: https://ai.google.dev/gemma
- Flutter offline: https://docs.flutter.dev
