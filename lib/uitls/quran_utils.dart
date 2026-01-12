import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hifzh_buddy/models/ayah.dart';
import 'package:hifzh_buddy/models/surah.dart';

class QuranUtils {
  static Future<List<Surah>> loadSurahs() async {
    // Load JSON string from assets
    final surahsJson = await rootBundle.loadString('assets/text/quran.json');

    // Parse JSON in a separate isolate to avoid blocking UI
    final List<Surah> surahs = await compute(_parseSurahs, surahsJson);

    return surahs;
  }

  // This function runs in a separate isolate
  static List<Surah> _parseSurahs(String jsonString) {
    final dynamic decodedJson = jsonDecode(jsonString);

    final List<Surah> surahs = [];
    for (var surahJson in decodedJson) {
      surahs.add(Surah.fromJson(surahJson));
    }

    return surahs;
  }

  static Surah getSurah(int surahNumber, List<Surah> surahs) {
    return surahs.firstWhere((s) => s.number == surahNumber);
  }

  static List<Ayah> getSurahAyahs(int surahNumber, List<Surah> surahs) {
    return surahs.firstWhere((s) => s.number == surahNumber).ayahs;
  }

  static List<Ayah> getPageAyahs(int pageNumber, List<Surah> surahs) {
    final List<Ayah> allAyahs = surahs.expand((s) => s.ayahs).toList();
    final List<Ayah> pageAyahs = allAyahs
        .where((a) => a.page == pageNumber)
        .toList();
    return pageAyahs;
  }

  static Surah? getSurahByPage(int pageNumber, List<Surah> surahs) {
    try {
      return surahs.firstWhere((s) => s.ayahs.any((a) => a.page == pageNumber));
    } catch (e) {
      return null;
    }
  }
}
