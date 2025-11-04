# Survival Sentinel - Kalan İşler Listesi

**Tarih:** 3 Kasım 2025  
**Mevcut Durum:** %30 tamamlandı  
**Hedef:** %100 (Google Play'e yayınlama)

---

## 📊 GENEL BAKIŞ

### ✅ Tamamlananlar (%30)
- UI/UX tasarımı (temel)
- Phi-3 AI entegrasyonu (kod seviyesi)
- GitHub version control
- Web preview (demo mode)

### ❌ Kalan İşler (%70)
- **APK Build & Test** (kritik)
- **Tasarım Düzenlemeleri** (mockup istediğiniz gibi değil)
- **Özellikler** (20 soru, SOS, settings)
- **İçerik** (Privacy Policy, Terms of Use)
- **Yayınlama** (Google Play)

---

## 🔴 KRİTİK ÖNCELİK (Önce Bunlar Yapılmalı)

### 1. APK BUILD & TEST ⚠️ BLOKE EDİCİ
**Durum:** Yapılmadı  
**Neden Kritik:** APK olmadan hiçbir şey test edilemez  
**Gerekli:**
- Flutter SDK kurulumu (sizin bilgisayarınızda)
- Model dosyası (2.3 GB indirme)
- Android Studio yapılandırması
- APK build

**Tahmini Süre:** 1-2 saat (ilk kez)  
**Zorluk:** ⭐⭐⭐⭐☆  
**Manus Yapabilir:** ❌ (Sizin bilgisayarınızda olmalı)  
**Cursor Yapabilir:** ✅ (Scriptlerle otomatik)

**Sonraki adımlar buna bağlı!**

---

### 2. TASARIM DÜZENLEMELERİ 🎨
**Durum:** Mockup istediğiniz gibi değil  
**Neden Önemli:** Kullanıcı deneyimi  

**Düzenlenecekler:**
- [ ] Mockup'taki tasarımla karşılaştırma
- [ ] Renk tonları ayarı
- [ ] İkon boyutları
- [ ] Yazı fontları
- [ ] Buton stilleri
- [ ] Spacing/padding düzenlemeleri
- [ ] Animasyonlar

**Tahmini Süre:** 2-3 saat  
**Zorluk:** ⭐⭐⭐☆☆  
**Manus Yapabilir:** ✅ (Tasarım kodu yazabilirim)  
**Cursor Yapabilir:** ✅ (Görsel feedback ile)

**Gerekli:** Mockup ekran görüntüleri + istediğiniz değişiklikler

---

## 🟡 YÜKSEK ÖNCELİK (Çekirdek Özellikler)

### 3. 20 SORU LİMİTİ SİSTEMİ 🔢
**Durum:** Yapılmadı  
**Açıklama:** Kullanıcı 20 soru sorar, sonra ödeme ekranı

**Yapılacaklar:**
- [ ] Local storage ile soru sayacı
- [ ] Her soruda sayaç artırma
- [ ] 20'ye ulaşınca uyarı popup
- [ ] "Satın Al" ekranına yönlendirme
- [ ] Satın alma sonrası sınırsız erişim
- [ ] Reset mekanizması (test için)

**Tahmini Süre:** 3-4 saat  
**Zorluk:** ⭐⭐⭐☆☆  
**Manus Yapabilir:** ✅  
**Cursor Yapabilir:** ✅

---

### 4. SOS 48 SAAT MODU 🆘
**Durum:** Yapılmadı  
**Açıklama:** SOS butonuna basınca 48 saat ücretsiz sınırsız erişim

**Yapılacaklar:**
- [ ] SOS butonu fonksiyonelliği
- [ ] 48 saat timer başlatma
- [ ] Geri sayım gösterimi
- [ ] Timer bitince normal moda dönüş
- [ ] Local storage ile süre takibi
- [ ] Bildirim (isteğe bağlı)

**Tahmini Süre:** 3-4 saat  
**Zorluk:** ⭐⭐⭐☆☆  
**Manus Yapabilir:** ✅  
**Cursor Yapabilir:** ✅

---

### 5. SETTINGS EKRANI ⚙️
**Durum:** İkon var, fonksiyon yok  
**Açıklama:** Ayarlar sayfası

**Yapılacaklar:**
- [ ] Settings sayfası tasarımı
- [ ] Dil değiştirme (TR/EN)
- [ ] Privacy Policy linki
- [ ] Terms of Use linki
- [ ] About (Hakkında) bölümü
- [ ] Satın alma durumu gösterimi
- [ ] Model bilgileri
- [ ] Uygulama versiyonu
- [ ] Cache temizleme (isteğe bağlı)

**Tahmini Süre:** 4-5 saat  
**Zorluk:** ⭐⭐⭐☆☆  
**Manus Yapabilir:** ✅  
**Cursor Yapabilir:** ✅

---

### 6. DİL DEĞİŞTİRME (TR/EN) 🌍
**Durum:** Yapılmadı  
**Açıklama:** Türkçe ve İngilizce dil desteği

**Yapılacaklar:**
- [ ] Flutter localization paketi ekleme
- [ ] TR dil dosyası (strings_tr.json)
- [ ] EN dil dosyası (strings_en.json)
- [ ] Tüm UI metinlerini çevirme
- [ ] Dil seçim dropdown (Settings'te)
- [ ] Seçimi kaydetme (local storage)
- [ ] Uygulama yeniden başlatmadan dil değiştirme

**Tahmini Süre:** 5-6 saat  
**Zorluk:** ⭐⭐⭐⭐☆  
**Manus Yapabilir:** ✅  
**Cursor Yapabilir:** ✅

**Gerekli:** Tüm metinlerin TR ve EN çevirileri

---

### 7. TYPİNG ANİMASYONU ⌨️
**Durum:** Yapılmadı  
**Açıklama:** AI cevapları karakter karakter yazılacak (terminal hissi)

**Yapılacaklar:**
- [ ] StreamBuilder ile typing effect
- [ ] Karakter hızı ayarı (ms)
- [ ] Cursor animasyonu (|)
- [ ] Pause/resume mekanizması
- [ ] Hızlı geçme butonu (isteğe bağlı)

**Tahmini Süre:** 2-3 saat  
**Zorluk:** ⭐⭐⭐☆☆  
**Manus Yapabilir:** ✅  
**Cursor Yapabilir:** ✅

---

## 🟢 ORTA ÖNCELİK (İçerik & Dokümantasyon)

### 8. PRİVACY POLİCY 📄
**Durum:** Yapılmadı  
**Açıklama:** Gizlilik politikası metni

**Yapılacaklar:**
- [ ] Privacy Policy metni yazma (TR/EN)
- [ ] HTML sayfası oluşturma
- [ ] GitHub Pages'te yayınlama
- [ ] Link oluşturma
- [ ] Settings'ten bağlantı

**Tahmini Süre:** 2-3 saat  
**Zorluk:** ⭐⭐☆☆☆  
**Manus Yapabilir:** ✅ (Template verebilirim)  
**Cursor Yapabilir:** ❌ (İçerik sizden gelmeli)

**Gerekli:** Şirket bilgileri, veri toplama politikası

---

### 9. TERMS OF USE 📜
**Durum:** Yapılmadı  
**Açıklama:** Kullanım şartları metni

**Yapılacaklar:**
- [ ] Terms of Use metni yazma (TR/EN)
- [ ] HTML sayfası oluşturma
- [ ] GitHub Pages'te yayınlama
- [ ] Link oluşturma
- [ ] Settings'ten bağlantı

**Tahmini Süre:** 2-3 saat  
**Zorluk:** ⭐⭐☆☆☆  
**Manus Yapabilir:** ✅ (Template verebilirim)  
**Cursor Yapabilir:** ❌ (İçerik sizden gelmeli)

---

### 10. RAG DOKÜMANLARI 📚
**Durum:** Şablon hazır, içerik yok  
**Açıklama:** 50-60 adet acil durum rehberi

**Yapılacaklar:**
- [ ] Deprem rehberi
- [ ] Yangın rehberi
- [ ] İlk yardım rehberleri (10+ adet)
- [ ] Doğal afet rehberleri
- [ ] Hayatta kalma rehberleri
- [ ] Özel durum rehberleri
- [ ] RAG sistemi entegrasyonu
- [ ] Vektör veritabanı kurulumu

**Tahmini Süre:** 10-15 saat  
**Zorluk:** ⭐⭐⭐⭐☆  
**Manus Yapabilir:** ✅ (Şablon + örnek içerik)  
**Cursor Yapabilir:** ❌ (İçerik araştırması gerekli)

**Gerekli:** Güvenilir kaynaklardan bilgi toplama

---

## 🔵 DÜŞÜK ÖNCELİK (Ödeme & Yayınlama)

### 11. IN-APP PURCHASE (ÖDEME SİSTEMİ) 💳
**Durum:** Yapılmadı  
**Açıklama:** Google Play Billing entegrasyonu

**Yapılacaklar:**
- [ ] `in_app_purchase` paketi ekleme
- [ ] Google Play Console'da ürün oluşturma
- [ ] Ödeme akışı kodlama
- [ ] Satın alma doğrulama
- [ ] Receipt validation
- [ ] Restore purchases (geri yükleme)
- [ ] Test modunda deneme

**Tahmini Süre:** 6-8 saat  
**Zorluk:** ⭐⭐⭐⭐⭐  
**Manus Yapabilir:** ✅  
**Cursor Yapabilir:** ✅

**Gerekli:** Google Play Developer hesabı ($25)

---

### 12. GOOGLE PLAY HAZIRLIK 🏪
**Durum:** Yapılmadı  
**Açıklama:** Play Store'a yükleme hazırlığı

**Yapılacaklar:**
- [ ] Google Play Developer hesabı açma ($25)
- [ ] Uygulama ikonu (512x512 PNG)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Ekran görüntüleri (6-8 adet)
- [ ] Uygulama açıklaması (TR/EN)
- [ ] Kısa açıklama (80 karakter)
- [ ] Kategori seçimi
- [ ] İçerik derecelendirmesi
- [ ] Hedef kitle belirleme

**Tahmini Süre:** 4-5 saat  
**Zorluk:** ⭐⭐⭐☆☆  
**Manus Yapabilir:** ✅ (Görsel tasarım + metin)  
**Cursor Yapabilir:** ❌ (Manuel süreç)

---

### 13. UYGULAMA İKONU & SPLASH SCREEN 🎨
**Durum:** Varsayılan Flutter ikonu  
**Açıklama:** Özel uygulama ikonu ve açılış ekranı

**Yapılacaklar:**
- [ ] Uygulama ikonu tasarımı (deniz feneri)
- [ ] Adaptive icon (Android)
- [ ] iOS icon set
- [ ] Splash screen tasarımı
- [ ] `flutter_launcher_icons` paketi
- [ ] `flutter_native_splash` paketi

**Tahmini Süre:** 3-4 saat  
**Zorluk:** ⭐⭐⭐☆☆  
**Manus Yapabilir:** ✅  
**Cursor Yapabilir:** ✅

---

### 14. OPTİMİZASYON & TEST 🚀
**Durum:** Yapılmadı  
**Açıklama:** Performans iyileştirme ve test

**Yapılacaklar:**
- [ ] Memory leak kontrolü
- [ ] Pil kullanımı optimizasyonu
- [ ] APK boyutu küçültme (ProGuard)
- [ ] Model yükleme süresi optimizasyonu
- [ ] AI response hızı iyileştirme
- [ ] Crash test
- [ ] Farklı cihazlarda test
- [ ] Farklı Android versiyonlarında test

**Tahmini Süre:** 8-10 saat  
**Zorluk:** ⭐⭐⭐⭐☆  
**Manus Yapabilir:** ✅  
**Cursor Yapabilir:** ⚠️ (Kısmen)

---

## 📅 ÖNERİLEN ÇALIŞMA PLANI

### HAFTA 1: Kritik & Tasarım
- [ ] APK Build çalışır hale getir
- [ ] Tasarım düzenlemeleri yap
- [ ] Gerçek cihazda test et

### HAFTA 2: Çekirdek Özellikler
- [ ] 20 soru limiti
- [ ] SOS 48 saat modu
- [ ] Settings ekranı
- [ ] Typing animasyonu

### HAFTA 3: İçerik & Dil
- [ ] Dil değiştirme (TR/EN)
- [ ] Privacy Policy
- [ ] Terms of Use
- [ ] RAG dokümanları (başlangıç)

### HAFTA 4: Ödeme & Yayınlama
- [ ] In-App Purchase
- [ ] Google Play hazırlık
- [ ] Uygulama ikonu
- [ ] Optimizasyon
- [ ] Final test
- [ ] Google Play'e yükleme

---

## 💰 MALİYET TAHMİNİ

### Zorunlu Maliyetler:
- Google Play Developer: **$25** (tek seferlik)

### Opsiyonel Maliyetler:
- Freelancer yardımı: $0-200 (ihtiyaca göre)
- Grafik tasarımcı: $0-100 (kendiniz yapabilirsiniz)

**Toplam Minimum:** $25

---

## ⏱️ TOPLAM SÜRE TAHMİNİ

**Manus + Cursor ile:**
- Kritik işler: 10-15 saat
- Özellikler: 20-25 saat
- İçerik: 15-20 saat
- Yayınlama: 10-15 saat

**TOPLAM: 55-75 saat** (~4-6 hafta, günde 2-3 saat çalışmayla)

---

## 🎯 ŞİMDİ NE YAPMALIYIZ?

### Seçenek A: APK Build'e Odaklan (Kritik)
- Flutter SDK kurulumu
- İlk APK build
- Test

### Seçenek B: Tasarım Düzenlemeleri (Hızlı Kazanç)
- Mockup karşılaştırma
- UI düzeltmeleri
- Web preview'da test

### Seçenek C: Özellikler (Değer Katma)
- 20 soru limiti
- SOS modu
- Settings

**Hangisini tercih edersiniz?**

---

**Son Güncelleme:** 3 Kasım 2025, 17:00 GMT+3
