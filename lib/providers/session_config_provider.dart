import 'package:flutter_riverpod/legacy.dart';
import 'package:hifzh_buddy/models/reciter.dart';
import 'package:hifzh_buddy/models/session_config.dart';
import 'package:hifzh_buddy/providers/quran_audio_service_provider.dart';

class SessionConfigNotifier extends StateNotifier<SessionConfig> {
  final Reciter reciter;
  SessionConfigNotifier(this.reciter)
    : super(
        SessionConfig(
          startSurah: 1,
          startVerse: 1,
          endSurah: 114,
          endVerse: 6,
          playbackSpeed: 1.0,
          verseReps: 1,
          rangeReps: 1,
          reciter: reciter,
        ),
      );

  void updateStartSurah(int surahNumber) {
    state = state.copyWith(startSurah: surahNumber, startVerse: 1);
  }

  void updateStartVerse(int verseNumber) {
    state = state.copyWith(startVerse: verseNumber);
  }

  void updateEndSurah(int surahNumber, int maxVerses) {
    state = state.copyWith(endSurah: surahNumber, endVerse: maxVerses);
  }

  void updateEndVerse(int verseNumber) {
    state = state.copyWith(endVerse: verseNumber);
  }

  void updatePlaybackSpeed(double speed) {
    state = state.copyWith(playbackSpeed: speed);
  }

  void updateVerseReps(int reps) {
    state = state.copyWith(verseReps: reps);
  }

  void updateRangeReps(int reps) {
    state = state.copyWith(rangeReps: reps);
  }
}

final sessionConfigProvider =
    StateNotifierProvider<SessionConfigNotifier, SessionConfig>(
      (ref) => SessionConfigNotifier(ref.watch(selectedReciterProvider)),
    );
