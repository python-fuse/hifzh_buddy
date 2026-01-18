import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hifzh_buddy/models/glyph_box.dart';
import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/uitls/coordinates_utils.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';

final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  return await QuranUtils.loadSurahs();
});

final coordinatesProvider =
    FutureProvider<Map<int, Map<String, List<GlyphBox>>>>((_) async {
      return await CoordinatesUtils.loadCoordinates();
    });

final bootProvider = FutureProvider<void>((ref) async {
  final surFuture = ref.watch(surahsProvider.future);
  final coordFuture = ref.watch(coordinatesProvider.future);

  await Future.wait([surFuture, coordFuture]);
});

// final pageImagesProvider = FutureProvider((ref) async {
//   return await QuranUtils.loadPageImages();
// });

final searchTermProvider = StateProvider<String>((ref) => '');

final activeTabProvider = StateProvider<Set<String>>((ref) => {'surah'});
