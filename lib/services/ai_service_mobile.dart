import 'dart:io';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:path_provider/path_provider.dart';

class AIServicePlatform {
  static const String modelFileName = 'gemma-4-2b-it-q4.gguf';
  static const int maxTokens = 512;
  static const List<String> stopSequences = ['<end_of_turn>', '<start_of_turn>'];

  Llama? _llama;

  Future<void> initialize({
    void Function(int stage, int total, String label)? onProgress,
  }) async {
    onProgress?.call(1, 2, 'Model konumu kontrol ediliyor');
    final dir = await getApplicationDocumentsDirectory();
    final modelPath = '${dir.path}/$modelFileName';

    if (!File(modelPath).existsSync()) {
      throw Exception(
          'AI modeli bulunamadı. Lütfen onboarding\'i tamamlayın.');
    }

    onProgress?.call(2, 2, 'Model başlatılıyor');
    final contextParams = ContextParams()
      ..nCtx = 2048
      ..nBatch = 512
      ..nThreads = 4
      ..nThreadsBatch = 4
      ..nPredict = maxTokens;

    _llama = Llama(modelPath, null, contextParams);
  }

  Future<String> generateResponse(String formattedPrompt) async {
    final llama = _llama;
    if (llama == null) {
      throw Exception('Model not loaded');
    }

    llama.setPrompt(formattedPrompt);
    final buf = StringBuffer();
    int produced = 0;
    await for (final token in llama.generateText()) {
      buf.write(token);
      produced++;
      final soFar = buf.toString();
      if (stopSequences.any(soFar.contains)) {
        break;
      }
      if (produced >= maxTokens) {
        break;
      }
    }

    var out = buf.toString();
    for (final stop in stopSequences) {
      final idx = out.indexOf(stop);
      if (idx >= 0) {
        out = out.substring(0, idx);
      }
    }
    return out.trim();
  }

  void dispose() {
    _llama?.dispose();
    _llama = null;
  }
}
