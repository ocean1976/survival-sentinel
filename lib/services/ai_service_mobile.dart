import 'dart:io';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:path_provider/path_provider.dart';

class AIServicePlatform {
  static const String modelFileName = 'gemma-4-2b-it-q4.gguf';

  LlamaCpp? _llama;

  Future<void> initialize({
    void Function(int stage, int total, String label)? onProgress,
  }) async {
    try {
      onProgress?.call(1, 2, 'Model konumu kontrol ediliyor');
      final dir = await getApplicationDocumentsDirectory();
      final modelPath = '${dir.path}/$modelFileName';

      if (!File(modelPath).existsSync()) {
        throw Exception(
            'AI modeli bulunamadı. Lütfen onboarding\'i tamamlayın.');
      }

      onProgress?.call(2, 2, 'Model başlatılıyor');
      _llama = LlamaCpp(
        modelPath: modelPath,
        contextSize: 2048,
        threads: 4,
      );
    } catch (e) {
      print('❌ Error loading model: $e');
      rethrow;
    }
  }

  Future<String> generateResponse(String formattedPrompt) async {
    if (_llama == null) {
      throw Exception('Model not loaded');
    }

    try {
      final response = await _llama!.complete(
        formattedPrompt,
        maxTokens: 512,
        temperature: 0.7,
        topP: 0.9,
        stopSequences: ['<end_of_turn>', '<start_of_turn>'],
      );
      return response.trim();
    } catch (e) {
      print('❌ Error generating response: $e');
      return 'Sorry, I encountered an error. Please try again.';
    }
  }

  void dispose() {
    _llama?.dispose();
  }
}
