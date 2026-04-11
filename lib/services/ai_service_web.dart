class AIServicePlatform {
  Future<void> initialize({
    void Function(int stage, int total, String label)? onProgress,
  }) async {
    onProgress?.call(1, 3, 'Mock storage');
    await Future.delayed(const Duration(seconds: 1));
    onProgress?.call(2, 3, 'Mock model copy');
    await Future.delayed(const Duration(seconds: 1));
    onProgress?.call(3, 3, 'Ready');
  }

  Future<String> generateResponse(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    return '''🌐 WEB DEMO MODE

Haven Protocol's real AI model (Gemma 2) only runs on Android/iOS devices.

Your prompt was: "$prompt"''';
  }

  void dispose() {}
}
