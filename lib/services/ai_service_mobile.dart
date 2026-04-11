import 'dart:async';
import 'dart:io';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:path_provider/path_provider.dart';

/// Android tarafı için AI servisi.
///
/// `LlamaParent` kullanıyoruz — model yükleme + inference arka plan
/// isolate'inde yapılıyor. UI jank olmuyor; ayrıca Dart seviyesindeki
/// istisnalar ayrı isolate'te tutuluyor. (Not: native SIGSEGV hâlâ
/// tüm VM'i çökertir — mock fallback bunun için var.)
class AIServicePlatform {
  static const String modelFileName = 'gemma-2-2b-it-Q4_K_M.gguf';
  static const int maxTokens = 384;
  static const List<String> stopSequences = [
    '<end_of_turn>',
    '<start_of_turn>',
  ];

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

    // Agresif minimal parametreler — S22 Ultra'da stabil kalmak için:
    //   nCtx 512  (2048'den düşürüldü)
    //   nBatch 128 (512'den)
    //   nThreads 2
    //   nGpuLayers 0 (Android GPU backend yok)
    //   mmap on — model dosyasını heap'e kopyalama
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
      // Isolate'i temizlemeye çalış (başarısız olabilir, zararsız)
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

    sub = llama.stream.listen((token) {
      buf.write(token);
      final soFar = buf.toString();
      if (stopSequences.any(soFar.contains)) {
        if (!completer.isCompleted) completer.complete();
      }
    });

    // Completion event (isDone) ile de bitir
    final completionSub = llama.completions.listen((event) {
      if (!completer.isCompleted) completer.complete();
    });

    try {
      await llama.sendPrompt(formattedPrompt);
      await completer.future.timeout(
        const Duration(seconds: 120),
        onTimeout: () => throw TimeoutException('Yanıt 120 saniyede tamamlanmadı'),
      );
    } finally {
      await sub.cancel();
      await completionSub.cancel();
    }

    var out = buf.toString();
    for (final stop in stopSequences) {
      final idx = out.indexOf(stop);
      if (idx >= 0) out = out.substring(0, idx);
    }
    return out.trim();
  }

  void dispose() {
    _llama?.dispose().catchError((_) {});
    _llama = null;
    _ready = false;
  }
}
