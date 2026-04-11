import 'package:shared_preferences/shared_preferences.dart';

/// Ücretsiz kullanım kısıtları ve SOS oturum durumu.
///
/// Kurallar (CLAUDE.md §3, §4):
/// - Ücretsiz: günde 20 soru
/// - SOS: 72 saat sınırsız soru, 30 günde 1 kez aktifleştirilebilir
/// - Premium: tüm limitler kalkar
class UsageService {
  static const int dailyLimit = 20;
  static const Duration sosDuration = Duration(hours: 72);
  static const Duration sosCooldown = Duration(days: 30);

  static const _kQuestionCount = 'usage.question_count';
  static const _kQuestionDate = 'usage.question_date';
  static const _kSOSActivatedAt = 'usage.sos_activated_at';
  static const _kSOSLastUsed = 'usage.sos_last_used';
  static const _kPremium = 'usage.premium';
  static const _kOnboardingComplete = 'usage.onboarding_complete';
  static const _kLanguage = 'usage.language';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _p() async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<bool> isPremium() async => (await _p()).getBool(_kPremium) ?? false;

  Future<void> setPremium(bool value) async =>
      (await _p()).setBool(_kPremium, value);

  Future<bool> isOnboardingComplete() async =>
      (await _p()).getBool(_kOnboardingComplete) ?? false;

  Future<void> markOnboardingComplete() async =>
      (await _p()).setBool(_kOnboardingComplete, true);

  Future<String> getLanguage() async =>
      (await _p()).getString(_kLanguage) ?? 'tr';

  Future<void> setLanguage(String lang) async =>
      (await _p()).setString(_kLanguage, lang);

  // -------- Question counter --------

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<int> questionsToday() async {
    final prefs = await _p();
    final storedDate = prefs.getString(_kQuestionDate);
    if (storedDate != _todayKey()) {
      await prefs.setString(_kQuestionDate, _todayKey());
      await prefs.setInt(_kQuestionCount, 0);
      return 0;
    }
    return prefs.getInt(_kQuestionCount) ?? 0;
  }

  Future<int> remainingQuestions() async {
    return (dailyLimit - await questionsToday()).clamp(0, dailyLimit);
  }

  Future<bool> canAskQuestion() async {
    if (await isPremium()) return true;
    if (await isSOSActive()) return true;
    return (await questionsToday()) < dailyLimit;
  }

  Future<void> recordQuestion() async {
    if (await isPremium()) return;
    if (await isSOSActive()) return;
    final prefs = await _p();
    final current = await questionsToday();
    await prefs.setInt(_kQuestionCount, current + 1);
  }

  // -------- SOS --------

  Future<DateTime?> sosActivatedAt() async {
    final millis = (await _p()).getInt(_kSOSActivatedAt);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<bool> isSOSActive() async {
    final activated = await sosActivatedAt();
    if (activated == null) return false;
    return DateTime.now().difference(activated) < sosDuration;
  }

  Future<Duration> sosRemaining() async {
    final activated = await sosActivatedAt();
    if (activated == null) return Duration.zero;
    final elapsed = DateTime.now().difference(activated);
    final remaining = sosDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Future<DateTime?> sosLastUsed() async {
    final millis = (await _p()).getInt(_kSOSLastUsed);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Kullanıcı ücretsiz katmandaysa, son 30 gün içinde SOS kullandı mı?
  Future<Duration> sosCooldownRemaining() async {
    if (await isPremium()) return Duration.zero;
    final lastUsed = await sosLastUsed();
    if (lastUsed == null) return Duration.zero;
    final elapsed = DateTime.now().difference(lastUsed);
    final remaining = sosCooldown - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Future<bool> canActivateSOS() async {
    if (await isSOSActive()) return false;
    return (await sosCooldownRemaining()) == Duration.zero;
  }

  Future<void> activateSOS() async {
    final prefs = await _p();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_kSOSActivatedAt, now);
    if (!await isPremium()) {
      await prefs.setInt(_kSOSLastUsed, now);
    }
  }

  Future<void> deactivateSOS() async {
    await (await _p()).remove(_kSOSActivatedAt);
  }

  // -------- Maintenance --------

  Future<void> clearAll() async {
    final prefs = await _p();
    await prefs.remove(_kQuestionCount);
    await prefs.remove(_kQuestionDate);
    await prefs.remove(_kSOSActivatedAt);
    await prefs.remove(_kSOSLastUsed);
  }
}
