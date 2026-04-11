import 'package:flutter/material.dart';
import '../services/usage_service.dart';
import '../utils/strings.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  final HavenTheme theme;
  final UsageService usage;
  final VoidCallback onClearChat;
  final Future<void> Function() onTryRealAI;
  final bool mockMode;

  const SettingsScreen({
    super.key,
    required this.theme,
    required this.usage,
    required this.onClearChat,
    required this.onTryRealAI,
    required this.mockMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = true;
  bool _premium = false;
  int _questionsUsed = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final premium = await widget.usage.isPremium();
    final used = await widget.usage.questionsToday();
    if (!mounted) return;
    setState(() {
      _premium = premium;
      _questionsUsed = used;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final s = S.current;
    return Scaffold(
      backgroundColor: t.background,
      appBar: AppBar(
        backgroundColor: t.headerBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: t.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          s.settingsTitle,
          style: TextStyle(
            color: t.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: t.primary))
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _section(s.sectionGeneral),
                _row(
                  label: s.langRow,
                  value: s.langValue,
                  onTap: _chooseLanguage,
                ),
                _section(s.sectionAppearance),
                _toggleRow(
                  label: s.darkMode,
                  value: t.mode == HavenMode.bunker,
                  enabled: _premium,
                  disabledHint: s.premiumOnly,
                  onChanged: (_) {},
                ),
                _row(label: s.fontSize, value: s.fontSizeNormal, onTap: () {}),
                _section(s.sectionAccount),
                _row(
                  label: s.statusRow,
                  value: _premium
                      ? s.statusPremium
                      : S.format(s.statusFreeFormat, {
                          'used': _questionsUsed.toString(),
                          'total': UsageService.dailyLimit.toString(),
                        }),
                ),
                if (!_premium)
                  _row(
                    label: s.upgradeRow,
                    value: s.upgradeValue,
                    onTap: _showSoon,
                    accent: true,
                  ),
                _row(label: s.restorePurchase, onTap: _showSoon),
                _section(s.sectionInfo),
                _row(
                  label: s.sourcesRow,
                  value: s.sourcesValue,
                  onTap: _showSources,
                ),
                _row(label: s.privacyRow, onTap: _showSoon),
                _row(label: s.termsRow, onTap: _showSoon),
                _row(label: s.versionRow, value: s.versionValue),
                _section(s.sectionData),
                _row(label: s.aiModelRow, value: s.aiModelValue),
                _row(
                  label: s.realAiRow,
                  value: widget.mockMode ? s.realAiDisabled : s.realAiEnabled,
                  onTap: _confirmTryRealAI,
                  accent: widget.mockMode,
                ),
                _row(
                  label: s.clearChatRow,
                  onTap: _confirmClearChat,
                  danger: true,
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _section(String title) {
    final t = widget.theme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title,
        style: TextStyle(
          color: t.textSubtle,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _row({
    required String label,
    String? value,
    VoidCallback? onTap,
    bool accent = false,
    bool danger = false,
  }) {
    final t = widget.theme;
    final labelColor = danger
        ? t.urgent
        : accent
            ? t.critical
            : t.textPrimary;
    return Material(
      color: t.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: t.headerBorder, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: labelColor, fontSize: 13),
                ),
              ),
              if (value != null)
                Text(
                  value,
                  style: TextStyle(color: t.textMuted, fontSize: 12),
                ),
              if (onTap != null) ...[
                const SizedBox(width: 6),
                Text('→', style: TextStyle(color: t.textMuted, fontSize: 14)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleRow({
    required String label,
    required bool value,
    required bool enabled,
    required ValueChanged<bool> onChanged,
    String? disabledHint,
  }) {
    final t = widget.theme;
    return Container(
      color: t.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(
          bottom: BorderSide(color: t.headerBorder, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: t.textPrimary, fontSize: 13)),
                if (!enabled && disabledHint != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      disabledHint,
                      style: TextStyle(color: t.textSubtle, fontSize: 10),
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: t.primary,
          ),
        ],
      ),
    );
  }

  void _showSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.current.comingSoon)),
    );
  }

  Future<void> _chooseLanguage() async {
    final t = widget.theme;
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: t.surface,
        title: Text(
          S.current.languageDialogTitle,
          style: TextStyle(color: t.textPrimary, fontSize: 15),
        ),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop('tr'),
            child: Text(S.current.langOptionTr,
                style: TextStyle(color: t.textPrimary)),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop('en'),
            child: Text(S.current.langOptionEn,
                style: TextStyle(color: t.textPrimary)),
          ),
        ],
      ),
    );
    if (picked == null) return;
    await widget.usage.setLanguage(picked);
    S.language.value = picked;
  }

  void _showSources() {
    final t = widget.theme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.surface,
        title: Text(S.current.sourcesDialogTitle,
            style: TextStyle(color: t.textPrimary, fontSize: 15)),
        content: Text(
          S.current.sourcesDialogBody,
          style: TextStyle(color: t.textMuted, fontSize: 12, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(S.current.closeButton,
                style: TextStyle(color: t.primary)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmTryRealAI() async {
    final t = widget.theme;
    final s = S.current;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.surface,
        title: Text(s.realAiDialogTitle,
            style: TextStyle(color: t.textPrimary, fontSize: 15)),
        content: Text(
          s.realAiDialogBody,
          style: TextStyle(color: t.textMuted, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.cancel, style: TextStyle(color: t.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(s.realAiDialogConfirm,
                style: TextStyle(color: t.critical)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;
    Navigator.of(context).pop();
    await widget.onTryRealAI();
  }

  void _confirmClearChat() {
    final t = widget.theme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.surface,
        title: Text(S.current.clearChatDialogTitle,
            style: TextStyle(color: t.textPrimary, fontSize: 15)),
        content: Text(
          S.current.clearChatDialogBody,
          style: TextStyle(color: t.textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(S.current.cancel,
                style: TextStyle(color: t.textMuted)),
          ),
          TextButton(
            onPressed: () {
              widget.onClearChat();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text(S.current.deleteButton,
                style: TextStyle(color: t.urgent)),
          ),
        ],
      ),
    );
  }
}
