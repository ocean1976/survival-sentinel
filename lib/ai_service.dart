import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Conditional imports - sadece mobil/desktop için
import 'ai_service_mobile.dart' if (dart.library.html) 'ai_service_web.dart';

class AIService {
  late final AIServicePlatform _platform;
  bool _isInitialized = false;

  AIService() {
    _platform = AIServicePlatform();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _platform.initialize();
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
