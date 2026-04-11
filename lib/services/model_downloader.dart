import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Gemma 2 2B IT GGUF modelini Hugging Face'ten indirir.
/// - Uygulama belgeler dizinine kaydeder.
/// - Range request ile resume destekler (.part dosyası).
/// - SHA-256 checksum doğrular.
/// - Rapor etmek için bayt ve hız callback'i sağlar.
class ModelDownloader {
  /// Gemma 2 2B Instruct, Q4_K_M quantization (bartowski build).
  /// Source: https://huggingface.co/bartowski/gemma-2-2b-it-GGUF
  static const String modelUrl =
      'https://huggingface.co/bartowski/gemma-2-2b-it-GGUF/resolve/main/gemma-2-2b-it-Q4_K_M.gguf';

  static const String modelFileName = 'gemma-2-2b-it-Q4_K_M.gguf';

  /// SHA-256 of the upstream file, verified on Hugging Face LFS metadata.
  static const String expectedSha256 =
      'e0aee85060f168f0f2d8473d7ea41ce2f3230c1bc1374847505ea599288a7787';

  /// Upstream content-length as of publish time.
  static const int expectedBytes = 1708582752; // ~1.63 GB

  Future<File> modelFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$modelFileName');
  }

  Future<File> _partFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$modelFileName.part');
  }

  Future<bool> isModelReady() async {
    final f = await modelFile();
    if (!f.existsSync()) return false;
    // Dosya yarım kalmış olabilir — en azından boyut kontrolü yap.
    final len = await f.length();
    return len > 100 * 1024 * 1024; // >100 MB ise hazırdır varsayımı
  }

  Future<int> existingPartBytes() async {
    final p = await _partFile();
    return p.existsSync() ? await p.length() : 0;
  }

  /// İndirme akışı. Tek atımda başlatılır, `onProgress` baytsal ilerleme,
  /// `onStage` mevcut faz için insan okunabilir metin sağlar.
  Future<ModelDownloadResult> download({
    required void Function(int received, int total, double bytesPerSec)
        onProgress,
    required void Function(String stage) onStage,
  }) async {
    try {
      final finalFile = await modelFile();
      final partFile = await _partFile();

      // Zaten tam dosya varsa doğrula ve bitir.
      if (finalFile.existsSync()) {
        onStage('Var olan model doğrulanıyor');
        if (await _verifyChecksum(finalFile)) {
          return ModelDownloadResult.success(finalFile);
        }
        await finalFile.delete();
      }

      // Resume mü?
      int startByte = 0;
      if (partFile.existsSync()) {
        startByte = await partFile.length();
        onStage('Kaldığı yerden devam ediliyor');
      } else {
        onStage('İndirme başlatılıyor');
      }

      final client = http.Client();
      try {
        final request = http.Request('GET', Uri.parse(modelUrl));
        if (startByte > 0) {
          request.headers['Range'] = 'bytes=$startByte-';
        }

        final response = await client.send(request);
        if (response.statusCode != 200 && response.statusCode != 206) {
          return ModelDownloadResult.error(
              'Sunucu yanıtı: HTTP ${response.statusCode}');
        }

        final contentLength = response.contentLength ?? 0;
        final total = contentLength > 0 ? contentLength + startByte : expectedBytes;
        int received = startByte;

        DateTime lastTick = DateTime.now();
        int lastBytes = received;

        final sink = partFile.openWrite(mode: FileMode.append);
        try {
          await for (final chunk in response.stream) {
            sink.add(chunk);
            received += chunk.length;

            final now = DateTime.now();
            final elapsedMs = now.difference(lastTick).inMilliseconds;
            if (elapsedMs >= 500) {
              final bps = ((received - lastBytes) * 1000.0) / elapsedMs;
              onProgress(received, total, bps);
              lastTick = now;
              lastBytes = received;
            }
          }
        } finally {
          await sink.flush();
          await sink.close();
        }

        onProgress(received, total, 0);
        onStage('Dosya bütünlüğü doğrulanıyor (SHA-256)');

        if (!await _verifyChecksum(partFile)) {
          // Bozuk dosyayı sil — kullanıcı tekrar denerse sıfırdan başlasın.
          await partFile.delete();
          return ModelDownloadResult.error(
              'Checksum doğrulaması başarısız. Dosya bozuk olabilir.');
        }

        onStage('Kurulum sonlandırılıyor');
        await partFile.rename(finalFile.path);
        return ModelDownloadResult.success(finalFile);
      } finally {
        client.close();
      }
    } on SocketException catch (e) {
      return ModelDownloadResult.error('Ağ hatası: ${e.message}');
    } catch (e) {
      return ModelDownloadResult.error(e.toString());
    }
  }

  Future<bool> _verifyChecksum(File file) async {
    if (expectedSha256 == 'PLACEHOLDER_CHECKSUM') {
      // Gerçek checksum yok — doğrulama atla.
      return true;
    }
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString().toLowerCase() == expectedSha256.toLowerCase();
  }
}

class ModelDownloadResult {
  final bool success;
  final File? file;
  final String? error;

  const ModelDownloadResult._(
      {required this.success, this.file, this.error});

  factory ModelDownloadResult.success(File file) =>
      ModelDownloadResult._(success: true, file: file);

  factory ModelDownloadResult.error(String message) =>
      ModelDownloadResult._(success: false, error: message);
}
