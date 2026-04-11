# Haven Protocol — Claude Code Instructions

**Proje:** Haven Protocol: Survival AI
**Repo:** https://github.com/ocean1976/survival-sentinel
**Platform:** Android & iOS (Flutter/Dart)
**AI Model:** Google Gemma 4 (GGUF, on-device, offline)
**Son Güncelleme:** Nisan 2026

---

## 1. PROJE ÖZETİ

Haven Protocol, internet bağlantısı olmadan çalışan, afet ve acil durum senaryolarında kullanıcılara hayatta kalma rehberliği sunan bir mobil AI asistanıdır. Tamamen offline çalışır; on-device Gemma 4 modeli ve önceden hazırlanmış skill dosyaları ile kullanıcının sorularına bağlam-duyarlı yanıtlar üretir.

### Temel Felsefe
- **%100 Offline**: İnternet gerektirmez. Afet anında çalışmalıdır.
- **Hayat Kurtaran Bilgi**: Halüsinasyon minimize edilmeli, bilgi doğrulanmış kaynaklara dayanmalıdır.
- **Minimal Kaynak**: Telefon pili ve RAM tasarrufu önceliklidir.
- **Erişilebilirlik**: Panik halindeki bir insan bile kullanabilmeli.

### App Store Bilgileri
- **Title:** Haven Protocol: Survival AI (28 karakter)
- **Subtitle:** Offline Emergency Guide (23 karakter)
- **AI Karakter İsmi:** Sentinel (kullanıcıya gösterilen persona)

---

## 2. TASARIM SİSTEMİ

### 2.1 İki Mod: Normal (Açık) ve Bunker (Karanlık)

Uygulama iki görsel modda çalışır. SOS butonu basıldığında Bunker moduna geçer.

#### Normal Mod (Açık)
- Retro military terminal estetiği
- Arka plan: `#D6D9D0` (açık haki)
- Kağıt/kart: `#F5F1E6` (krem)
- Chat bubble AI: `#E1E2DE`
- Chat bubble User: `#D5DCD6`
- Ana yeşil: `#2E402F` (koyu askeri yeşil)
- Vurgu turuncu: `#D67B37`
- Tehlike kırmızı: `#D9534F`
- Metin: `#2A3428`

#### Bunker Modu (Karanlık — NORAD 1962 İlham)
- Soğuk savaş sığınak konsolu estetiği
- Arka plan: `#080A06` (neredeyse siyah-yeşil)
- Kart: `#0C0E08`
- Header: `#060804`
- Border: `#1C2218`
- Primary yeşil: `#7CAA6A` (soluk askeri yeşil — parlak neon DEĞİL)
- Dim yeşil: `#5A8048`
- Muted: `#2A4022`
- Metin: `#6A9858`
- Vurgu/kritik: `#C89840` (amber)
- Tehlike: `#C85030` (soluk kırmızı)
- SOS butonu: Soluk kırmızı/turuncu (`#8A3A28` → `#6A2A1A` gradient)
- CRT efektleri: scanlines, vignette, radial glow
- OLED ekranlarda %30-40 pil tasarrufu sağlar

### 2.2 Ortak Kurallar
- Font: Space Mono (monospace)
- SOS butonu her zaman kırmızı tonlarında — mod fark etmez
- Büyük butonlar, net metin, yüksek kontrast
- Terminal-tarzı typing animasyonu
- OFFLINE etiketi her zaman görünür (güven verici)
- Disclaimer her AI mesajının sonunda: "⚕️ Bu bilgi profesyonel yardımın yerini almaz."

### 2.3 Chat Mesaj Yapısı
```
AI mesajı formatı:
- Label: HAVEN://response [saat UTC]
- Sol border: 3px (aiBorder rengi)
- İçerik yapısı:
  ▲ ACİL EYLEM (kırmızı kutuda)
  » PROTOKOL (numaralı adımlar)
  ◆ KRİTİK (uyarılar, — ile başlar)
  ⚕️ Disclaimer (gri kutuda)
  █ (yanıp sönen cursor)

Kullanıcı mesajı formatı:
- Label: KULLANICI@haven:~$ [saat UTC]
- Sol border: 3px (userBorder rengi)
```

---

## 3. SOS MODU MEKANİĞİ

### Akış
1. Kullanıcı SOS butonuna basar
2. Onay ekranı çıkar: "Bu özellik gerçek acil durumlar içindir. Emin misiniz?"
3. Onaylarsa:
   - Ekran Bunker moduna geçer (0.5s transition)
   - Sınırsız soru hakkı başlar
   - Geri sayım timer gösterilir
4. Tekrar SOS'a basarsa: Normal moda döner

### Ücretsiz vs Premium

| | Ücretsiz | Premium |
|---|---|---|
| SOS süresi | 72 saat | Her zaman aktif |
| SOS kullanım | 30 günde 1 kez | Sınırsız |
| Dark mode (Bunker) | Sadece SOS ile | Settings'ten de açılabilir |
| SOS bitince | Otomatik normal moda döner | Kullanıcı kontrol eder |

---

## 4. FİYATLANDIRMA (Tek Seferlik Ödeme — Abonelik YOK)

| Tier | Fiyat | İçerik |
|------|-------|--------|
| Premium | $5 | Sınırsız soru, tüm konular, kalıcı |
| Destekçi | $10 | Premium + geliştirme desteği |
| Koruyucu | $20 | Premium + destek + ekstra katkı |

- Ücretsiz limit: 20 soru/gün
- "Satın almayı geri yükle" seçeneği ZORUNLU (Apple/Google politikası)

---

## 5. SETTINGS EKRANI

```
GENEL
├── Dil / Language ............. Türkçe →

GÖRÜNÜM
├── Karanlık Mod ............... [toggle]
├── Font boyutu ................ Normal →

HESAP
├── Durum ...................... Ücretsiz — 3/20 soru
├── [*] Premium'a Yükselt ...... $5'dan →
├── Satın almayı geri yükle .... →

BİLGİ
├── Kaynaklar .................. FEMA, FM 21-76, CDC →
├── Gizlilik Politikası ........ Görüntüle
├── Kullanım Şartları .......... Görüntüle
├── Versiyon ................... v1.0.0

VERİ
├── AI Model ................... Gemma 4 (2.3 GB)
├── Sohbet geçmişini temizle ... →  [tehlikeli işlem]
```

### Kaldırılan Öğeler (ve nedenleri)
- ~~Bildirimler~~: %100 offline app, push service yok, gereksiz pil tüketimi
- ~~Skill dosyaları: 20 yüklü~~: İç mimari detayı, kullanıcıyı ilgilendirmez
- ~~Tema → Açık/Koyu seçimi~~: "Karanlık Mod" toggle'ı ile değiştirildi

---

## 6. TEKNİK MİMARİ

### Tech Stack
```
Framework:      Flutter (Dart)
AI Model:       Google Gemma 4 (GGUF quantized, ~2-3 GB)
AI Runtime:     llama_cpp_dart (v0.0.9+)
State Mgmt:     setState (basit) veya Riverpod (ilerisi için)
Local Storage:  shared_preferences + path_provider
Platform:       Android (öncelik), iOS (sonra)
```

### Dizin Yapısı
```
survival-sentinel/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── services/
│   │   ├── ai_service.dart
│   │   ├── ai_service_mobile.dart
│   │   ├── ai_service_web.dart
│   │   └── skill_router.dart
│   ├── models/
│   │   ├── message.dart
│   │   ├── skill.dart
│   │   └── app_state.dart
│   ├── screens/
│   │   ├── chat_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── onboarding_screen.dart
│   │   └── sos_screen.dart
│   ├── widgets/
│   │   ├── message_bubble.dart
│   │   ├── typing_indicator.dart
│   │   ├── sos_button.dart
│   │   └── lighthouse_icon.dart
│   └── utils/
│       ├── constants.dart
│       ├── prompt_builder.dart
│       └── localization.dart
├── assets/
│   ├── models/         # Gemma 4 GGUF (gitignore'da)
│   └── skills/
│       ├── tr/          # Türkçe skill dosyaları
│       └── en/          # İngilizce skill dosyaları
```

### Skill Router Sistemi
```
Kullanıcı Sorusu → SkillRouter (keyword matching) → PromptBuilder (system prompt + skill + soru) → Gemma 4 → Yanıt
```

### Gemma 4 Prompt Formatı
```dart
final prompt = '<start_of_turn>user\n$systemPrompt\n\n$skillContext\n\nKullanıcı Sorusu: $userMessage<end_of_turn>\n<start_of_turn>model\n';
```

---

## 7. KURALLAR

### Yapılmaması Gerekenler
- ❌ İnternet bağlantısı gerektiren özellik (core flow'da)
- ❌ Bildirim sistemi ekleme
- ❌ Arka plan servisi
- ❌ Kullanıcı verisini sunucuya gönderme
- ❌ Tıbbi teşhis koyma
- ❌ Model dosyasını Git repo'ya commit etme
- ❌ Skill dosyalarının içeriğini hardcode etme

### Yapılması Gerekenler
- ✅ Her AI yanıtının sonunda disclaimer
- ✅ Skill dosyalarının kaynağını belirt
- ✅ Pil tasarrufu: Model kullanılmadığında unload et
- ✅ Crash recovery: Chat geçmişini local'de sakla
- ✅ Erişilebilirlik: Büyük font seçeneği, yüksek kontrast
- ✅ SOS → Bunker modu (dark) otomatik geçiş

---

## 8. ÖNCELİK SIRASI

```
1. [KRİTİK]  Gemma 4 model entegrasyonu (Phi-3 yerine)
2. [KRİTİK]  SkillRouter + PromptBuilder sistemi
3. [KRİTİK]  İlk 5 skill dosyası (deprem, yangın, ilk yardım, su, barınak)
4. [YÜKSEK]  Android APK build & gerçek cihaz testi
5. [YÜKSEK]  Typing animasyonu (terminal hissi)
6. [YÜKSEK]  20 soru limiti + SOS 72 saat + Premium $5
7. [YÜKSEK]  Normal ↔ Bunker mod geçişi (SOS toggle)
8. [ORTA]    Settings ekranı + dil desteği
9. [ORTA]    Kalan skill dosyaları (15+ adet)
10. [DÜŞÜK]  In-app purchase ($5/$10/$20)
11. [DÜŞÜK]  Play Store yayınlama
```

---

## 9. GELİŞTİRME KURALLARI

- Her değişiklikten önce ilgili dosyayı oku ve anla
- Mevcut mimariyi bozma — yeni dosya ekle veya mevcut dosyayı düzenle
- Platform-specific code için conditional imports kullan
- Commit mesajları: `feat:`, `fix:`, `refactor:`, `docs:` prefix kullan
- Model dosyalarını ASLA commit etme
- main.dart'ı gereksiz yere refactor etme — çalışıyorsa dokunma

---

## 10. MOCKUP REFERANSLARI

Aşağıdaki mockup dosyaları tasarım referansı olarak kullanılmalıdır:

| Dosya | İçerik |
|-------|--------|
| `chat_screen_design.jsx` | Normal + Bunker mod sohbet ekranı (4 mesajlı gerçekçi senaryo) |
| `settings_premium_mockup.jsx` | Settings + Premium + SOS onay ekranı |
| `sos_toggle_demo.jsx` | İnteraktif SOS toggle (açık↔bunker geçişi) |
| `coldwar_terminals.jsx` | Bunker Console renk referansı (NORAD 1962) |

---

## 11. KAYNAKLAR

### Skill Dosyaları İçin
- FM 21-76 — US Army Survival Manual (Public Domain)
- FM 3-05.70 — Güncellenmiş US Army Survival Manual
- NWSS — Nuclear War Survival Skills (Public Domain)
- FEMA P-2064 — "Are You Ready?" Guide
- Ready.gov — Afet rehberleri
- CDC — Pandemic preparedness
- WHO — Pandemic planning guidance

### Teknik
- llama_cpp_dart: https://pub.dev/packages/llama_cpp_dart
- Gemma model: https://ai.google.dev/gemma
- Flutter offline: https://docs.flutter.dev
