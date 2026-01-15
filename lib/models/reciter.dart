class Reciter {
  final String id;
  final String name;
  final String englishName;

  const Reciter({
    required this.id,
    required this.name,
    required this.englishName,
  });

  bool get isBundled => id == 'local.minshawy';

  String getRemoteUrl(int ayahNumber) {
    return 'https://cdn.islamic.network/quran/audio/64/ar.husary/$ayahNumber.mp3';
  }

  String getBundledAudioPath(String audioFilename) {
    return "assets/quranAudio/$audioFilename";
  }

  String getCachedAudiopath(int ayahNumber) {
    // pormat: quran_audio/ar.husary/232.mp3
    return 'quran_audio/$id/$ayahNumber.mp3';
  }

  static const minshawi = Reciter(
    id: "local.minshawi",
    name: "محمد صديق المنشاوي",
    englishName: "Muhammad Siddiq Al-Minshawy",
  );
}

enum AudioSourceType { bundled, cached, streaming }
