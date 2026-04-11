import 'package:flutter/foundation.dart';

/// Dil bazlı UI metinleri. Yeni metin eklerken:
/// 1. Alt tarafa `final String ...` ekle
/// 2. `_tr` ve `_en` const sabitlerinde değer sağla
/// 3. Kullanım yerinde `S.current.xxx` olarak çağır
///
/// `S.language` bir `ValueNotifier` — `main.dart`'ta wrap edilen
/// `ValueListenableBuilder` değişikliği yakalar ve uygulamayı rebuild eder.
@immutable
class AppStrings {
  // --- Branding / global ---
  final String appTagline;          // 'SURVIVAL AI // OFFLINE'
  final String appTaglineSosActive; // 'SURVIVAL AI // SOS ACTIVE'
  final String sosButton;
  final String offlineBadge;
  final String disclaimerBar;
  final String welcomeMessage;
  final String loadingModel;
  final String thinking;
  final String inputHint;
  final String userLabel;
  final String aiLabel;
  final String quotaLabel;          // 'SORU: x/y' param'lı
  final String quotaPremium;        // 'PREMIUM — SINIRSIZ'
  final String sosActiveLabel;      // '[!] SOS — SINIRSIZ ERİŞİM'
  final String premiumBadge;        // '[*] PREMIUM'
  final String dailyLimitReached;   // parametreli
  final String sosCooldownMessage;  // parametreli
  final String aiLoadError;
  final String genericError;
  final String initErrorTitle;
  final String initErrorCrashDetected;
  final String retryButton;
  final String demoModeButton;
  final String mockBanner;
  final String mockResponseNoSkill;

  // --- SOS Dialog ---
  final String sosDialogTitle;
  final String sosDialogIntroPrefix; // 'Bu özellik '
  final String sosDialogIntroBold;   // 'gerçek acil durumlar'
  final String sosDialogIntroSuffix; // ' içindir.'
  final String sosBullet72h;
  final String sosBulletDarkMode;
  final String sosBulletCooldown;
  final String cancel;
  final String sosActivate;

  // --- Settings ---
  final String settingsTitle;
  final String sectionGeneral;
  final String sectionAppearance;
  final String sectionAccount;
  final String sectionInfo;
  final String sectionData;
  final String langRow;
  final String langValue;
  final String darkMode;
  final String premiumOnly;
  final String fontSize;
  final String fontSizeNormal;
  final String statusRow;
  final String statusFreeFormat;    // parametreli
  final String statusPremium;
  final String upgradeRow;
  final String upgradeValue;
  final String restorePurchase;
  final String sourcesRow;
  final String sourcesValue;
  final String privacyRow;
  final String termsRow;
  final String versionRow;
  final String versionValue;
  final String aiModelRow;
  final String aiModelValue;
  final String clearChatRow;
  final String comingSoon;
  final String sourcesDialogTitle;
  final String sourcesDialogBody;
  final String closeButton;
  final String clearChatDialogTitle;
  final String clearChatDialogBody;
  final String deleteButton;
  final String languageDialogTitle;

  // --- Onboarding ---
  final String onbWelcomeLabel;
  final String onbWelcomeTitle;
  final String onbWelcomeBody;
  final String onbTagOffline;
  final String onbTagLifeSaving;
  final String onbTagNoTracking;
  final String onbStartButton;

  final String onbFeaturesLabel;
  final String onbFeaturesTitle;
  final String onbFeatureDisastersTitle;
  final String onbFeatureDisastersSub;
  final String onbFeatureFirstAidTitle;
  final String onbFeatureFirstAidSub;
  final String onbFeatureChemNucTitle;
  final String onbFeatureChemNucSub;
  final String onbFeatureShelterTitle;
  final String onbFeatureShelterSub;
  final String onbContinueButton;

  final String onbSetupLabel;
  final String onbSetupTitleIdle;
  final String onbSetupTitleChecking;
  final String onbSetupTitleDownloading;
  final String onbSetupTitleVerifying;
  final String onbSetupTitleDone;
  final String onbSetupTitleError;

  final String onbReqTitle;
  final String onbReqStorage;
  final String onbReqWifi;
  final String onbReqDuration;
  final String onbReqOfflineAfter;

  final String onbPrivacyTitle;
  final String onbPrivacyStays;
  final String onbPrivacyNoUpload;
  final String onbPrivacyNoAnalytics;

  final String onbNoWifiWarning;

  final String onbWifiDialogTitle;
  final String onbWifiDialogBody;
  final String onbWifiDialogCancel;
  final String onbWifiDialogContinue;

  final String onbConnecting;
  final String onbStartDownload;
  final String onbChecking;
  final String onbDownloading;
  final String onbKeepOpen;
  final String onbDoneTitle;
  final String onbDoneBody;
  final String onbEnterButton;
  final String onbErrorTitle;
  final String onbErrorResumable;
  final String onbRetryButton;

  // --- Language dialog options ---
  final String langOptionTr;
  final String langOptionEn;

  const AppStrings._({
    required this.appTagline,
    required this.appTaglineSosActive,
    required this.sosButton,
    required this.offlineBadge,
    required this.disclaimerBar,
    required this.welcomeMessage,
    required this.loadingModel,
    required this.thinking,
    required this.inputHint,
    required this.userLabel,
    required this.aiLabel,
    required this.quotaLabel,
    required this.quotaPremium,
    required this.sosActiveLabel,
    required this.premiumBadge,
    required this.dailyLimitReached,
    required this.sosCooldownMessage,
    required this.aiLoadError,
    required this.genericError,
    required this.initErrorTitle,
    required this.initErrorCrashDetected,
    required this.retryButton,
    required this.demoModeButton,
    required this.mockBanner,
    required this.mockResponseNoSkill,
    required this.sosDialogTitle,
    required this.sosDialogIntroPrefix,
    required this.sosDialogIntroBold,
    required this.sosDialogIntroSuffix,
    required this.sosBullet72h,
    required this.sosBulletDarkMode,
    required this.sosBulletCooldown,
    required this.cancel,
    required this.sosActivate,
    required this.settingsTitle,
    required this.sectionGeneral,
    required this.sectionAppearance,
    required this.sectionAccount,
    required this.sectionInfo,
    required this.sectionData,
    required this.langRow,
    required this.langValue,
    required this.darkMode,
    required this.premiumOnly,
    required this.fontSize,
    required this.fontSizeNormal,
    required this.statusRow,
    required this.statusFreeFormat,
    required this.statusPremium,
    required this.upgradeRow,
    required this.upgradeValue,
    required this.restorePurchase,
    required this.sourcesRow,
    required this.sourcesValue,
    required this.privacyRow,
    required this.termsRow,
    required this.versionRow,
    required this.versionValue,
    required this.aiModelRow,
    required this.aiModelValue,
    required this.clearChatRow,
    required this.comingSoon,
    required this.sourcesDialogTitle,
    required this.sourcesDialogBody,
    required this.closeButton,
    required this.clearChatDialogTitle,
    required this.clearChatDialogBody,
    required this.deleteButton,
    required this.languageDialogTitle,
    required this.onbWelcomeLabel,
    required this.onbWelcomeTitle,
    required this.onbWelcomeBody,
    required this.onbTagOffline,
    required this.onbTagLifeSaving,
    required this.onbTagNoTracking,
    required this.onbStartButton,
    required this.onbFeaturesLabel,
    required this.onbFeaturesTitle,
    required this.onbFeatureDisastersTitle,
    required this.onbFeatureDisastersSub,
    required this.onbFeatureFirstAidTitle,
    required this.onbFeatureFirstAidSub,
    required this.onbFeatureChemNucTitle,
    required this.onbFeatureChemNucSub,
    required this.onbFeatureShelterTitle,
    required this.onbFeatureShelterSub,
    required this.onbContinueButton,
    required this.onbSetupLabel,
    required this.onbSetupTitleIdle,
    required this.onbSetupTitleChecking,
    required this.onbSetupTitleDownloading,
    required this.onbSetupTitleVerifying,
    required this.onbSetupTitleDone,
    required this.onbSetupTitleError,
    required this.onbReqTitle,
    required this.onbReqStorage,
    required this.onbReqWifi,
    required this.onbReqDuration,
    required this.onbReqOfflineAfter,
    required this.onbPrivacyTitle,
    required this.onbPrivacyStays,
    required this.onbPrivacyNoUpload,
    required this.onbPrivacyNoAnalytics,
    required this.onbNoWifiWarning,
    required this.onbWifiDialogTitle,
    required this.onbWifiDialogBody,
    required this.onbWifiDialogCancel,
    required this.onbWifiDialogContinue,
    required this.onbConnecting,
    required this.onbStartDownload,
    required this.onbChecking,
    required this.onbDownloading,
    required this.onbKeepOpen,
    required this.onbDoneTitle,
    required this.onbDoneBody,
    required this.onbEnterButton,
    required this.onbErrorTitle,
    required this.onbErrorResumable,
    required this.onbRetryButton,
    required this.langOptionTr,
    required this.langOptionEn,
  });

  static const AppStrings _tr = AppStrings._(
    appTagline: 'SURVIVAL AI // OFFLINE',
    appTaglineSosActive: 'SURVIVAL AI // SOS ACTIVE',
    sosButton: '[!] SOS',
    offlineBadge: 'OFFLINE',
    disclaimerBar: '[+] BU BİLGİ PROFESYONEL YARDIMIN YERİNİ ALMAZ',
    welcomeMessage:
        'Haven Protocol aktif. Acil bir durum mu var?\nDurumunuzu anlatın, adım adım yönlendireceğim.',
    loadingModel: 'AI modeli yükleniyor...\nBu bir dakika sürebilir.',
    thinking: 'Düşünüyor...',
    inputHint: 'Ne oldu? Durumunuzu anlatın...',
    userLabel: 'KULLANICI@haven:~\$',
    aiLabel: 'HAVEN://response',
    quotaLabel: 'SORU: {used}/{total}',
    quotaPremium: 'PREMIUM — SINIRSIZ',
    sosActiveLabel: '[!] SOS — SINIRSIZ ERİŞİM',
    premiumBadge: '[*] PREMIUM',
    dailyLimitReached:
        'Günlük {limit} soru limitiniz doldu.\nYarın sıfırlanır. Acil bir durumdaysanız SOS modunu kullanın veya Premium\'a yükseltin.',
    sosCooldownMessage:
        'SOS modu 30 günde bir kez kullanılabilir. Kalan süre: {remaining}',
    aiLoadError: 'AI modeli yüklenemedi: {error}',
    genericError: 'Hata: {error}',
    initErrorTitle: '✗ AI BAŞLATILAMADI',
    initErrorCrashDetected:
        'Önceki açılışta model yükleme çöktü. Cihazınız AI modelini çalıştıramıyor olabilir. Tekrar denemek yerine demo modunda devam etmenizi öneririz.',
    retryButton: 'TEKRAR DENE',
    demoModeButton: 'DEMO MODUNDA DEVAM ET',
    mockBanner:
        '⚠ DEMO MODU — Model yüklenemedi, yanıtlar önceden hazırlanmış protokollerden gelir.',
    mockResponseNoSkill:
        'Demo modundasın — bu konuda hazır bir protokol yok.\nŞunları deneyebilirsin: deprem, yangın, ilk yardım, su, barınak, sel, tornado, orman yangını, tsunami, nükleer, kimyasal, pandemi.\n\n⚕️ Bu bilgi profesyonel yardımın yerini almaz.',
    sosDialogTitle: '[!] SOS MODU',
    sosDialogIntroPrefix: 'Bu özellik ',
    sosDialogIntroBold: 'gerçek acil durumlar',
    sosDialogIntroSuffix: ' içindir.',
    sosBullet72h: '72 saat sınırsız soru',
    sosBulletDarkMode: 'Karanlık mod (pil tasarrufu)',
    sosBulletCooldown: '30 günde 1 kez kullanılabilir',
    cancel: 'İPTAL',
    sosActivate: '[!] AKTİFLEŞTİR',
    settingsTitle: 'AYARLAR',
    sectionGeneral: 'GENEL',
    sectionAppearance: 'GÖRÜNÜM',
    sectionAccount: 'HESAP',
    sectionInfo: 'BİLGİ',
    sectionData: 'VERİ',
    langRow: 'Dil / Language',
    langValue: 'Türkçe',
    darkMode: 'Karanlık Mod',
    premiumOnly: 'Sadece Premium',
    fontSize: 'Font Boyutu',
    fontSizeNormal: 'Normal',
    statusRow: 'Durum',
    statusFreeFormat: 'Ücretsiz — {used}/{total} soru',
    statusPremium: 'Premium',
    upgradeRow: '[*] Premium\'a Yükselt',
    upgradeValue: '\$5\'dan',
    restorePurchase: 'Satın almayı geri yükle',
    sourcesRow: 'Kaynaklar',
    sourcesValue: 'FEMA, FM 21-76, CDC',
    privacyRow: 'Gizlilik Politikası',
    termsRow: 'Kullanım Şartları',
    versionRow: 'Versiyon',
    versionValue: 'v1.0.0',
    aiModelRow: 'AI Model',
    aiModelValue: 'Gemma 2 2B IT Q4 (1.6 GB)',
    clearChatRow: 'Sohbet geçmişini temizle',
    comingSoon: 'Yakında',
    sourcesDialogTitle: 'Kaynaklar',
    sourcesDialogBody:
        '• FM 21-76 — US Army Survival Manual\n'
        '• FM 3-05.70 — Updated Survival Manual\n'
        '• NWSS — Nuclear War Survival Skills\n'
        '• FEMA P-2064 "Are You Ready?"\n'
        '• Ready.gov\n'
        '• CDC\n'
        '• WHO',
    closeButton: 'KAPAT',
    clearChatDialogTitle: 'Sohbeti Temizle',
    clearChatDialogBody: 'Tüm sohbet geçmişi silinecek. Emin misiniz?',
    deleteButton: 'SİL',
    languageDialogTitle: 'Dil Seç / Choose Language',
    onbWelcomeLabel: 'HAVEN://welcome',
    onbWelcomeTitle: 'Hoş geldin.',
    onbWelcomeBody:
        'Haven Protocol — afet ve acil durumlar için tasarlanmış, %100 offline çalışan hayatta kalma asistanın.',
    onbTagOffline: 'OFFLINE',
    onbTagLifeSaving: 'LIFE-SAVING',
    onbTagNoTracking: 'NO TRACKING',
    onbStartButton: 'BAŞLA →',
    onbFeaturesLabel: 'SENTINEL NE YAPAR?',
    onbFeaturesTitle: 'Afet anında bilgiye\nerişmeni sağlar.',
    onbFeatureDisastersTitle: 'Deprem, yangın, sel, tsunami',
    onbFeatureDisastersSub:
        'FEMA ve FM 21-76 protokollerine göre adım adım rehber.',
    onbFeatureFirstAidTitle: 'İlk yardım ve kurtarma',
    onbFeatureFirstAidSub:
        'CPR, kanama, yanık, kırık — kısa ve uygulanabilir.',
    onbFeatureChemNucTitle: 'Kimyasal, nükleer, pandemi',
    onbFeatureChemNucSub:
        'CDC ve WHO verileriyle hazırlanmış kritik müdahaleler.',
    onbFeatureShelterTitle: 'Barınak, su, sinyal',
    onbFeatureShelterSub: 'Doğada hayatta kalma — Army FM kaynaklı.',
    onbContinueButton: 'DEVAM →',
    onbSetupLabel: 'MODEL KURULUMU',
    onbSetupTitleIdle: 'AI modelini indir.',
    onbSetupTitleChecking: 'Bağlantı kontrol ediliyor...',
    onbSetupTitleDownloading: 'İndiriliyor...',
    onbSetupTitleVerifying: 'Doğrulanıyor...',
    onbSetupTitleDone: 'Hazırsın.',
    onbSetupTitleError: 'İndirme başarısız.',
    onbReqTitle: 'GEREKSİNİMLER',
    onbReqStorage: '• ~2 GB boş depolama alanı',
    onbReqWifi: '• WiFi bağlantısı (önerilir)',
    onbReqDuration: '• İlk kurulum 3-10 dakika sürer',
    onbReqOfflineAfter: '• Kurulumdan sonra internet gerekmez',
    onbPrivacyTitle: 'GİZLİLİK',
    onbPrivacyStays: '• Model cihazında kalır',
    onbPrivacyNoUpload: '• Sorular sunucuya gönderilmez',
    onbPrivacyNoAnalytics: '• Veri toplanmaz, analiz yapılmaz',
    onbNoWifiWarning:
        '⚠ WiFi bağlantısı tespit edilmedi. Mobil veri kullanmak pahalı olabilir.',
    onbWifiDialogTitle: 'WIFI BULUNAMADI',
    onbWifiDialogBody:
        'AI modeli yaklaşık 1.6 GB. WiFi olmadan indirme ücretlendirilebilir. Yine de devam etmek ister misin?',
    onbWifiDialogCancel: 'İPTAL',
    onbWifiDialogContinue: 'DEVAM ET',
    onbConnecting: 'Bağlanılıyor...',
    onbStartDownload: 'İNDİRMEYİ BAŞLAT',
    onbChecking: 'KONTROL...',
    onbDownloading: 'İndiriliyor',
    onbKeepOpen:
        'Uygulamayı kapatma. Bağlantı koparsa kaldığı yerden devam eder.',
    onbDoneTitle: '✓ KURULUM TAMAM',
    onbDoneBody: 'Sentinel hazır. Bundan sonra internet gerektirmez.',
    onbEnterButton: 'GİRİŞ →',
    onbErrorTitle: '✗ HATA',
    onbErrorResumable: 'İndirme kaldığı yerden devam edebilir.',
    onbRetryButton: 'TEKRAR DENE',
    langOptionTr: 'Türkçe',
    langOptionEn: 'English',
  );

  static const AppStrings _en = AppStrings._(
    appTagline: 'SURVIVAL AI // OFFLINE',
    appTaglineSosActive: 'SURVIVAL AI // SOS ACTIVE',
    sosButton: '[!] SOS',
    offlineBadge: 'OFFLINE',
    disclaimerBar: '[+] THIS INFORMATION DOES NOT REPLACE PROFESSIONAL HELP',
    welcomeMessage:
        'Haven Protocol is online. Is this an emergency?\nDescribe your situation — I\'ll guide you step by step.',
    loadingModel: 'Loading AI model...\nThis may take a minute.',
    thinking: 'Thinking...',
    inputHint: 'What happened? Describe your situation...',
    userLabel: 'USER@haven:~\$',
    aiLabel: 'HAVEN://response',
    quotaLabel: 'QUESTIONS: {used}/{total}',
    quotaPremium: 'PREMIUM — UNLIMITED',
    sosActiveLabel: '[!] SOS — UNLIMITED ACCESS',
    premiumBadge: '[*] PREMIUM',
    dailyLimitReached:
        'You\'ve reached your daily limit of {limit} questions.\nIt resets tomorrow. In a real emergency, activate SOS mode or upgrade to Premium.',
    sosCooldownMessage:
        'SOS mode can be used once every 30 days. Time remaining: {remaining}',
    aiLoadError: 'Failed to load AI model: {error}',
    genericError: 'Error: {error}',
    initErrorTitle: '✗ AI FAILED TO START',
    initErrorCrashDetected:
        'The previous launch crashed while loading the model. Your device may not be able to run this AI. We recommend continuing in demo mode instead.',
    retryButton: 'RETRY',
    demoModeButton: 'CONTINUE IN DEMO MODE',
    mockBanner:
        '⚠ DEMO MODE — Model unavailable, answers come from pre-built protocols.',
    mockResponseNoSkill:
        'You\'re in demo mode — no pre-built protocol for this topic.\nTry: earthquake, fire, first aid, water, shelter, flood, tornado, wildfire, tsunami, nuclear, chemical, pandemic.\n\n⚕️ This information does not replace professional help.',
    sosDialogTitle: '[!] SOS MODE',
    sosDialogIntroPrefix: 'This feature is for ',
    sosDialogIntroBold: 'real emergencies',
    sosDialogIntroSuffix: ' only.',
    sosBullet72h: '72 hours of unlimited questions',
    sosBulletDarkMode: 'Dark mode (battery saving)',
    sosBulletCooldown: 'Usable once every 30 days',
    cancel: 'CANCEL',
    sosActivate: '[!] ACTIVATE',
    settingsTitle: 'SETTINGS',
    sectionGeneral: 'GENERAL',
    sectionAppearance: 'APPEARANCE',
    sectionAccount: 'ACCOUNT',
    sectionInfo: 'INFO',
    sectionData: 'DATA',
    langRow: 'Language / Dil',
    langValue: 'English',
    darkMode: 'Dark Mode',
    premiumOnly: 'Premium only',
    fontSize: 'Font Size',
    fontSizeNormal: 'Normal',
    statusRow: 'Status',
    statusFreeFormat: 'Free — {used}/{total} questions',
    statusPremium: 'Premium',
    upgradeRow: '[*] Upgrade to Premium',
    upgradeValue: 'from \$5',
    restorePurchase: 'Restore purchase',
    sourcesRow: 'Sources',
    sourcesValue: 'FEMA, FM 21-76, CDC',
    privacyRow: 'Privacy Policy',
    termsRow: 'Terms of Use',
    versionRow: 'Version',
    versionValue: 'v1.0.0',
    aiModelRow: 'AI Model',
    aiModelValue: 'Gemma 2 2B IT Q4 (1.6 GB)',
    clearChatRow: 'Clear chat history',
    comingSoon: 'Coming soon',
    sourcesDialogTitle: 'Sources',
    sourcesDialogBody:
        '• FM 21-76 — US Army Survival Manual\n'
        '• FM 3-05.70 — Updated Survival Manual\n'
        '• NWSS — Nuclear War Survival Skills\n'
        '• FEMA P-2064 "Are You Ready?"\n'
        '• Ready.gov\n'
        '• CDC\n'
        '• WHO',
    closeButton: 'CLOSE',
    clearChatDialogTitle: 'Clear Chat',
    clearChatDialogBody:
        'All chat history will be deleted. Are you sure?',
    deleteButton: 'DELETE',
    languageDialogTitle: 'Choose Language / Dil Seç',
    onbWelcomeLabel: 'HAVEN://welcome',
    onbWelcomeTitle: 'Welcome.',
    onbWelcomeBody:
        'Haven Protocol — a 100% offline survival assistant built for disasters and emergencies.',
    onbTagOffline: 'OFFLINE',
    onbTagLifeSaving: 'LIFE-SAVING',
    onbTagNoTracking: 'NO TRACKING',
    onbStartButton: 'START →',
    onbFeaturesLabel: 'WHAT SENTINEL DOES',
    onbFeaturesTitle: 'Get the right info\nwhen it matters.',
    onbFeatureDisastersTitle: 'Earthquake, fire, flood, tsunami',
    onbFeatureDisastersSub:
        'Step-by-step guides based on FEMA and FM 21-76 protocols.',
    onbFeatureFirstAidTitle: 'First aid and rescue',
    onbFeatureFirstAidSub:
        'CPR, bleeding, burns, fractures — short and actionable.',
    onbFeatureChemNucTitle: 'Chemical, nuclear, pandemic',
    onbFeatureChemNucSub:
        'Critical response drawn from CDC and WHO guidance.',
    onbFeatureShelterTitle: 'Shelter, water, signaling',
    onbFeatureShelterSub: 'Wilderness survival — sourced from Army FM.',
    onbContinueButton: 'CONTINUE →',
    onbSetupLabel: 'MODEL SETUP',
    onbSetupTitleIdle: 'Download the AI model.',
    onbSetupTitleChecking: 'Checking connection...',
    onbSetupTitleDownloading: 'Downloading...',
    onbSetupTitleVerifying: 'Verifying...',
    onbSetupTitleDone: 'Ready.',
    onbSetupTitleError: 'Download failed.',
    onbReqTitle: 'REQUIREMENTS',
    onbReqStorage: '• ~2 GB free storage',
    onbReqWifi: '• WiFi connection (recommended)',
    onbReqDuration: '• First-time setup takes 3-10 minutes',
    onbReqOfflineAfter: '• No internet needed after setup',
    onbPrivacyTitle: 'PRIVACY',
    onbPrivacyStays: '• Model stays on your device',
    onbPrivacyNoUpload: '• Questions never leave this device',
    onbPrivacyNoAnalytics: '• No data collection, no analytics',
    onbNoWifiWarning:
        '⚠ No WiFi detected. Mobile data charges may apply.',
    onbWifiDialogTitle: 'NO WIFI',
    onbWifiDialogBody:
        'The AI model is ~1.6 GB. Downloading without WiFi may incur charges. Continue anyway?',
    onbWifiDialogCancel: 'CANCEL',
    onbWifiDialogContinue: 'CONTINUE',
    onbConnecting: 'Connecting...',
    onbStartDownload: 'START DOWNLOAD',
    onbChecking: 'CHECKING...',
    onbDownloading: 'Downloading',
    onbKeepOpen:
        'Keep the app open. If the connection drops, it will resume.',
    onbDoneTitle: '✓ SETUP COMPLETE',
    onbDoneBody: 'Sentinel is ready. No internet required from here on.',
    onbEnterButton: 'ENTER →',
    onbErrorTitle: '✗ ERROR',
    onbErrorResumable: 'The download can resume from where it stopped.',
    onbRetryButton: 'RETRY',
    langOptionTr: 'Türkçe',
    langOptionEn: 'English',
  );

  static AppStrings forLang(String code) => code == 'en' ? _en : _tr;
}

/// Uygulama genelinde reaktif metin erişimi.
class S {
  /// Aktif dil kodu ('tr' ya da 'en'). `main.dart` bunu dinleyip
  /// uygulamayı rebuild etmelidir.
  static final ValueNotifier<String> language = ValueNotifier<String>('tr');

  /// Mevcut dile ait metinler.
  static AppStrings get current => AppStrings.forLang(language.value);

  /// `{used}` gibi parametreleri değiştir.
  static String format(String template, Map<String, String> params) {
    var out = template;
    params.forEach((k, v) => out = out.replaceAll('{$k}', v));
    return out;
  }
}
