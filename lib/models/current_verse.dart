import 'package:hifzh_buddy/models/ayah.dart';

class CurrentPlayingVerse {
  final Ayah? ayah;
  final int? index;

  const CurrentPlayingVerse(this.ayah, this.index);

  const CurrentPlayingVerse.stopped() : ayah = null, index = null;
}
