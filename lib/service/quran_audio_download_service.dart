import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hifzh_buddy/models/ayah.dart';
import 'package:hifzh_buddy/models/reciter.dart';
import 'package:path_provider/path_provider.dart';

class QuranDownloadService {
  final Dio dio = Dio();

  Future<void> downloadVerse({
    required Ayah ayah,
    required Reciter reciter,
    Function(double)? onProgress,
  }) async {
    final url = reciter.getRemoteUrl(ayah.globalNumber);
    final savePath = await _getFullCachePath(reciter, ayah);

    // Create directory if it doesn't exist
    final file = File(savePath);

    // Check if parent exists
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    // Download
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1 && onProgress != null) {
          onProgress(received / total);
        }
      },
    );

    log("Downloaded $url to $savePath");
  }

  // Check if file is already cached
  Future<bool> isFileCached({
    required Ayah ayah,
    required Reciter reciter,
  }) async {
    final path = await _getFullCachePath(reciter, ayah);
    return await File(path).exists();
  }

  Future<String> _getFullCachePath(Reciter reciter, Ayah ayah) async {
    final dir = await getApplicationDocumentsDirectory();
    final fullPath =
        '${dir.path}/${reciter.getCachedAudiopath(ayah.globalNumber)}';
    return fullPath;
  }

  Future<List<File>> getReciterFiles(Reciter reciter) async {
    final dir = await getApplicationDocumentsDirectory();
    final reciterFilesPath = '${dir.path}/quran_audio/${reciter.id}';

    final filesInPath = await Directory(
      reciterFilesPath,
    ).create(recursive: true);

    log("Total: ${filesInPath.listSync().length}");

    return filesInPath.listSync().map((e) => File(e.path)).toList();
  }

  int getAyahNumberFromFilePath(File file) {
    return int.parse(file.path.split('/').last.split('.').first);
  }
}
