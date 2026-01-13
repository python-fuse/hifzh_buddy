class Ayah {
  final int globalNumber;
  final String text;
  final int numberInSurah;
  final String audioPath;
  final int page;
  final int juz;
  final int manzil;
  final int ruku;
  final int hizbQuarter;
  final dynamic sajda;
  final int surahNumber;

  Ayah({
    required this.globalNumber,
    required this.text,
    required this.numberInSurah,
    required this.audioPath,
    required this.page,
    required this.juz,
    required this.manzil,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
    required this.surahNumber,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    // sajda can be bool or Map
    // "sajda": {
    //       "id": 1,
    //       "recommended": true,
    //       "obligatory": false
    //   }

    final sajdaData = json['sajda'];

    sajdaData is Map<String, dynamic>? ? sajdaData : false;

    return Ayah(
      globalNumber: json['number'],
      audioPath: json['audio'],
      page: json['page'],
      juz: json['juz'],
      manzil: json['manzil'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: sajdaData,
      numberInSurah: json['numberInSurah'],
      text: json['text'],
      surahNumber: json['surahNumber'],
    );
  }
}
