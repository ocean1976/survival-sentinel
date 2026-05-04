import 'dart:async';
import 'dart:io';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:path_provider/path_provider.dart';

/// Android/iOS AI servisi — llama_cpp_dart v0.2.2 API.
///
/// `LlamaParent` isolate kullanır: model yükleme + inference arka planda.
/// GemmaFormat ile prompt formatting kütüphane tarafında yapılır.
class AIServicePlatform {
  static const String modelFileName = 'gemma-2-2b-it-Q4_K_M.gguf';
  static const int maxTokens = 384;

  LlamaParent? _llama;
  bool _ready = false;

  Future<void> initialize({
    void Function(int stage, int total, String label)? onProgress,
  }) async {
    onProgress?.call(1, 3, 'Model konumu kontrol ediliyor');
    final dir = await getApplicationDocumentsDirectory();
    final modelPath = '${dir.path}/$modelFileName';

    if (!File(modelPath).existsSync()) {
      throw Exception(
          'AI modeli bulunamadı. Lütfen onboarding\'i tamamlayın.');
    }

    final fileSize = await File(modelPath).length();
    if (fileSize < 100 * 1024 * 1024) {
      throw Exception(
          'Model dosyası eksik veya bozuk (${fileSize ~/ (1024 * 1024)} MB).');
    }

    onProgress?.call(2, 3, 'İsolate başlatılıyor');

    // v0.2.2 API — named parameters
    final modelParams = ModelParams()
      ..nGpuLayers = 0
      ..useMemorymap = true
      ..vocabOnly = false;

    final contextParams = ContextParams()
      ..nCtx = 512
      ..nBatch = 128
      ..nUbatch = 128
      ..nThreads = 2
      ..nThreadsBatch = 2
      ..nPredict = maxTokens;

    final samplerParams = SamplerParams()
      ..temp = 0.7
      ..topP = 0.9
      ..topK = 40;

    // v0.2.2: LlamaLoad uses named parameters
    final load = LlamaLoad(
      path: modelPath,
      modelParams: modelParams,
      contextParams: contextParams,
      samplingParams: samplerParams,
    );

    final parent = LlamaParent(load);
    try {
      onProgress?.call(3, 3, 'Model başlatılıyor');
      await parent.init().timeout(
        const Duration(seconds: 90),
        onTimeout: () => throw TimeoutException(
            'Model yükleme 90 saniyede tamamlanmadı. Cihaz RAM\'i yetersiz olabilir.'),
      );
      _llama = parent;
      _ready = true;
    } catch (e) {
      _llama = null;
      _ready = false;
      parent.dispose().catchError((_) {});
      rethrow;
    }
  }

  Future<String> generateResponse(String formattedPrompt) async {
    final llama = _llama;
    if (llama == null || !_ready) {
      throw Exception('Model not loaded');
    }

    final buf = StringBuffer();
    final completer = Completer<void>();
    StreamSubscription<String>? sub;
    StreamSubscription<CompletionEvent>? completionSub;

    sub = llama.stream.listen((token) {
      buf.write(token);
    });

    // v0.2.2: completions emits CompletionEvent
    completionSub = llama.completions.listen((event) {
      if (!completer.isCompleted) completer.complete();
    });

    try {
      // v0.2.2: sendPrompt returns Future<String> (promptId)
      await llama.sendPrompt(formattedPrompt);
      await completer.future.timeout(
        const Duration(seconds: 120),
        onTimeout: () =>
            throw TimeoutException('Yanıt 120 saniyede tamamlanmadı'),
      );
    } finally {
      await sub.cancel();
      await completionSub.cancel();
    }

    return buf.toString().trim();
  }

  void dispose() {
    _llama?.dispose().catchError((_) {});
    _llama = null;
    _ready = false;
  }
}
