import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';

final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  return await QuranUtils.loadSurahs();
});
