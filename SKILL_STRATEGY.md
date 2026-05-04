# Survival Sentinel — Skill Dosyası Hazırlama Stratejisi

**Tarih:** Nisan 2026  
**Amaç:** 20 skill dosyasının sistematik olarak hazırlanması  
**Toplam Boyut Tahmini:** ~100 KB (20 dosya × ~5 KB)

---

## 1. GENEL MİMARİ

```
Kullanıcı Sorusu → SkillRouter (keyword matching) → 1 skill dosyası seçilir → PromptBuilder → Gemma 4
```

- Tek seferde yalnızca **1 skill dosyası** modele gönderilir
- Her dosya **maksimum 2000-3000 token** (~3-5 KB)
- Gemma 4'ün 8K context window bütçesi:
  - System prompt: ~500 token
  - Skill dosyası: ~2000 token
  - Kullanıcı sorusu: ~200 token
  - Yanıt için kalan: ~5000 token ✅

---

## 2. DOSYA FORMATI

Her skill dosyası şu yapıda olacak:

```markdown
---
id: earthquake
title: Deprem Hayatta Kalma Rehberi
keywords: [deprem, earthquake, sarsıntı, çökme, enkaz, artçı, bina, yıkım, richter]
priority: high
language: tr
max_tokens: 2000
source: FEMA P-2064, Ready.gov, FEMA B-526
version: 1.0
---

# Deprem Anında Hayatta Kalma

## ACİL (İlk 60 saniye)
- ÇÖK-KAPAN-TUTUN: Yere çök, sağlam masanın altına gir, tutun.
- Dışarıdaysan: Binalardan, ağaçlardan, elektrik direklerinden uzaklaş.
...

## DEPREM SONRASI (İlk 1 saat)
...

## UZUN VADEDE (İlk 72 saat)
...
```

### Frontmatter Alanları

| Alan | Açıklama | Zorunlu |
|------|----------|---------|
| id | Benzersiz tanımlayıcı (snake_case) | ✅ |
| title | İnsan-okunur başlık | ✅ |
| keywords | SkillRouter eşleştirme kelimeleri (TR + EN karışık) | ✅ |
| priority | high / medium / low (eşit skorda öncelik belirler) | ✅ |
| language | tr veya en | ✅ |
| max_tokens | Dosyanın tahmini token uzunluğu | ✅ |
| source | Bilginin alındığı doğrulanmış kaynaklar | ✅ |
| version | İçerik versiyonu | ⬜ |

### İçerik Yazım Kuralları

1. **Öncelikli bilgi önce**: En kritik, hayat kurtaran bilgi dosyanın başında olmalı. Context kesilirse önemli kısım kalsın.
2. **Adım adım talimat**: Soyut paragraflar değil, numaralı aksiyonlar.
3. **Basit dil**: 12 yaşındaki biri anlamalı. Teknik jargon yok.
4. **Kompakt**: Gereksiz tekrar yok. Her cümle bilgi taşımalı.
5. **Kaynak belirt**: Her dosyanın frontmatter'ında source alanı dolu olmalı.
6. **İki dil**: Aynı skill dosyasının TR ve EN versiyonları ayrı dosyalarda:
   - `earthquake_tr.md` ve `earthquake_en.md`
   - Veya tek dosya, `language` field'ı ile ayrım

---

## 3. KAYNAK HARİTASI

### Katman A: ligi/SurvivalManual (FM 21-76) → 12 dosya
**Repo:** https://github.com/ligi/SurvivalManual  
**Lisans:** Public domain (US Army)  
**Güvenilirlik:** ⭐⭐⭐⭐⭐ (Resmi askeri el kitabı, onlarca yıl saha testi)

Bu kaynaktan türetilecek skill dosyaları:

| # | Skill Dosyası | FM 21-76 Bölümü | Öncelik |
|---|--------------|-----------------|---------|
| 1 | wilderness_survival.md | Genel hayatta kalma prensipleri | high |
| 2 | shelter_building.md | Ch: Shelters | high |
| 3 | water_purification.md | Ch: Water Procurement | high |
| 4 | fire_making.md | Ch: Fire Building | high |
| 5 | first_aid.md | Ch: First Aid | high |
| 6 | edible_plants.md | Ch: Plants / Food | medium |
| 7 | navigation.md | Ch: Navigation | medium |
| 8 | signaling.md | Ch: Signaling | medium |
| 9 | psychology.md | Ch: Psychology of Survival | medium |
| 10 | desert_survival.md | Ch: Desert Survival | medium |
| 11 | tropical_survival.md | Ch: Tropical Survival | low |
| 12 | winter_survival.md | Ch: Cold Weather Survival | medium |

**İşlem:** ligi/SurvivalManual wiki'sindeki markdown içeriği → kompakt skill formatına dönüştür → YAML frontmatter ekle → token sayısını kontrol et

### Katman B: FEMA / Ready.gov / CDC / NWSS → 8 dosya
**Kaynaklar:**
- FEMA P-2064 "Are You Ready?" (https://www.ready.gov/sites/default/files/2021-11/are-you-ready-guide.pdf)
- Ready.gov afet sayfaları (https://www.ready.gov)
- NWSS — Nuclear War Survival Skills by Cresson Kearny (Public Domain)
- CDC Pandemic Preparedness (https://www.cdc.gov/pandemic-flu/)
- WHO Pandemic Planning Guidance

**Güvenilirlik:** ⭐⭐⭐⭐⭐ (ABD federal hükümet kurumları + WHO)

Bu kaynaklardan yazılacak skill dosyaları:

| # | Skill Dosyası | Birincil Kaynak | Öncelik |
|---|--------------|-----------------|---------|
| 13 | earthquake.md | FEMA B-526, FEMA P-530, Ready.gov/earthquakes | high |
| 14 | fire_wildfire.md | FEMA L-203, Ready.gov/wildfires | high |
| 15 | flood.md | FEMA P-2064 Flood bölümü, Ready.gov/floods | high |
| 16 | nuclear.md | NWSS (Kearny), FEMA nükleer rehberi, Ready.gov/radiation | high |
| 17 | pandemic.md | CDC Pandemic Influenza Plan, WHO rehberleri | medium |
| 18 | volcano.md | FEMA P-2064 Volcano bölümü, USGS | medium |
| 19 | civil_unrest.md | FEMA P-2064 (terörizm/patlama bölümleri) | low |
| 20 | urban_survival.md | FEMA P-2064 + FM 21-76 birleşim | medium |

**İşlem:** PDF/web sayfalarını oku → kritik bilgileri çıkar → kendi cümlelerinle yeniden yaz → adım adım talimat formatına dönüştür → YAML frontmatter ekle

---

## 4. ÖNCELİK SIRASI (Hangi Sırayla Yazılacak)

### Faz 1: MVP — İlk 5 dosya (1-2 gün)
Bu beşi ile uygulama test edilebilir hale gelir.

```
1. earthquake.md      ← FEMA (en yaygın afet, Türkiye için kritik)
2. first_aid.md       ← FM 21-76 (her senaryoda gerekli)
3. fire_wildfire.md   ← FEMA (yaygın afet)
4. water_purification.md ← FM 21-76 (temel hayatta kalma)
5. shelter_building.md   ← FM 21-76 (temel hayatta kalma)
```

### Faz 2: Kritik Afetler — 5 dosya (2-3 gün)
```
6. flood.md           ← FEMA
7. nuclear.md         ← NWSS + FEMA
8. wilderness_survival.md ← FM 21-76
9. fire_making.md     ← FM 21-76
10. psychology.md     ← FM 21-76
```

### Faz 3: Tamamlama — 10 dosya (3-5 gün)
```
11. pandemic.md       ← CDC + WHO
12. navigation.md     ← FM 21-76
13. signaling.md      ← FM 21-76
14. edible_plants.md  ← FM 21-76
15. volcano.md        ← FEMA
16. urban_survival.md ← FEMA + FM 21-76
17. desert_survival.md ← FM 21-76
18. winter_survival.md ← FM 21-76
19. tropical_survival.md ← FM 21-76
20. civil_unrest.md   ← FEMA
```

---

## 5. KALİTE KONTROL CHECKLIST

Her skill dosyası tamamlandığında şu kontroller yapılmalı:

```
□ YAML frontmatter eksiksiz mi? (id, title, keywords, priority, source)
□ Keywords hem TR hem EN içeriyor mu?
□ Token sayısı 2000-3000 aralığında mı?
□ En kritik bilgi dosyanın ilk 500 token'ında mı?
□ Adım adım talimat formatında mı? (numaralı listeler)
□ Teknik jargon yok mu? (12 yaşında biri anlar mı?)
□ Kaynak belirtilmiş mi? (FEMA, FM 21-76, CDC vb.)
□ Halüsinasyon riski olan belirsiz bilgi var mı? → Sil
□ Tıbbi teşhis/kesin tavsiye var mı? → "X olabilir, profesyonel yardım gerekir" formatına çevir
□ Silah/patlayıcı yapımı bilgisi var mı? → Sil
```

---

## 6. KEYWORD STRATEJİSİ

SkillRouter'ın doğru dosyayı seçebilmesi için keyword'ler kritiktir.

### Kurallar:
- Her skill dosyasında **minimum 8, maksimum 15** keyword
- Hem **Türkçe** hem **İngilizce** keyword'ler ekle
- **Eş anlamlılar** ekle (deprem, sarsıntı, zelzele)
- **Bağlamsal kelimeler** ekle (enkaz, çökme, artçı)
- Keyword'ler arasında **çakışma minimize** et (iki dosya aynı keyword'e sahip olmasın)

### Çakışma Haritası (dikkat edilecekler):
- "yangın" → fire_wildfire.md mi, fire_making.md mi? → Bağlamsal ayrım: "orman yangını, bina yangını" vs "ateş yakma, kamp ateşi"
- "su" → water_purification.md mi, flood.md mi? → "su arıtma, içme suyu" vs "sel, taşkın, su baskını"
- "soğuk" → winter_survival.md mi, shelter_building.md mi? → "kar, buz, donma" vs "barınak, sığınak"

### Örnek Keyword Setleri:

```yaml
# earthquake.md
keywords: [deprem, earthquake, sarsıntı, çökme, enkaz, artçı, bina, yıkım, zelzele, richter, fay]

# fire_wildfire.md
keywords: [yangın, wildfire, orman yangını, bina yangını, duman, alev, söndürme, yanık, fire, tahliye]

# fire_making.md
keywords: [ateş yakma, kamp ateşi, çakmak, kibrit, sürtünme, odun, fire making, tinder, kindling]

# water_purification.md
keywords: [su arıtma, içme suyu, kaynatma, filtre, dezenfektan, kirli su, water purification, boiling]

# flood.md
keywords: [sel, taşkın, su baskını, flood, nehir, baraj, yağmur, su seviyesi, boğulma]
```

---

## 7. FALLBACK STRATEJİSİ

Hiçbir skill eşleşmezse ne olacak?

**Seçenek A (Önerilen):** `general_survival.md` adında bir fallback dosyası oluştur.
- İçeriği: Temel hayatta kalma prensipleri (su, barınak, ateş, sinyal, psikoloji)
- Her konudan 2-3 cümlelik özet
- "Daha detaylı bilgi için sorunuzu daha spesifik sorun" yönlendirmesi

**Seçenek B:** Model'e skill dosyası olmadan genel system prompt ile cevaplat.
- Risk: Halüsinasyon artabilir çünkü bağlam yok.
- Tavsiye edilmez.

---

## 8. İNGİLİZCE VERSİYON STRATEJİSİ

### Seçenek A: Ayrı Dosyalar (Önerilen)
```
assets/skills/tr/earthquake.md
assets/skills/tr/first_aid.md
assets/skills/en/earthquake.md
assets/skills/en/first_aid.md
```
- Toplam: 40 dosya (20 TR + 20 EN)
- Toplam boyut: ~200 KB (hâlâ çok küçük)
- SkillRouter dil ayarına göre doğru klasörden seçer

### Seçenek B: Tek Dosya, İki Dil
```yaml
---
id: earthquake
language: [tr, en]
---

## TR
# Deprem Anında Hayatta Kalma
...

## EN
# Earthquake Survival Guide
...
```
- Toplam: 20 dosya ama her biri ~2x büyük
- Dezavantaj: Context window'da gereksiz yer kaplar

**Karar: Seçenek A** — daha temiz, daha verimli.

---

## 9. DOSYA KONUMU VE YÜKLEME

```
assets/
└── skills/
    ├── tr/
    │   ├── earthquake.md
    │   ├── first_aid.md
    │   ├── fire_wildfire.md
    │   └── ... (20 dosya)
    ├── en/
    │   ├── earthquake.md
    │   ├── first_aid.md
    │   ├── fire_wildfire.md
    │   └── ... (20 dosya)
    └── general_survival.md  ← Fallback (TR+EN ayrı olabilir)
```

### Flutter'da Yükleme:
```dart
// pubspec.yaml
flutter:
  assets:
    - assets/skills/tr/
    - assets/skills/en/

// Dart'ta okuma
final content = await rootBundle.loadString('assets/skills/tr/earthquake.md');
```

### Uygulama Başlangıcında:
1. Tüm skill dosyalarını `rootBundle` ile oku
2. YAML frontmatter'ı parse et (keywords, priority çıkar)
3. `SkillRouter`'a keyword haritasını yükle
4. Hazır — kullanıcı soru sorduğunda eşleştirme yapılabilir

---

## 10. ÖZET TABLO

| Metrik | Değer |
|--------|-------|
| Toplam skill dosyası | 20 (TR) + 20 (EN) + 1 fallback = 41 |
| Dosya başı boyut | ~3-5 KB |
| Toplam boyut | ~200 KB |
| Gemma 4 model boyutu | ~2-3 GB |
| Skill oranı | Toplam boyutun %0.007'si |
| Token/dosya | 2000-3000 |
| Kaynak: FM 21-76 | 12 dosya (%60) |
| Kaynak: FEMA/CDC/NWSS | 8 dosya (%40) |
| MVP için gereken | İlk 5 dosya (1-2 gün) |
| Tam set için gereken | 20 dosya (6-10 gün) |
