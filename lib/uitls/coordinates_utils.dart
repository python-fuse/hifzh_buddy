import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hifzh_buddy/models/glyph_box.dart';

class CoordinatesUtils {
  static Future<Map<int, Map<String, List<GlyphBox>>>> loadCoordinates() async {
    final jsonString = await rootBundle.loadString(
      'assets/text/ayah_coords.json',
    );

    final coords = await compute(_parseCoords, jsonString);

    return coords;
  }

  static Map<int, Map<String, List<GlyphBox>>> _parseCoords(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final result = <int, Map<String, List<GlyphBox>>>{};

    for (final pageEntry in jsonMap.entries) {
      final pageNumber = int.parse(pageEntry.key);
      final verseMap = <String, List<GlyphBox>>{};

      for (final verseEntry
          in (pageEntry.value as Map<String, dynamic>).entries) {
        final verseKey = verseEntry.key;
        final glyphsData = verseEntry.value as List<dynamic>;

        final glyphs = glyphsData
            .map((g) => GlyphBox.fromList(g as List<dynamic>))
            .toList();

        verseMap[verseKey] = glyphs;
      }
      result[pageNumber] = verseMap;
    }
    return result;
  }

  static List<GlyphBox>? getVerseGlyphs({
    required int page,
    required int surah,
    required int ayah,
    required Map<int, Map<String, List<GlyphBox>>> coords,
  }) {
    final verseKey = '${surah}_$ayah';
    return coords[page]?[verseKey];
  }
}
