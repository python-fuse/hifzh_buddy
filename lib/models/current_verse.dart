import 'package:hifzh_buddy/models/ayah.dart';

class CurrentPlayingVerse {
  final Ayah? ayah;
  final int? index;

  const CurrentPlayingVerse(this.ayah, this.index);

  const CurrentPlayingVerse.stopped() : ayah = null, index = null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentPlayingVerse &&
          runtimeType == other.runtimeType &&
          ayah == other.ayah &&
          index == other.index;

  @override
  int get hashCode => ayah.hashCode ^ index.hashCode;
}
