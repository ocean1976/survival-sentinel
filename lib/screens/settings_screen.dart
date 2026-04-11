import 'package:flutter/material.dart';
import '../services/usage_service.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  final HavenTheme theme;
  final UsageService usage;
  final VoidCallback onClearChat;

  const SettingsScreen({
    super.key,
    required this.theme,
    required this.usage,
    required this.onClearChat,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String appVersion = '1.0.0';
  static const String modelName = 'Gemma 4 (2.3 GB)';

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
          'AYARLAR',
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
                _section('GENEL'),
                _row(label: 'Dil / Language', value: 'Türkçe', onTap: () {}),
                _section('GÖRÜNÜM'),
                _toggleRow(
                  label: 'Karanlık Mod',
                  value: t.mode == HavenMode.bunker,
                  enabled: _premium,
                  disabledHint: 'Sadece Premium',
                  onChanged: (_) {},
                ),
                _row(label: 'Font Boyutu', value: 'Normal', onTap: () {}),
                _section('HESAP'),
                _row(
                  label: 'Durum',
                  value: _premium
                      ? 'Premium'
                      : 'Ücretsiz — $_questionsUsed/${UsageService.dailyLimit} soru',
                ),
                if (!_premium)
                  _row(
                    label: '[*] Premium\'a Yükselt',
                    value: '\$5\'dan',
                    onTap: _showSoon,
                    accent: true,
                  ),
                _row(label: 'Satın almayı geri yükle', onTap: _showSoon),
                _section('BİLGİ'),
                _row(label: 'Kaynaklar', value: 'FEMA, FM 21-76, CDC', onTap: _showSources),
                _row(label: 'Gizlilik Politikası', onTap: _showSoon),
                _row(label: 'Kullanım Şartları', onTap: _showSoon),
                _row(label: 'Versiyon', value: 'v$appVersion'),
                _section('VERİ'),
                _row(label: 'AI Model', value: modelName),
                _row(
                  label: 'Sohbet geçmişini temizle',
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
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                  ),
                ),
              ),
              if (value != null)
                Text(
                  value,
                  style: TextStyle(
                    color: t.textMuted,
                    fontSize: 12,
                  ),
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
            activeColor: t.primary,
          ),
        ],
      ),
    );
  }

  void _showSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Yakında')),
    );
  }

  void _showSources() {
    final t = widget.theme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.surface,
        title: Text('Kaynaklar',
            style: TextStyle(color: t.textPrimary, fontSize: 15)),
        content: Text(
          '• FM 21-76 — US Army Survival Manual\n'
          '• FM 3-05.70 — Updated Survival Manual\n'
          '• NWSS — Nuclear War Survival Skills\n'
          '• FEMA P-2064 "Are You Ready?"\n'
          '• Ready.gov\n'
          '• CDC\n'
          '• WHO',
          style: TextStyle(color: t.textMuted, fontSize: 12, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('KAPAT', style: TextStyle(color: t.primary)),
          ),
        ],
      ),
    );
  }

  void _confirmClearChat() {
    final t = widget.theme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.surface,
        title: Text('Sohbeti Temizle',
            style: TextStyle(color: t.textPrimary, fontSize: 15)),
        content: Text(
          'Tüm sohbet geçmişi silinecek. Emin misiniz?',
          style: TextStyle(color: t.textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('İPTAL', style: TextStyle(color: t.textMuted)),
          ),
          TextButton(
            onPressed: () {
              widget.onClearChat();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text('SİL', style: TextStyle(color: t.urgent)),
          ),
        ],
      ),
    );
  }
}
