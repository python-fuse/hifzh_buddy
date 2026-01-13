import 'package:hifzh_buddy/models/ayah.dart';

class Surah {
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int number;
  final List<Ayah> ayahs;

  Surah({
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
    required this.number,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    final ayahsJson = json['ayahs'] as List<dynamic>;
    final surahNumber = json['number'];

    for (var ayahJson in ayahsJson) {
      ayahJson['surahNumber'] = surahNumber;
    }

    return Surah(
      name: json['name'],
      number: json['number'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      ayahs: ayahsJson
          .map((ayahJson) => Ayah.fromJson(ayahJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
