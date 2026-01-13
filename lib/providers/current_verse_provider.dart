import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hifzh_buddy/models/ayah.dart';
import 'package:hifzh_buddy/models/current_verse.dart';

class CurrentPlayingVerseNotifier extends StateNotifier<CurrentPlayingVerse> {
  final Ref ref;
  CurrentPlayingVerseNotifier(this.ref)
    : super(const CurrentPlayingVerse.stopped());

  void updateCurrentVerse(Ayah? ayah, int? index) {
    state = CurrentPlayingVerse(ayah, index);
  }
}

final currentPlayingVerseProvider =
    StateNotifierProvider<CurrentPlayingVerseNotifier, CurrentPlayingVerse>(
      (ref) => CurrentPlayingVerseNotifier(ref),
    );
