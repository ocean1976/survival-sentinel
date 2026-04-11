import 'package:flutter/material.dart';

enum HavenMode { normal, bunker }

class HavenTheme {
  final HavenMode mode;

  final Color background;
  final Color surface;
  final Color headerBg;
  final Color headerBorder;
  final Color divider;

  final Color primary;
  final Color primaryDim;
  final Color textPrimary;
  final Color textMuted;
  final Color textSubtle;

  final Color aiBg;
  final Color aiBorder;
  final Color aiLabel;
  final Color userBg;
  final Color userBorder;
  final Color userLabel;
  final Color messageText;

  final Color urgent;
  final Color protocol;
  final Color critical;
  final Color cursor;

  final Color inputBg;
  final Color inputFieldBg;
  final Color inputBorder;
  final Color inputPrompt;
  final Color inputText;
  final Color sendBg;

  final Color disclaimerBg;
  final Color disclaimerBorder;
  final Color disclaimerText;

  final Color offlineBadgeBg;
  final Color offlineBadgeText;

  final List<Color> sosGradient;
  final Color sosBorder;
  final Color sosText;

  const HavenTheme._({
    required this.mode,
    required this.background,
    required this.surface,
    required this.headerBg,
    required this.headerBorder,
    required this.divider,
    required this.primary,
    required this.primaryDim,
    required this.textPrimary,
    required this.textMuted,
    required this.textSubtle,
    required this.aiBg,
    required this.aiBorder,
    required this.aiLabel,
    required this.userBg,
    required this.userBorder,
    required this.userLabel,
    required this.messageText,
    required this.urgent,
    required this.protocol,
    required this.critical,
    required this.cursor,
    required this.inputBg,
    required this.inputFieldBg,
    required this.inputBorder,
    required this.inputPrompt,
    required this.inputText,
    required this.sendBg,
    required this.disclaimerBg,
    required this.disclaimerBorder,
    required this.disclaimerText,
    required this.offlineBadgeBg,
    required this.offlineBadgeText,
    required this.sosGradient,
    required this.sosBorder,
    required this.sosText,
  });

  static const HavenTheme normal = HavenTheme._(
    mode: HavenMode.normal,
    background: Color(0xFFD6D9D0),
    surface: Color(0xFFF5F1E6),
    headerBg: Color(0xFFA4AE9E),
    headerBorder: Color(0xFF868E82),
    divider: Color(0xFF2E402F),
    primary: Color(0xFF2E402F),
    primaryDim: Color(0xFF5A6A56),
    textPrimary: Color(0xFF2A3428),
    textMuted: Color(0xFF5A6A56),
    textSubtle: Color(0xFF8A9484),
    aiBg: Color(0xFFE1E2DE),
    aiBorder: Color(0xFF887244),
    aiLabel: Color(0xFF74603A),
    userBg: Color(0xFFD5DCD6),
    userBorder: Color(0xFF6A8A5A),
    userLabel: Color(0xFF566054),
    messageText: Color(0xFF2A3428),
    urgent: Color(0xFFD9534F),
    protocol: Color(0xFF3D6B35),
    critical: Color(0xFFD67B37),
    cursor: Color(0xFF3D6B35),
    inputBg: Color(0xFFACB4A8),
    inputFieldBg: Color(0xFFCCD2C6),
    inputBorder: Color(0xFF929A8E),
    inputPrompt: Color(0xFF3D6B35),
    inputText: Color(0xFF2A3428),
    sendBg: Color(0xFF2E402F),
    disclaimerBg: Color(0xFFAAB2A4),
    disclaimerBorder: Color(0xFF929A8E),
    disclaimerText: Color(0xFF566054),
    offlineBadgeBg: Color(0xFF3D4F35),
    offlineBadgeText: Color(0xFFA8B89A),
    sosGradient: [Color(0xFFC0392B), Color(0xFFA93226)],
    sosBorder: Color(0xFFE74C3C),
    sosText: Color(0xFFFFFFFF),
  );

  static const HavenTheme bunker = HavenTheme._(
    mode: HavenMode.bunker,
    background: Color(0xFF080A06),
    surface: Color(0xFF0C0E08),
    headerBg: Color(0xFF060804),
    headerBorder: Color(0xFF1C2218),
    divider: Color(0xFF1C2218),
    primary: Color(0xFF7CAA6A),
    primaryDim: Color(0xFF5A8048),
    textPrimary: Color(0xFF6A9858),
    textMuted: Color(0xFF486A3A),
    textSubtle: Color(0xFF2A4022),
    aiBg: Color(0xFF0C0E08),
    aiBorder: Color(0xFF486A38),
    aiLabel: Color(0xFF486A3A),
    userBg: Color(0xFF0A0C07),
    userBorder: Color(0xFF3A5A2E),
    userLabel: Color(0xFF3A5A2E),
    messageText: Color(0xFF6A9858),
    urgent: Color(0xFFC85030),
    protocol: Color(0xFF7CAA6A),
    critical: Color(0xFFC89840),
    cursor: Color(0xFF7CAA6A),
    inputBg: Color(0xFF060804),
    inputFieldBg: Color(0xFF0C0E08),
    inputBorder: Color(0xFF1C2218),
    inputPrompt: Color(0xFF7CAA6A),
    inputText: Color(0xFF6A9858),
    sendBg: Color(0xFF0C0E08),
    disclaimerBg: Color(0xFF060804),
    disclaimerBorder: Color(0xFF1C2218),
    disclaimerText: Color(0xFF2A4022),
    offlineBadgeBg: Color(0xFF1C2218),
    offlineBadgeText: Color(0xFF5A8048),
    sosGradient: [Color(0xFF8A3A28), Color(0xFF6A2A1A)],
    sosBorder: Color(0xFFAA7040),
    sosText: Color(0xFFD4A878),
  );
}
