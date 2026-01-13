import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';
import 'package:just_audio/just_audio.dart';

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AsyncValue<void>>((ref) {
      return AudioPlayerNotifier(ref);
    });

class AudioPlayerNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final AudioPlayer player = AudioPlayer();

  AudioPlayerNotifier(this.ref) : super(const AsyncValue.data(null)) {
    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {}
    });
  }

  Future<void> loadPage(int pageNumber) async {
    state = const AsyncValue.loading();

    final surahs = ref.read(surahsProvider).value ?? [];

    player.clearAudioSources();
    player.pause();

    final pageAyahs = QuranUtils.getPageAyahs(pageNumber, surahs);

    try {
      player.addAudioSources(
        pageAyahs
            .map((a) => AudioSource.asset("assets/quranAudio/${a.audioPath}"))
            .toList(),
      );

      state = AsyncValue.data(null);

      // data loaded
      log(pageAyahs.map((a) => a.audioPath).join(", "));
      log(player.sequence.map((s) => s.tag).toString());
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
