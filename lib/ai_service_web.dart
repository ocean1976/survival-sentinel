class AIServicePlatform {
  Future<void> initialize() async {
    // Web platformunda mock initialization
    await Future.delayed(const Duration(seconds: 2));
    print('✅ Mock AI loaded (Web platform)');
  }

  Future<String> generateResponse(String prompt) async {
    // Web platformunda mock response
    await Future.delayed(const Duration(seconds: 1));
    return '''🌐 WEB DEMO MODE

This is a demo response. The real AI model (Phi-3 Mini) only works on Android/iOS devices.

To test real AI responses:
1. Build an Android APK
2. Install on your device
3. Ask survival questions offline!

Your question was: "$prompt"''';
  }

  void dispose() {
    // Web'de dispose işlemi yok
  }
}
