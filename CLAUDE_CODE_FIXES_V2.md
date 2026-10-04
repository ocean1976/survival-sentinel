# Haven Protocol: Fix Talimatı V2 (Repo İncelemesi, Ekim 2026)

**Hedef:** Aşağıdaki fix'leri SIRAYLA uygula. Her fix'ten önce ilgili dosyayı `view` ile oku. Her fix sonrası `flutter analyze` çalıştır. Commit prefix: `fix:` / `refactor:` / `test:` / `ci:` / `docs:`.

**Bağlam:** `master` = `a01e7be` (5 Mayıs 2026). Model: Gemma 2 2B IT Q4_K_M, runtime: llama_cpp_dart 0.2.2 (`LlamaParent`, isolate).

---

## P0-1: Context window prompt'tan küçük (ANA KÖK NEDEN)

**Dosya:** `lib/services/ai_service_mobile.dart`

**Sorun:** `nCtx = 512`. Oysa sadece TR system prompt'u ~5.000 karakter (~1.500+ token), üstüne skill (~350 token) ve `nPredict = 384` geliyor. Prompt context'e sığmıyor: ya hata ya kırpılmış/anlamsız çıktı ya da native crash. Yavaşlık, kalitesizlik ve çökme şikayetlerinin ortak kökü bu.

**Yapılacak:** `ContextParams` değerlerini şu şekilde değiştir:

```dart
final contextParams = ContextParams()
  ..nCtx = 4096
  ..nBatch = 512
  ..nUbatch = 512
  ..nThreads = 4
  ..nThreadsBatch = 4
  ..nPredict = maxTokens; // 384 kalabilir

final samplerParams = SamplerParams()
  ..temp = 0.5
  ..topP = 0.9
  ..topK = 40;
```

Ayrıca `generateResponse` içine debug log ekle (sadece `kDebugMode`): prompt karakter sayısı, toplam süre, yaklaşık token/sn.

**Not:** Model `LlamaParent` içinde bellekte kalıyor (her soruda yeniden yüklenmiyor). Bu doğru, DOKUNMA. CLAUDE.md'deki "her yanıttan sonra dispose et" kuralı UYGULANMAYACAK (P2-8'de dokümandan da kaldırılıyor).

---

## P0-2: Crash-loop koruması ölü kod

**Dosya:** `lib/screens/chat_screen.dart`

**Sorun:** `UsageService.didLastInitCrash()` var ama hiçbir yerde çağrılmıyor; `_crashLoopDetected` hiç `true` olmuyor. Native SIGSEGV Dart `try/catch` ile yakalanamaz. Model init'te native crash olursa uygulama her açılışta tekrar dener ve tekrar çöker: kullanıcı uygulamayı hiç açamaz.

**Yapılacak:** `_initializeAI()` içinde, `kIsWeb` kontrolünden sonra, `_tryRealAI()` çağrısından ÖNCE:

```dart
if (kIsWeb) {
  _enterMockMode();
  return;
}

// Önceki açılışta init yarıda kaldıysa native crash olmuştur.
if (await _usage.didLastInitCrash()) {
  if (!mounted) return;
  setState(() => _crashLoopDetected = true);
  await _enterMockMode();
  return;
}

// Kullanıcı daha önce mock'a düştüyse otomatik deneme yapma
if (await _usage.isMockMode()) {
  await _enterMockMode();
  return;
}

await _tryRealAI();
```

`_enterMockMode()` içindeki `markInitFinished()` çağrısı flag'i temizliyor. Bu yüzden `_crashLoopDetected` banner'ı Settings'teki "Gerçek AI'yı dene" butonuyla birlikte kalmalı; kullanıcı manuel tetiklerse `_tryRealAI()` yeniden `markInitStarted()` yapar. Mevcut UI (`_crashLoopDetected` satır ~390) zaten buna göre çiziliyor.

**Test:** `markInitStarted()` çağır, uygulamayı öldür (init bitmeden), tekrar aç: mock modda açılmalı, crash banner'ı görünmeli.

---

## P0-3: System prompt'u kısalt + tıbbi kuralları geri ekle

**Dosya:** `lib/utils/prompt_builder.dart`

**Sorun:**
1. Prompt çok uzun (TR 733 kelime, EN 861 kelime). 2B model kısa prompt'u çok daha iyi takip eder; mobil CPU'da 1.500+ token prompt işleme tek başına onlarca saniye sürer.
2. Gerçek koddaki prompt'ta tıbbi güvenlik kuralları YOK: ilaç adı/doz yasağı, "hastaneye gerek yok" yasağı, 112 yönlendirmesi eksik. (`aee597c` sadece `SYSTEM_PROMPT.md`'den sildi; o dosya kodda kullanılmıyor, ama kodda da bu kurallar hiç yoktu.)

**Yapılacak:** `_systemPromptTr` ve `_systemPromptEn` sabitlerini aşağıdakilerle DEĞİŞTİR. Emoji işaretleri (⚠️ 📋 ⚡ ⚕️) `parsed_response.dart` ile uyumludur, değiştirme.

```dart
static const String _systemPromptTr = '''
Sen Haven Protocol'sün: tamamen offline çalışan bir hayatta kalma asistanı. Deneyimli bir arama-kurtarma komutanı gibi konuş: sıcak, sakin, kararlı.

KURALLAR:
1. Kullanıcının dilinde yanıt ver. Yazım hatalarını, tek kelimelik mesajları ve emojileri doğru anla.
2. En hayati bilgiyi önce ver. Kısa yaz, en fazla 150 kelime. Numaralı adımlar kullan.
3. Yalnızca BAĞLAM'daki bilgiyi kullan. Bağlamda yoksa "Bu konuda güvenilir bilgim yok. 112'yi ara." de. Asla uydurma.
4. TIBBİ KONULAR: Asla tanı koyma. Asla ilaç adı veya doz söyleme. Asla "hastaneye gerek yok" deme. Tıbbi her yanıta "Hemen 112'yi ara." ile başla. Çocuk ve hamilelerde ayrıca uzman yardımı gerektiğini söyle.
5. Silah, patlayıcı, yasadışı konular, siyaset ve din hakkında konuşma. Alakasız sorularda kısaca nazik ol ve hayatta kalma konusuna yönlendir.
6. Kullanıcı panikteyse önce tek cümleyle yanında olduğunu söyle ("Seninleyim, adım adım gidiyoruz."), sonra talimat ver.

FORMAT:
⚠️ ACİL EYLEM: 1-2 cümle
📋 ADIMLAR: numaralı adımlar
⚡ ÖNEMLİ: kritik uyarılar
⚕️ Bu bilgi profesyonel yardımın yerini almaz. İmkân bulduğunda yetkililere başvur.

BAĞLAM:
{SKILL_CONTENT}

Kullanıcı:
''';

static const String _systemPromptEn = '''
You are Haven Protocol: a fully offline survival assistant. Speak like a veteran search-and-rescue commander: warm, calm, decisive.

RULES:
1. Reply in the user's language. Understand typos, one-word messages and emojis.
2. Give the most life-saving information first. Be brief, max 150 words. Use numbered steps.
3. Use ONLY the information in CONTEXT. If it is not there, say "I don't have reliable information on this. Call emergency services." Never make things up.
4. MEDICAL: Never diagnose. Never name medications or doses. Never say "no need for a hospital". Start every medical answer with "Call emergency services now (112/911)." For children and pregnant women, say expert help is required.
5. No weapons, explosives, illegal activity, politics or religion. For unrelated questions, be brief and kind and steer back to survival.
6. If the user is panicking, first say in one sentence that you are with them ("I'm with you, we'll go step by step."), then give instructions.

FORMAT:
⚠️ IMMEDIATE ACTION: 1-2 sentences
📋 STEPS: numbered steps
⚡ IMPORTANT: critical warnings
⚕️ This information does not replace professional help. Contact authorities when possible.

CONTEXT:
{SKILL_CONTENT}

User:
''';
```

`build()` içinde `Kaynak:` etiketi dile göre olmalı:

```dart
final sourceLabel = language == 'en' ? 'Sources' : 'Kaynak';
// ...
: '${skill.title}\n$sourceLabel: ${skill.sources.join(', ')}\n\n${skill.body}';
```

### P0-3b: `SYSTEM_PROMPT.md` dokümanını kodla senkronize et

**Sorun:** Mevcut `SYSTEM_PROMPT.md` kodla uyuşmuyor ve yanıltıcı: "prompt_builder.dart bu dosyayı okur" diyor (okumuyor, prompt Dart içinde sabit), model olarak Gemma 4 / 8K context yazıyor (gerçek: Gemma 2 2B), system prompt'u ~400-500 token sanıyor (gerçek: 733 kelime, yani en az 733 token), eski `SkillRouter` örnek kodu içeriyor ve 5b tıbbi bölümü silinmiş. 512'lik context hatasının fark edilmemesinin sebebi bu dosyadaki yanlış hesap.

**Yapılacak:** `SYSTEM_PROMPT.md` dosyasını tamamen şu yapıyla yeniden yaz:

1. **Başlık:** `# Haven Protocol: System Prompt (Gemma 2 2B, v1.1'de Gemma 4 E2B)`
2. **Giriş notu (aynen):**
   > Bu dosya dokümandır. Gerçek kaynak `lib/utils/prompt_builder.dart` içindeki `_systemPromptTr` ve `_systemPromptEn` sabitleridir. Prompt değişirse önce Dart dosyası, sonra bu dosya güncellenir; ikisi birebir aynı kalmalıdır.
3. **TÜRKÇE SYSTEM PROMPT:** P0-3'teki yeni `_systemPromptTr` metni, birebir.
4. **ENGLISH SYSTEM PROMPT:** P0-3'teki yeni `_systemPromptEn` metni, birebir.
5. **"PROMPT BUILDER KULLANIM ÖRNEĞİ" ve "SKILL ROUTER KULLANIM ÖRNEĞİ" bölümlerini SİL.** Eski kod örnekleri; Claude Code'u gerçek koddan farklı bir mimariye yönlendiriyor.
6. **"ÖRNEK AKIŞ" bölümünü KORU** (kalite referansı), şu değişikliklerle:
   - "Gemma 4'e gönderilir" yerine "Gemma 2'ye gönderilir".
   - Beklenen yanıtın altına not ekle: `Not: "Hemen 112'yi ara" açılışı yalnızca tıbbi senaryolarda zorunludur. Deprem, yangın gibi tıbbi olmayan yanıtlarda 112 gerekiyorsa ADIMLAR içinde geçer, açılış cümlesi olarak eklenmez.`
7. **NOTLAR bölümünü şu tabloyla DEĞİŞTİR:**

```markdown
## NOTLAR: Token bütçesi (Gemma 2 2B, nCtx 4096)

| Bileşen | Hedef |
|---|---|
| System prompt | ≤ 350 token (yaklaşık ≤ 230 kelime) |
| Skill dosyası | ~300-400 token (~1.100 karakter) |
| Kullanıcı mesajı | ~20-100 token |
| Yanıt (`nPredict`) | 384 token |
| **Kural** | prompt + skill + mesaj + nPredict toplamı `nCtx`'in %75'ini geçmez |

- Kelime sayısı token sayısının alt sınırıdır: 500 kelimelik bir prompt asla 500 token'ın altında değildir. Türkçe metinlerde token/kelime oranı genelde 1.5-2.5'tir.
- Prompt uzarsa önce system prompt'u kısalt (2B model kısa talimatı daha iyi takip eder), skill içeriğini değil.
- `nCtx` veya `nPredict` değişirse bu tablo güncellenir.
```

8. **Doğrulama:** Yeniden yazdıktan sonra iki dosyadaki prompt metinlerini karşılaştır:

```bash
grep -c "TIBBİ KONULAR" SYSTEM_PROMPT.md lib/utils/prompt_builder.dart
# Her iki dosya için de 1 dönmeli
```

---

## P0-4: Skill içeriklerindeki tıbbi hatalar

Satırın baştaki işaretini (`07.`, `—` vb.) ve dosya formatını AYNEN koru, sadece metni değiştir/sil.

| Dosya | Satır | Yapılacak |
|---|---|---|
| `assets/skills/tr/first_aid.md` | `07. Yaralı uzvu mümkünse kalp seviyesinin üstüne kaldır.` | Şununla değiştir: `07. Kanama durmazsa basıyı bırakmadan üstüne yeni bez ekle, 112'yi tekrar ara.` |
| `assets/skills/tr/first_aid.md` | `Zehirlenmede kusturmadan önce 114 Zehir Danışma'yı ara.` | Şununla değiştir: `Zehirlenmede KUSTURMA. Hemen 114 Ulusal Zehir Danışma Merkezi'ni ara.` |
| `assets/skills/en/first_aid.md` | `07. Elevate the injured limb above heart level if possible.` | Şununla değiştir: `07. If bleeding continues, add more cloth on top without releasing pressure and call emergency services again.` |
| `assets/skills/en/first_aid.md` | `For poisoning, call Poison Control before inducing vomiting.` | Şununla değiştir: `For poisoning, do NOT induce vomiting. Call Poison Control or emergency services immediately.` |
| `assets/skills/tr/fracture.md` | `06. Yaralı uzvu kalp seviyesine veya üstüne kaldır (mümkünse).` | Şununla değiştir: `06. Kişiyi sıcak tut ve yanından ayrılma.` |
| `assets/skills/tr/fracture.md` | `Aspirin verme — kanamayı artırabilir; parasetamol daha güvenli.` | Şununla değiştir: `Ağrı kesici veya herhangi bir ilaç verme; ilaç kararını sağlık ekibine bırak.` |

Gerekçe: güncel ilk yardım rehberleri kanamada uzvu kaldırmayı önermiyor; kusturma zehirlenmede zararlı olabilir; uygulama hiçbir koşulda ilaç adı vermemeli.

---

## P1-5: SkillRouter yanlış eşleşmeleri

**Dosyalar:** `lib/utils/text_utils.dart`, `lib/services/skill_router.dart`, `assets/skills/tr/*.md`

**Sorun (simülasyonla doğrulandı):**

| Mesaj | Şu anki sonuç | Olması gereken |
|---|---|---|
| `evde yangin var` | first_aid ❌ | fire |
| `bebeğim ateşlendi` | fire ❌ | eşleşme yok (fallback) |
| `kayboldum` | general_survival ❌ | lost_wilderness |
| `kanama var ne yapmaliyim` | first_aid (ama 5 skill birden puan alıyor) | first_aid |

Sebepler: (a) %60 önek eşleşmesi çok gevşek: `yangin` kelimesi `yanık` (önek "yan") ve `yara` (önek "ya") ile eşleşip first_aid'e puan veriyor. (b) 3 harfli keyword'ler (`kar`, `kaç`, `su`) substring ile her yerde eşleşiyor. (c) general_survival'daki `ne yapmalıyım`, `yardım`, `acil` gibi genel ifadeler her soruda puan topluyor. (d) `ateş` hem yangın hem ateşlenme (fever) demek.

**Yapılacak 1:** `TextUtils.fuzzyContains` yerine skor döndüren fonksiyon:

```dart
/// 2 = tam kelime / tam ifade, 1 = fuzzy veya ek almış hali, 0 = yok
static int matchScore(String message, String keyword) {
  final msg = normalize(message);
  final key = normalize(keyword);
  if (key.isEmpty) return 0;
  final tokens = msg.split(' ');

  // Çok kelimeli ifade: sadece birebir geçiyorsa
  if (key.contains(' ')) return msg.contains(key) ? 2 : 0;

  // Tam kelime
  if (tokens.contains(key)) return 2;

  // 4 harften kısa keyword: sadece tam kelime
  if (key.length < 4) return 0;

  final threshold = key.length <= 6 ? 1 : 2;
  final prefixLen = (key.length * 0.8).round().clamp(4, key.length);
  for (final t in tokens) {
    if (t.length < 4) continue;
    // Türkçe ekler: "depremde", "yangından"
    if (key.length >= 5 && t.startsWith(key.substring(0, prefixLen))) return 1;
    // Yazım hatası: "deprm", "yangn"
    if (levenshtein(t, key) <= threshold) return 1;
  }
  return 0;
}
```

`skill_router.dart` içinde puanlama: `score += TextUtils.matchScore(query, kw) * kw.length;`

Ayrıca `general_survival` hiç puan yarışına girmesin; sadece hiçbir skill eşleşmezse fallback olarak dönsün.

**Yapılacak 2:** TR keyword güncellemeleri (`# keywords:` satırları):

| Dosya | Yeni keywords |
|---|---|
| `fire.md` | `yangın, duman, alev, yanıyor, fire` |
| `wildfire.md` | `orman yangını, ormanda yangın, wildfire, kül` |
| `signaling.md` | `sinyal, işaret, signal, ayna, yerimi bildir` |
| `first_aid.md` | `ilk yardım, yara, yaralı, kanama, kanıyor, kalp, kalbim, cpr, yanık, first aid` |
| `drowning.md` | `boğulma, boğuluyor, suda, nefes, drowning` |
| `water.md` | `su yok, içme suyu, susuzluk, susuz, arıtma, kaynatma, water` |
| `lost_wilderness.md` | `kayboldum, kayıp, doğa, orman, yön, lost` |
| `general_survival.md` | `hayatta kalma, tehlike, afet, kriz` |
| `blizzard.md` | `kar` kelimesini tek başına kaldır, `kar fırtınası, tipi, blizzard, donma` kalsın |
| `evacuation.md` | `kaç` kelimesini kaldır |

**Yapılacak 3:** `test/skill_router_test.dart` oluştur. Aşağıdaki tablo kabul kriteri; hepsi geçmeden bu fix bitmiş sayılmaz:

| Mesaj | Beklenen skill id |
|---|---|
| `evde yangin var` | fire |
| `yangn` | fire |
| `deprm oldu` | earthquake |
| `depremde enkaz altındayım` | earthquake |
| `kanama var ne yapmaliyim` | first_aid |
| `arkadasim kaniyor` | first_aid |
| `kardeşim yaralı` | first_aid |
| `bacağım kırıldı` | fracture |
| `kayboldum` | lost_wilderness |
| `çocuk suda boğuluyor` | drowning |
| `su yok` | water |
| `sel geldi` | flood |
| `elektrikler kesildi` | blackout |
| `bebeğim ateşlendi` | null (fallback) |
| `How do I survive an earthquake?` | earthquake (EN havuz) |

Not: test'te `rootBundle` için `TestWidgetsFlutterBinding.ensureInitialized()` kullan.

---

## P1-6: Prompt dili tespit edilen dile göre seçilmiyor

**Dosya:** `lib/screens/chat_screen.dart` (`_sendMessage`)

**Sorun:** Router mesajın dilini otomatik tespit edip EN skill seçiyor, ama `PromptBuilder.build(language: S.language.value)` UI dilini kullanıyor. Arayüz Türkçeyken İngilizce soru TR system prompt + EN skill ile karışık gidiyor.

**Yapılacak:**

```dart
final detectedLang = TextUtils.detectLanguage(text);
final skill = _skillRouter.match(text);
final formattedPrompt = PromptBuilder.build(
  userMessage: text,
  skill: skill,
  language: detectedLang,
);
```

---

## P2-7: CI her push'ta 2.2 GB Phi-3 indiriyor

**Dosya:** `.github/workflows/build-apk.yml`

**Sorun:** Workflow hâlâ Phi-3 modelini indiriyor. Model artık uygulama içinden indiriliyor (onboarding), APK'ya gömülmüyor. Her push'ta boşuna 2.2 GB indirme.

**Yapılacak:** "Create model directory" ve "Download Phi-3 model" adımlarını sil. Geri kalan build adımları kalsın.

---

## P2-8: Doküman temizliği

1. `CLAUDE.md` güncelle (kod zaten böyle çalışıyor, doküman koda uysun):
   - Gelir modeli: **20 soru/gün**, Premium **$5 / $10 / $20 tek seferlik** (üçü aynı özellik), SOS **72 saat**, **30 günde 1**.
   - Tech Stack: `llama_cpp_dart ^0.2.2`, Gemma 2 2B IT Q4_K_M, `nCtx 4096`, `nThreads 4`, `temp 0.5`.
   - "Pil Optimizasyonu" bölümündeki "her yanıttan sonra `dispose()`" ve "`contextSize: 2048`" maddelerini kaldır. Yerine: "Model `LlamaParent` isolate'inde bellekte kalır; uygulama arka plana geçince veya 5 dk idle sonrası dispose edilebilir."
   - §2.1'deki bozuk `AI Model:**` satırını düzelt.
   - §6.5'e not: `fracture.md` uygulamada kalıyor ama ilaç ve kaldırma talimatı içermiyor.
2. `PROJE_DURUMU.md`, `KALAN_ISLER_LISTESI.md`, `OTURUM_OZETI.md`, `CURSOR_DEVIR_TESLIM.md`, `CURSOR_INSTRUCTIONS.md`, `MIGRATION_PLAN.md` dosyalarını `docs/archive/` altına taşı (Phi-3/RAG dönemine ait, yanıltıcı).
3. Kökteki `settings_premium_mockup.jsx` ve `survival_sentinel_mockup.jsx` kopyalarını sil (`docs/` altında güncel halleri var).
4. `README.md`'yi 10 satırlık gerçek proje açıklamasıyla değiştir.

---

## Uygulama sırası ve test

```
P0-1 → P0-2 → P0-3 → P0-4   (her biri ayrı commit)
flutter analyze
flutter run -d <S22-device-id>
```

**Cihaz testi (S22 Ultra), P0'lar sonrası:**

| Test | Beklenti |
|---|---|
| Uygulama açılışı | Yeşil "GEMMA 2 AI: GERÇEK MODEL AKTİF" banner'ı |
| `deprem oldu ne yapmalıyım` | 30 sn içinde ⚠️/📋/⚡ formatında Türkçe yanıt |
| `kanama durmuyor` | Yanıt "Hemen 112'yi ara." ile başlıyor, ilaç adı yok |
| `How do I survive a fire?` | İngilizce yanıt |
| Debug log | Prompt karakter sayısı ve token/sn görünüyor; değerleri not et |

Sonra P1 ve P2.
