import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../services/model_downloader.dart';
import '../services/usage_service.dart';
import '../utils/theme.dart';
import '../widgets/lighthouse_icon.dart';

enum _DownloadPhase { idle, checkingWifi, downloading, verifying, done, error }

class OnboardingScreen extends StatefulWidget {
  final UsageService usage;
  final VoidCallback onComplete;

  const OnboardingScreen({
    super.key,
    required this.usage,
    required this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const HavenTheme _theme = HavenTheme.normal;

  final PageController _page = PageController();
  final ModelDownloader _downloader = ModelDownloader();
  final Connectivity _connectivity = Connectivity();

  int _current = 0;
  _DownloadPhase _phase = _DownloadPhase.idle;
  bool _onWifi = true;
  bool _wifiChecked = false;

  int _received = 0;
  int _total = ModelDownloader.expectedBytes;
  double _bytesPerSec = 0;
  String _stageLabel = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _prefillResumeState();
  }

  Future<void> _prefillResumeState() async {
    final existing = await _downloader.existingPartBytes();
    if (existing > 0 && mounted) {
      setState(() {
        _received = existing;
      });
    }
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _next() {
    if (_current < 2) {
      _page.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _checkWifiAndDownload() async {
    setState(() {
      _phase = _DownloadPhase.checkingWifi;
      _error = null;
    });
    final results = await _connectivity.checkConnectivity();
    final onWifi = results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
    setState(() {
      _onWifi = onWifi;
      _wifiChecked = true;
    });
    if (!onWifi) {
      // WiFi yok — kullanıcıya sor, yine de izin verirse devam.
      final proceed = await _showMobileDataDialog();
      if (proceed != true) {
        setState(() => _phase = _DownloadPhase.idle);
        return;
      }
    }
    await _runDownload();
  }

  Future<bool?> _showMobileDataDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _theme.surface,
        title: Text(
          'WIFI BULUNAMADI',
          style: TextStyle(
            color: _theme.urgent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        content: Text(
          'AI modeli yaklaşık 2.3 GB. WiFi'
          ' olmadan indirme ücretlendirilebilir. Yine de devam etmek ister misin?',
          style: TextStyle(
            color: _theme.textPrimary,
            fontSize: 12,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'İPTAL',
              style: TextStyle(color: _theme.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'DEVAM ET',
              style: TextStyle(color: _theme.urgent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runDownload() async {
    setState(() {
      _phase = _DownloadPhase.downloading;
      _stageLabel = 'Bağlanılıyor...';
    });

    final result = await _downloader.download(
      onProgress: (received, total, bps) {
        if (!mounted) return;
        setState(() {
          _received = received;
          _total = total;
          _bytesPerSec = bps;
          if (_phase == _DownloadPhase.downloading) {
            _stageLabel = 'İndiriliyor';
          }
        });
      },
      onStage: (stage) {
        if (!mounted) return;
        setState(() {
          _stageLabel = stage;
          if (stage.contains('doğrulan')) {
            _phase = _DownloadPhase.verifying;
          }
        });
      },
    );

    if (!mounted) return;
    if (result.success) {
      await widget.usage.markOnboardingComplete();
      setState(() => _phase = _DownloadPhase.done);
    } else {
      setState(() {
        _phase = _DownloadPhase.error;
        _error = result.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.background,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView(
                    controller: _page,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _current = i),
                    children: [
                      _welcomePage(),
                      _featuresPage(),
                      _setupPage(),
                    ],
                  ),
                ),
                _buildDots(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          LighthouseIcon(color: _theme.primary),
          const SizedBox(width: 10),
          Text(
            'HAVEN PROTOCOL',
            style: TextStyle(
              color: _theme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == _current;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? _theme.primary : _theme.textSubtle,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _welcomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'HAVEN://welcome',
            style: TextStyle(
              color: _theme.aiLabel,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Hoş geldin.',
            style: TextStyle(
              color: _theme.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Haven Protocol — afet ve acil durumlar için tasarlanmış, %100 offline çalışan hayatta kalma asistanın.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _theme.textPrimary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          _tag('OFFLINE'),
          const SizedBox(height: 8),
          _tag('LIFE-SAVING'),
          const SizedBox(height: 8),
          _tag('NO TRACKING'),
          const Spacer(),
          _primaryButton('BAŞLA →', _next),
        ],
      ),
    );
  }

  Widget _featuresPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'SENTINEL NE YAPAR?',
            style: TextStyle(
              color: _theme.aiLabel,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Afet anında bilgiye\nerişmeni sağlar.',
            style: TextStyle(
              color: _theme.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),
          _feature('▲', 'Deprem, yangın, sel, tsunami',
              'FEMA ve FM 21-76 protokollerine göre adım adım rehber.'),
          _feature('▲', 'İlk yardım ve kurtarma',
              'CPR, kanama, yanık, kırık — kısa ve uygulanabilir.'),
          _feature('▲', 'Kimyasal, nükleer, pandemi',
              'CDC ve WHO verileriyle hazırlanmış kritik müdahaleler.'),
          _feature('▲', 'Barınak, su, sinyal',
              'Doğada hayatta kalma — Army FM kaynaklı.'),
          const Spacer(),
          _primaryButton('DEVAM →', _next),
        ],
      ),
    );
  }

  Widget _setupPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'MODEL KURULUMU',
            style: TextStyle(
              color: _theme.aiLabel,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _setupTitle(),
            style: TextStyle(
              color: _theme.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(child: _setupBody()),
          _setupActions(),
        ],
      ),
    );
  }

  String _setupTitle() {
    switch (_phase) {
      case _DownloadPhase.idle:
        return 'AI modelini indir.';
      case _DownloadPhase.checkingWifi:
        return 'Bağlantı kontrol ediliyor...';
      case _DownloadPhase.downloading:
        return 'İndiriliyor...';
      case _DownloadPhase.verifying:
        return 'Doğrulanıyor...';
      case _DownloadPhase.done:
        return 'Hazırsın.';
      case _DownloadPhase.error:
        return 'İndirme başarısız.';
    }
  }

  Widget _setupBody() {
    switch (_phase) {
      case _DownloadPhase.idle:
      case _DownloadPhase.checkingWifi:
        return _idleBody();
      case _DownloadPhase.downloading:
      case _DownloadPhase.verifying:
        return _progressBody();
      case _DownloadPhase.done:
        return _doneBody();
      case _DownloadPhase.error:
        return _errorBody();
    }
  }

  Widget _idleBody() {
    return Column(
      children: [
        _infoCard(
          title: 'GEREKSİNİMLER',
          items: const [
            '• ~2.3 GB boş depolama alanı',
            '• WiFi bağlantısı (önerilir)',
            '• İlk kurulum 5-20 dakika sürer',
            '• Kurulumdan sonra internet gerekmez',
          ],
        ),
        const SizedBox(height: 12),
        _infoCard(
          title: 'GİZLİLİK',
          items: const [
            '• Model cihazında kalır',
            '• Sorular sunucuya gönderilmez',
            '• Veri toplanmaz, analiz yapılmaz',
          ],
        ),
        if (_wifiChecked && !_onWifi) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _theme.urgent.withValues(alpha: 0.12),
              border: Border.all(color: _theme.urgent),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '⚠ WiFi bağlantısı tespit edilmedi. Mobil veri kullanmak pahalı olabilir.',
              style: TextStyle(color: _theme.urgent, fontSize: 11),
            ),
          ),
        ],
      ],
    );
  }

  Widget _progressBody() {
    final pct = _total == 0 ? 0.0 : (_received / _total).clamp(0.0, 1.0);
    final mbReceived = (_received / (1024 * 1024)).toStringAsFixed(1);
    final mbTotal = (_total / (1024 * 1024)).toStringAsFixed(0);
    final speed = _bytesPerSec > 0
        ? '${(_bytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s'
        : '--';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _theme.surface,
        border: Border.all(color: _theme.headerBorder),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$mbReceived / $mbTotal MB',
                style: TextStyle(
                  color: _theme.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(pct * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: _theme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _phase == _DownloadPhase.verifying ? null : pct,
              minHeight: 8,
              backgroundColor: _theme.headerBorder,
              color: _theme.primary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _stageLabel,
                style: TextStyle(
                  color: _theme.textPrimary,
                  fontSize: 12,
                ),
              ),
              if (_phase == _DownloadPhase.downloading)
                Text(
                  speed,
                  style: TextStyle(
                    color: _theme.critical,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Uygulamayı kapatma. Bağlantı koparsa kaldığı yerden devam eder.',
            style: TextStyle(
              color: _theme.textSubtle,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _doneBody() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _theme.surface,
        border: Border.all(color: _theme.protocol),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            '✓ KURULUM TAMAM',
            style: TextStyle(
              color: _theme.protocol,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Sentinel hazır. Bundan sonra internet gerektirmez.',
            style: TextStyle(
              color: _theme.textPrimary,
              fontSize: 12,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _errorBody() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _theme.urgent.withValues(alpha: 0.1),
        border: Border.all(color: _theme.urgent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✗ HATA',
            style: TextStyle(
              color: _theme.urgent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Bilinmeyen hata',
            style: TextStyle(
              color: _theme.textPrimary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'İndirme kaldığı yerden devam edebilir.',
            style: TextStyle(
              color: _theme.textSubtle,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _setupActions() {
    switch (_phase) {
      case _DownloadPhase.idle:
      case _DownloadPhase.checkingWifi:
        return _primaryButton(
          _phase == _DownloadPhase.checkingWifi ? 'KONTROL...' : 'İNDİRMEYİ BAŞLAT',
          _phase == _DownloadPhase.checkingWifi ? () {} : _checkWifiAndDownload,
        );
      case _DownloadPhase.downloading:
      case _DownloadPhase.verifying:
        return const SizedBox.shrink();
      case _DownloadPhase.done:
        return _primaryButton('GİRİŞ →', widget.onComplete);
      case _DownloadPhase.error:
        return _primaryButton('TEKRAR DENE', _runDownload);
    }
  }

  Widget _infoCard({required String title, required List<String> items}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _theme.surface,
        border: Border.all(color: _theme.headerBorder),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: _theme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: TextStyle(
                  color: _theme.textPrimary,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _theme.surface,
        border: Border.all(color: _theme.primary),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        '// $text //',
        style: TextStyle(
          color: _theme.primary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _feature(String mark, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mark,
            style: TextStyle(
              color: _theme.critical,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _theme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(
                    color: _theme.textMuted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _theme.primary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
