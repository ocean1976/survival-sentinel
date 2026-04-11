import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/model_downloader.dart';
import 'services/usage_service.dart';
import 'utils/strings.dart';
import 'utils/theme.dart';
import 'widgets/lighthouse_icon.dart';

void main() {
  runApp(const HavenProtocolApp());
}

class HavenProtocolApp extends StatelessWidget {
  const HavenProtocolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: S.language,
      builder: (context, _, __) {
        return MaterialApp(
          title: 'Haven Protocol',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'SpaceMono'),
          home: const AppRoot(),
        );
      },
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final UsageService _usage = UsageService();
  final ModelDownloader _downloader = ModelDownloader();

  bool? _ready;

  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final lang = await _usage.getLanguage();
    S.language.value = lang;
    final completed = await _usage.isOnboardingComplete();
    final modelReady = await _downloader.isModelReady();
    if (!mounted) return;
    setState(() => _ready = completed && modelReady);
  }

  void _onboardingDone() {
    setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_ready == null) return const _SplashScreen();
    if (_ready == false) {
      return OnboardingScreen(
        usage: _usage,
        onComplete: _onboardingDone,
      );
    }
    return const ChatScreen();
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    const theme = HavenTheme.normal;
    return Scaffold(
      backgroundColor: theme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LighthouseIcon(color: theme.primary),
            const SizedBox(height: 16),
            Text(
              'HAVEN PROTOCOL',
              style: TextStyle(
                color: theme.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
