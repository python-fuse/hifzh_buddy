import 'package:hifzh_buddy/models/ayah.dart';
import 'package:hifzh_buddy/models/surah.dart';

class Player {
  final Surah surah;
  List<Ayah> ayahs = [];
  String? currentlyPlayingSurah;
  int? currentlyPlayingAyah;
  bool isPlaying = false;
  double progress = 0;
  double speed = 1;
  double volume = 1;
  double duration = 0;

  Player({required this.surah}) {
    ayahs = surah.ayahs;
  }

  void togglePlayPause() {
    isPlaying = !isPlaying;
  }
}
