class Ayah {
  final String globalNumber;
  final String text;
  final String numberInSurah;
  final String audioPath;
  final String page;
  final String juz;
  final String manzil;
  final String ruku;
  final String hizbQuarter;
  final String sajda;

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
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      globalNumber: json['number'],
      audioPath: json['audio'],
      page: json['page'],
      juz: json['juz'],
      manzil: json['manzil'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'],
      numberInSurah: json['numberInSurah'],
      text: json['text'],
    );
  }
}
