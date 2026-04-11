import 'dart:io';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:path_provider/path_provider.dart';

class AIServicePlatform {
  static const String modelFileName = 'gemma-2-2b-it-Q4_K_M.gguf';
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

    final fileSize = await File(modelPath).length();
    if (fileSize < 100 * 1024 * 1024) {
      throw Exception(
          'Model dosyası eksik veya bozuk (${fileSize ~/ (1024 * 1024)} MB). Yeniden indirilmeli.');
    }

    onProgress?.call(2, 2, 'Model başlatılıyor');

    // Android için güvenli parametreler:
    // - nGpuLayers = 0: GPU offload yok, saf CPU (S22 Ultra'da GPU desteği yok)
    // - useMemorymap: true — modeli RAM'e kopyalamadan mmap ile yükle
    // - nCtx = 1024: 2k yerine 1k, RAM basıncını yarıya indirir
    // - nThreads = 2: 4 yerine 2, thread yönetimi maliyetini azaltır
    final modelParams = ModelParams()
      ..nGpuLayers = 0
      ..useMemorymap = true
      ..vocabOnly = false;

    final contextParams = ContextParams()
      ..nCtx = 1024
      ..nBatch = 256
      ..nUbatch = 256
      ..nThreads = 2
      ..nThreadsBatch = 2
      ..nPredict = maxTokens;

    try {
      _llama = Llama(modelPath, modelParams, contextParams);
    } catch (e, stack) {
      _llama = null;
      throw Exception('Model yüklenemedi: $e\n\nÇözüm önerileri:\n'
          '• Uygulamayı yeniden başlatın\n'
          '• Yeterli boş RAM olduğundan emin olun\n'
          '• Model dosyasını yeniden indirin\n\n'
          'Teknik detay: $stack');
    }
  }

  Future<String> generateResponse(String formattedPrompt) async {
    final llama = _llama;
    if (llama == null) {
      throw Exception('Model not loaded');
    }

    try {
      llama.setPrompt(formattedPrompt);
      final buf = StringBuffer();
      int produced = 0;
      await for (final token in llama.generateText()) {
        buf.write(token);
        produced++;
        final soFar = buf.toString();
        if (stopSequences.any(soFar.contains)) break;
        if (produced >= maxTokens) break;
      }

      var out = buf.toString();
      for (final stop in stopSequences) {
        final idx = out.indexOf(stop);
        if (idx >= 0) out = out.substring(0, idx);
      }
      return out.trim();
    } catch (e) {
      return 'Yanıt oluşturulurken hata: $e';
    }
  }

  void dispose() {
    try {
      _llama?.dispose();
    } catch (_) {
      // Zararsız — model zaten freed olabilir
    }
    _llama = null;
  }
}
