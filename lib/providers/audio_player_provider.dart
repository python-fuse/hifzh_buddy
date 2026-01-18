import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hifzh_buddy/models/ayah.dart';
import 'package:hifzh_buddy/providers/audio_handler_provider.dart';
import 'package:hifzh_buddy/providers/current_verse_provider.dart';
import 'package:hifzh_buddy/providers/quran_audio_service_provider.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/providers/session_config_provider.dart';
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
          reciterName: ref.read(selectedReciterProvider).englishName,
          surahNumber: surah.number,
        );
      } else {
        ref
            .read(currentPlayingVerseProvider.notifier)
            .updateCurrentVerse(null, null);

        player.pause();
      }
    });
  }

  Future<AudioSource> _getAudioSource(Ayah ayah) async {
    final quranAudioService = ref.read(quranAudioServiceProvider);
    final reciter = ref.read(selectedReciterProvider);

    final audioPath = await quranAudioService.getAudioPath(
      reciter,
      ayah,
      false,
    );

    if (audioPath.startsWith("http")) {
      return AudioSource.uri(Uri.parse(audioPath));
    } else if (audioPath.startsWith("assets/")) {
      return AudioSource.asset(audioPath);
    } else {
      return AudioSource.file(audioPath);
    }
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
      final audioSources = await Future.wait(
        _pageAyahs.map((a) async {
          return await _getAudioSource(a);
        }),
      );

      player.setAudioSources(audioSources);
      state = AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> loadAudio() async {
    state = const AsyncValue.loading();
    final sessionConfig = ref.read(sessionConfigProvider);

    try {
      await player.stop();
      await player.clearAudioSources();

      ref
          .read(currentPlayingVerseProvider.notifier)
          .updateCurrentVerse(null, null);

      final startSurahNumber = sessionConfig.startSurah;
      final startVerseNumber = sessionConfig.startVerse;
      final endSurahNumber = sessionConfig.endSurah;
      final endVerseNumber = sessionConfig.endVerse;

      final surahs = ref.read(surahsProvider).value ?? [];

      final startAyah = QuranUtils.getAyah(
        startSurahNumber,
        startVerseNumber,
        surahs,
      );
      final endAyah = QuranUtils.getAyah(
        endSurahNumber,
        endVerseNumber,
        surahs,
      );

      final startAyahNumber = startAyah.globalNumber;
      final endAyahNumber = endAyah.globalNumber;

      final range = List.generate(endAyahNumber - startAyahNumber + 1, (index) {
        final ayahNumber = startAyahNumber + index;
        final ayah = QuranUtils.getAyahByGlobalNumber(ayahNumber, surahs);
        return ayah;
      });

      _pageAyahs = range;

      final audioSources = await Future.wait(
        range.map((a) async => await _getAudioSource(a)),
      );

      player.setAudioSources(audioSources);

      await player.setSpeed(sessionConfig.playbackSpeed);

      if (sessionConfig.rangeReps == -1) {
        player.setLoopMode(LoopMode.all);
      }

      state = AsyncValue.data(null);
    } catch (e, stack) {
      log("Error loading audio for session", error: e, stackTrace: stack);
      state = AsyncError(e, stack);
    }
  }

  @override
  void dispose() {
    player.dispose();

    super.dispose();
  }
}
