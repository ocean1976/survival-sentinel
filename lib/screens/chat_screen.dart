import 'dart:async';
import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../services/skill_router.dart';
import '../services/usage_service.dart';
import '../utils/prompt_builder.dart';
import '../utils/strings.dart';
import '../utils/theme.dart';
import '../widgets/crt_overlay.dart';
import '../widgets/lighthouse_icon.dart';
import '../widgets/sos_confirm_dialog.dart';
import '../widgets/structured_response.dart';
import '../widgets/typing_text.dart';
import 'settings_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const Duration _modeTransition = Duration(milliseconds: 300);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIService _aiService = AIService();
  late final SkillRouter _skillRouter = SkillRouter(language: S.language.value);
  final UsageService _usage = UsageService();

  HavenTheme _theme = HavenTheme.normal;
  bool _isLoading = false;
  bool _isModelLoaded = false;
  bool _mockMode = false;
  bool _crashLoopDetected = false;
  String? _initError;
  final List<ChatMessage> _messages = [];

  bool _premium = false;
  int _questionsUsed = 0;
  Duration _sosRemaining = Duration.zero;
  Timer? _sosTicker;

  bool get _isBunker => _theme.mode == HavenMode.bunker;
  bool get _sosActive => _sosRemaining > Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeAI();
  }

  /// DEFAULT MOCK: Uygulama AI'yı otomatik init etmez.
  /// Native llama.cpp Android'de crash ediyor; kullanıcının tek yolu
  /// uygulamayı açamamak olmasın — default olarak mock mode'da başla,
  /// settings'teki "Gerçek AI'yı dene (deneysel)" butonu ile kullanıcı
  /// kendi isterse init'i tetikler.
  Future<void> _initializeAI() async {
    setState(() {
      _isLoading = true;
      _initError = null;
      _crashLoopDetected = false;
    });

    await _skillRouter.load();
    await _syncUsage();
    if (await _usage.isSOSActive()) {
      if (mounted) setState(() => _theme = HavenTheme.bunker);
      _startSOSTicker();
    }

    // Default: her zaman mock mode ile aç.
    _enterMockMode();
  }

  /// Kullanıcı settings'ten manuel olarak AI'yı denemek isterse çağrılır.
  /// Başarılı olursa mock'tan çıkar; başarısız olursa mock'a dönüp hatayı gösterir.
  Future<void> _tryRealAI() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _isModelLoaded = false;
      _mockMode = false;
      _initError = null;
    });

    await _usage.markInitStarted();
    try {
      await _aiService.initialize();
      await _usage.markInitFinished();
      await _usage.setMockMode(false);
      if (!mounted) return;
      setState(() {
        _isModelLoaded = true;
        _isLoading = false;
      });
      _addMessage(ChatMessage(
        text: S.current.welcomeMessage,
        isUser: false,
      ));
    } catch (e) {
      await _usage.markInitFinished();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _initError = e.toString();
      });
    }
  }

  Future<void> _retryInitialization() async {
    await _tryRealAI();
  }

  Future<void> _enterMockMode() async {
    await _usage.setMockMode(true);
    await _usage.markInitFinished();
    if (!mounted) return;
    setState(() {
      _mockMode = true;
      _isModelLoaded = true;
      _isLoading = false;
      _initError = null;
    });
    if (_messages.isEmpty) {
      _addMessage(ChatMessage(
        text: S.current.welcomeMessage,
        isUser: false,
      ));
    }
  }

  void _addMessage(ChatMessage message) {
    setState(() => _messages.add(message));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || !_isModelLoaded) return;

    if (!await _usage.canAskQuestion()) {
      _addMessage(ChatMessage(
        text: S.format(S.current.dailyLimitReached,
            {'limit': UsageService.dailyLimit.toString()}),
        isUser: false,
        typingDone: true,
      ));
      return;
    }

    _messageController.clear();
    _addMessage(ChatMessage(text: text, isUser: true, typingDone: true));
    setState(() => _isLoading = true);

    if (_mockMode) {
      final skill = _skillRouter.match(text);
      final mockResponse = skill != null
          ? skill.body
          : S.current.mockResponseNoSkill;
      await _usage.recordQuestion();
      await _syncUsage();
      if (!mounted) return;
      setState(() => _isLoading = false);
      _addMessage(ChatMessage(text: mockResponse, isUser: false));
      return;
    }

    try {
      final skill = _skillRouter.match(text);
      final formattedPrompt = PromptBuilder.build(
        userMessage: text,
        skill: skill,
        language: S.language.value,
      );
      final response = await _aiService.generateResponse(formattedPrompt);
      await _usage.recordQuestion();
      await _syncUsage();
      if (!mounted) return;
      setState(() => _isLoading = false);
      _addMessage(ChatMessage(text: response, isUser: false));
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError(S.format(S.current.genericError, {'error': e.toString()}));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _onSOSPressed() async {
    if (_isBunker) {
      await _usage.deactivateSOS();
      _stopSOSTicker();
      await _syncUsage();
      setState(() => _theme = HavenTheme.normal);
      return;
    }

    if (!await _usage.canActivateSOS()) {
      final remaining = await _usage.sosCooldownRemaining();
      if (!mounted) return;
      _showError(S.format(S.current.sosCooldownMessage,
          {'remaining': _formatDuration(remaining)}));
      return;
    }

    if (!mounted) return;
    final confirmed = await showSOSConfirmDialog(context);
    if (confirmed == true) {
      await _usage.activateSOS();
      await _syncUsage();
      _startSOSTicker();
      setState(() => _theme = HavenTheme.bunker);
    }
  }

  Future<void> _syncUsage() async {
    final premium = await _usage.isPremium();
    final used = await _usage.questionsToday();
    final remaining = await _usage.sosRemaining();
    if (!mounted) return;
    setState(() {
      _premium = premium;
      _questionsUsed = used;
      _sosRemaining = remaining;
    });
  }

  void _startSOSTicker() {
    _sosTicker?.cancel();
    _sosTicker = Timer.periodic(const Duration(seconds: 1), (_) async {
      final remaining = await _usage.sosRemaining();
      if (!mounted) return;
      setState(() => _sosRemaining = remaining);
      if (remaining == Duration.zero) {
        _stopSOSTicker();
        await _usage.deactivateSOS();
        setState(() => _theme = HavenTheme.normal);
      }
    });
  }

  void _stopSOSTicker() {
    _sosTicker?.cancel();
    _sosTicker = null;
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:$m:$s';
  }

  void _openSettings() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => SettingsScreen(
              theme: _theme,
              usage: _usage,
              onClearChat: _clearChat,
              onTryRealAI: _tryRealAI,
              mockMode: _mockMode,
            ),
          ),
        )
        .then((_) => _syncUsage());
  }

  void _clearChat() {
    setState(() => _messages.clear());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _modeTransition,
      color: _theme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildDivider(),
                      if (_mockMode) _buildMockBanner(),
                      Expanded(
                        child: _isModelLoaded
                            ? _buildChatArea()
                            : _buildLoadingScreen(),
                      ),
                      if (_isModelLoaded) _buildDisclaimerBar(),
                      if (_isModelLoaded) _buildInputArea(),
                    ],
                  ),
                ),
              ),
              if (_isBunker)
                const Positioned.fill(
                  child: IgnorePointer(child: CRTOverlay()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    if (_initError != null) return _buildErrorScreen();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: _theme.primary),
          const SizedBox(height: 20),
          Text(
            S.current.loadingModel,
            textAlign: TextAlign.center,
            style: TextStyle(color: _theme.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    final s = S.current;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              s.initErrorTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _theme.urgent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _theme.surface,
                  border: Border.all(color: _theme.urgent),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _initError ?? '—',
                    style: TextStyle(
                      color: _theme.textPrimary,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!_crashLoopDetected)
              _errorButton(
                label: s.retryButton,
                filled: true,
                onTap: _retryInitialization,
              ),
            if (!_crashLoopDetected) const SizedBox(height: 10),
            _errorButton(
              label: s.demoModeButton,
              filled: _crashLoopDetected,
              onTap: _enterMockMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorButton({
    required String label,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? _theme.primary : _theme.surface,
          border: Border.all(color: _theme.primary),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: filled ? Colors.white : _theme.primary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildMockBanner() {
    return Container(
      width: double.infinity,
      color: _theme.critical.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        S.current.mockBanner,
        style: TextStyle(
          color: _theme.critical,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return AnimatedContainer(
      duration: _modeTransition,
      color: _theme.background,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _messages.length) return _buildTypingIndicator();
          final message = _messages[index];
          return Padding(
            key: ValueKey('msg_$index'),
            padding: const EdgeInsets.only(bottom: 16),
            child: message.isUser
                ? _buildUserMessage(message)
                : _buildAIResponse(message),
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(
            S.current.thinking,
            style: TextStyle(
              color: _theme.textMuted,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _theme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedContainer(
      duration: _modeTransition,
      color: _theme.headerBg,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!_isBunker)
                GestureDetector(
                  onTap: _openSettings,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _theme.surface,
                      border: Border.all(color: _theme.headerBorder),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '[=]',
                      style: TextStyle(
                        color: _theme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (!_isBunker) const SizedBox(width: 10),
              LighthouseIcon(color: _theme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: _modeTransition,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _theme.primary,
                    letterSpacing: 2,
                  ),
                  child: const Text('HAVEN PROTOCOL'),
                ),
              ),
              _buildSOSButton(),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: _modeTransition,
            style: TextStyle(
              fontSize: 11,
              color: _theme.primaryDim,
              letterSpacing: 1.2,
            ),
            child: Text(_isBunker
                ? S.current.appTaglineSosActive
                : S.current.appTagline),
          ),
          const SizedBox(height: 6),
          _buildInfoBar(),
        ],
      ),
    );
  }

  Widget _buildInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _theme.surface,
        border: Border.all(color: _theme.headerBorder),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          if (_sosActive) ...[
            Expanded(
              child: Text(
                S.current.sosActiveLabel,
                style: TextStyle(
                  color: _theme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            Text(
              _formatDuration(_sosRemaining),
              style: TextStyle(
                color: _theme.critical,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ] else ...[
            Expanded(
              child: Text(
                _premium
                    ? S.current.quotaPremium
                    : S.format(S.current.quotaLabel, {
                        'used': _questionsUsed.toString(),
                        'total': UsageService.dailyLimit.toString(),
                      }),
                style: TextStyle(
                  color: _theme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            if (!_premium)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B6914), Color(0xFFC9A227)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  S.current.premiumBadge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSOSButton() {
    return GestureDetector(
      onTap: _onSOSPressed,
      child: AnimatedContainer(
        duration: _modeTransition,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _theme.sosGradient,
          ),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: _theme.sosBorder),
          boxShadow: [
            BoxShadow(
              color: _theme.sosGradient.first.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          S.current.sosButton,
          style: TextStyle(
            color: _theme.sosText,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return AnimatedContainer(
      duration: _modeTransition,
      height: 2,
      color: _theme.divider,
    );
  }

  Widget _buildUserMessage(ChatMessage message) {
    final timestamp = _formatTime(message.timestamp);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.current.userLabel,
              style: TextStyle(
                fontSize: 9,
                color: _theme.userLabel,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              '[$timestamp UTC]',
              style: TextStyle(fontSize: 9, color: _theme.textSubtle),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: _theme.userBg,
            border: Border(
              left: BorderSide(color: _theme.userBorder, width: 3),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: _theme.messageText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIResponse(ChatMessage message) {
    final timestamp = _formatTime(message.timestamp);
    final textStyle = TextStyle(
      color: _theme.messageText,
      fontSize: 14,
      height: 1.55,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.current.aiLabel,
              style: TextStyle(
                fontSize: 9,
                color: _theme.aiLabel,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              '[$timestamp UTC]',
              style: TextStyle(fontSize: 9, color: _theme.textSubtle),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: _theme.aiBg,
            border: Border(
              left: BorderSide(color: _theme.aiBorder, width: 3),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: message.typingDone
              ? StructuredResponse(text: message.text, theme: _theme)
              : TypingText(
                  key: ValueKey(
                      'typing_${message.timestamp.microsecondsSinceEpoch}'),
                  text: message.text,
                  style: textStyle,
                  cursorColor: _theme.cursor,
                  onProgress: _scrollToBottom,
                  onComplete: () {
                    if (!mounted) return;
                    setState(() => message.typingDone = true);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDisclaimerBar() {
    return AnimatedContainer(
      duration: _modeTransition,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _theme.disclaimerBg,
        border: Border(top: BorderSide(color: _theme.disclaimerBorder)),
      ),
      child: Text(
        S.current.disclaimerBar,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _theme.disclaimerText,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return AnimatedContainer(
      duration: _modeTransition,
      color: _theme.inputBg,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Container(
        decoration: BoxDecoration(
          color: _theme.inputFieldBg,
          border: Border.all(color: _theme.inputBorder),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
              child: Text(
                '>',
                style: TextStyle(
                  color: _theme.inputPrompt,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !_isLoading,
                style: TextStyle(fontSize: 13, color: _theme.inputText),
                decoration: InputDecoration(
                  hintText: S.current.inputHint,
                  hintStyle: TextStyle(
                    color: _theme.inputText.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            Container(
              color: _theme.sendBg,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: GestureDetector(
                onTap: _isLoading ? null : _sendMessage,
                child: Text(
                  '▶',
                  style: TextStyle(color: _theme.primary, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  @override
  void dispose() {
    _sosTicker?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _aiService.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  bool typingDone;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.typingDone = false,
  }) : timestamp = timestamp ?? DateTime.now().toUtc();
}
