import 'ai_service_mobile.dart' if (dart.library.html) 'ai_service_web.dart';

typedef InitProgressCallback = void Function(int stage, int total, String label);

class AIService {
  late final AIServicePlatform _platform;
  bool _isInitialized = false;

  AIService() {
    _platform = AIServicePlatform();
  }

  Future<void> initialize({InitProgressCallback? onProgress}) async {
    if (_isInitialized) {
      onProgress?.call(3, 3, 'Hazır');
      return;
    }
    await _platform.initialize(onProgress: onProgress);
    _isInitialized = true;
  }

  Future<String> generateResponse(String prompt) async {
    if (!_isInitialized) {
      throw Exception('Model not initialized. Call initialize() first.');
    }
    return await _platform.generateResponse(prompt);
  }

  void dispose() {
    _platform.dispose();
    _isInitialized = false;
  }
}
