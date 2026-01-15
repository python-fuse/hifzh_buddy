import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hifzh_buddy/models/reciter.dart';
import 'package:hifzh_buddy/service/quran_audio_download_service.dart';
import 'package:hifzh_buddy/service/quran_audio_service.dart';

final downloadServiceProvider = Provider((ref) {
  return QuranDownloadService();
});

final quranAudioServiceProvider = Provider((ref) {
  return QuranAudioService(ref.watch(downloadServiceProvider));
});

final selectedReciterProvider = StateProvider((ref) {
  return Reciter(
    englishName: "husary",
    id: "ar.abdulbasitmurattal",
    name: "huss",
  );
});
