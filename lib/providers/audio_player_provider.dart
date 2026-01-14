import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hifzh_buddy/models/ayah.dart';
import 'package:hifzh_buddy/providers/audio_handler_provider.dart';
import 'package:hifzh_buddy/providers/current_verse_provider.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';
import 'package:just_audio/just_audio.dart';

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AsyncValue<void>>((ref) {
      final handler = ref.watch(audioHandlerProvider);
      return AudioPlayerNotifier(ref, handler.audioPlayer);
    });

class AudioPlayerNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final AudioPlayer player;

  List<Ayah> _pageAyahs = [];

  AudioPlayerNotifier(this.ref, this.player)
    : super(const AsyncValue.data(null)) {
    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        ref
            .read(currentPlayingVerseProvider.notifier)
            .updateCurrentVerse(null, null);
      }
    });

    player.currentIndexStream.listen((index) {
      if (index != null && index < _pageAyahs.length) {
        // Update current playing verse for highlights
        ref
            .read(currentPlayingVerseProvider.notifier)
            .updateCurrentVerse(_pageAyahs[index], index);

        // update the notification center
        final surah = QuranUtils.getSurah(
          _pageAyahs[index].surahNumber,
          ref.read(surahsProvider).value ?? [],
        );
        final ayahNumber = _pageAyahs[index].numberInSurah;
        final pageNumber = _pageAyahs[index].page;

        final handler = ref.read(audioHandlerProvider);
        handler.updateNowPlaying(
          surahName: surah.englishName,
          ayahNumber: ayahNumber,
          pageNumber: pageNumber,
        );
      } else {
        ref
            .read(currentPlayingVerseProvider.notifier)
            .updateCurrentVerse(null, null);

        player.pause();
      }
    });
  }

  Future<void> loadPage(int pageNumber) async {
    state = const AsyncValue.loading();

    final surahs = ref.read(surahsProvider).value ?? [];

    player.clearAudioSources();
    player.pause();

    ref
        .read(currentPlayingVerseProvider.notifier)
        .updateCurrentVerse(null, null);

    _pageAyahs = QuranUtils.getPageAyahs(pageNumber, surahs);

    try {
      player.addAudioSources(
        _pageAyahs
            .map((a) => AudioSource.asset("assets/quranAudio/${a.audioPath}"))
            .toList(),
      );

      state = AsyncValue.data(null);

      // data loaded
      log(_pageAyahs.map((a) => a.audioPath).join(", "));
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
