import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hifzh_buddy/models/ayah.dart';
import 'package:hifzh_buddy/models/surah.dart';
import 'package:quran_library/quran_library.dart';

/*
** QuranUtils
** This class contains all methods to handle Quran data, using own resources and third party packages
*/
class QuranUtils {
  /*
  ** loadSurahs
  ** Loads the surahs from the assets folder
  */
  static Future<List<Surah>> loadSurahs() async {
    final surahsJson = await rootBundle.loadString('assets/text/quran.json');

    final List<Surah> surahs = await compute(_parseSurahs, surahsJson);

    return surahs;
  }

  /*
  ** _parseSurahs
  ** Parses the surahs from the assets folder
  */
  static List<Surah> _parseSurahs(String jsonString) {
    final dynamic decodedJson = jsonDecode(jsonString);

    final List<Surah> surahs = [];
    for (var surahJson in decodedJson) {
      surahs.add(Surah.fromJson(surahJson));
    }

    return surahs;
  }

  /*
  ** getSurah
  ** Gets the surah by number
  */
  static Surah getSurah(int surahNumber, List<Surah> surahs) {
    return surahs.firstWhere((s) => s.number == surahNumber);
  }

  /*
  ** getSurahAyahs
  ** Gets the ayahs of a surah
  */
  static List<Ayah> getSurahAyahs(int surahNumber, List<Surah> surahs) {
    return surahs.firstWhere((s) => s.number == surahNumber).ayahs;
  }

  /*
  ** getPageAyahs
  ** Gets the ayahs of a page
  */
  static List<Ayah> getPageAyahs(int pageNumber, List<Surah> surahs) {
    final List<Ayah> allAyahs = surahs.expand((s) => s.ayahs).toList();
    final List<Ayah> pageAyahs = allAyahs
        .where((a) => a.page == pageNumber)
        .toList();
    return pageAyahs;
  }

  static List<Surah> getAllSurahsByPage(int pageNumber, List<Surah> surahs) {
    return surahs
        .where((s) => s.ayahs.any((a) => a.page == pageNumber))
        .toList();
  }

  /*
  ** getSurahByPage
  ** Gets the surah by page number
  */
  static Surah? getSurahByPage(int pageNumber, List<Surah> surahs) {
    try {
      return surahs.firstWhere((s) => s.ayahs.any((a) => a.page == pageNumber));
    } catch (e) {
      return null;
    }
  }

  /*
  ** getPageAyahsFromLibrary
  ** Gets the ayahs of a page from the QuranLibrary package
  */
  static List<Ayah> getPageAyahsFromLibrary(
    int pageNumber,
    List<Surah> surahs,
  ) {
    final quranLibPageAyahs = QuranLibrary().getPageAyahsByPageNumber(
      pageNumber: pageNumber,
    );

    return quranLibPageAyahs
        .map(
          (a) => findAyahByUniqueNumber(
            uniqueNumber: a.ayahUQNumber,
            surahs: surahs,
          ),
        )
        .toList();
  }

  /*
  ** findAyahByUniqueNumber
  ** Finds the ayah by unique number
  */
  static Ayah findAyahByUniqueNumber({
    required int uniqueNumber,
    required List<Surah> surahs,
  }) {
    return surahs
        .firstWhere((s) => s.ayahs.any((a) => a.globalNumber == uniqueNumber))
        .ayahs
        .firstWhere((a) => a.globalNumber == uniqueNumber);
  }
}
