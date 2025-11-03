import 'package:flutter/services.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AIServicePlatform {
  LlamaCpp? _llama;

  Future<void> initialize() async {
    try {
      // Asset'ten modeli geçici dizine kopyala
      final tempDir = await getTemporaryDirectory();
      final modelPath = '${tempDir.path}/phi-3-mini-4k-instruct-q4.gguf';
      
      // Model dosyası yoksa kopyala
      if (!await File(modelPath).exists()) {
        print('📦 Copying AI model to device...');
        final data = await rootBundle.load('assets/models/phi-3-mini-4k-instruct-q4.gguf');
        final bytes = data.buffer.asUint8List();
        await File(modelPath).writeAsBytes(bytes);
        print('✅ Model copied successfully');
      }

      // Modeli yükle
      print('🔄 Loading AI model...');
      _llama = LlamaCpp(
        modelPath: modelPath,
        contextSize: 2048,
        threads: 4,
      );

      print('✅ Phi-3 model loaded successfully!');
    } catch (e) {
      print('❌ Error loading model: $e');
      rethrow;
    }
  }

  Future<String> generateResponse(String prompt) async {
    if (_llama == null) {
      throw Exception('Model not loaded');
    }

    try {
      // Phi-3 için özel prompt formatı
      final formattedPrompt = '''<|system|>
You are an emergency survival assistant. Provide clear, concise, and life-saving advice. Use short sentences and actionable steps.<|end|>
<|user|>
$prompt<|end|>
<|assistant|>
''';

      final response = await _llama!.complete(
        formattedPrompt,
        maxTokens: 512,
        temperature: 0.7,
        topP: 0.9,
        stopSequences: ['<|end|>', '<|user|>'],
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
