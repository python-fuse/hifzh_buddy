import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';

final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  return await QuranUtils.loadSurahs();
});

// final pageImagesProvider = FutureProvider((ref) async {
//   return await QuranUtils.loadPageImages();
// });

final searchTermProvider = StateProvider<String>((ref) => '');

final activeTabProvider = StateProvider<Set<String>>((ref) => {'surah'});
