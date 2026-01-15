import 'dart:developer';

import 'package:hifzh_buddy/models/ayah.dart';
import 'package:hifzh_buddy/models/reciter.dart';
import 'package:hifzh_buddy/service/quran_audio_download_service.dart';
import 'package:path_provider/path_provider.dart';

class QuranAudioService {
  final QuranDownloadService _downloadService;

  QuranAudioService(this._downloadService);

  // detwermine where to load the audio from
  Future<AudioSourceType> getAudioSourceType(Reciter reciter, Ayah ayah) async {
    if (reciter.isBundled) {
      return AudioSourceType.bundled;
    }

    final isCached = await _downloadService.isFileCached(
      ayah: ayah,
      reciter: reciter,
    );

    if (isCached) {
      return AudioSourceType.cached;
    }

    return AudioSourceType.streaming;
  }

  Future<String> getAudioPath(
    Reciter reciter,
    Ayah ayah,
    bool cacheIfStreaming,
  ) async {
    final sourceType = await getAudioSourceType(reciter, ayah);

    switch (sourceType) {
      case AudioSourceType.bundled:
        return reciter.getBundledAudioPath(ayah.audioPath);
      case AudioSourceType.cached:
        return await _getCachedFilePath(reciter, ayah);
      case AudioSourceType.streaming:
        if (cacheIfStreaming) {
          _cacheInBg(reciter, ayah);
        }
        return reciter.getRemoteUrl(ayah.globalNumber);
    }
  }

  Future<void> _cacheInBg(Reciter reciter, Ayah ayah) async {
    try {
      await _downloadService.downloadVerse(ayah: ayah, reciter: reciter);
    } catch (e) {
      log(
        "Failed to cache ${reciter.englishName} - Ayah ${ayah.globalNumber}.Please download from download manager",
      );
    }
  }

  Future<String> _getCachedFilePath(Reciter reciter, Ayah ayah) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/${reciter.getCachedAudiopath(ayah.globalNumber)}';
  }
}
