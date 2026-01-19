import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/audio_player_provider.dart';
import 'package:hifzh_buddy/providers/current_verse_provider.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/providers/session_config_provider.dart';
import 'package:hifzh_buddy/widgets/media_control_button.dart';
import 'package:hifzh_buddy/widgets/play_button.dart';
import 'package:hifzh_buddy/widgets/bottom_settings.dart';
import 'package:just_audio/just_audio.dart';

class FooterPlayer extends ConsumerWidget {
  final int currentSurah;
  const FooterPlayer({super.key, required this.currentSurah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioNotifier = ref.watch(audioPlayerProvider.notifier);
    final player = audioNotifier.player;
    final currentVerse = ref.watch(currentPlayingVerseProvider);
    final surahsAsync = ref.watch(surahsProvider);

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (ctx, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;
        final isCompleted =
            playerState?.processingState == ProcessingState.completed;

        return Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(28),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildMediaButtons(player, context, ref, surahsAsync),
                    ],
                  ),
                ],
              ),
              PlayButton(
                onTap: () async {
                  // If no audio loaded or completed, open settings sheet with correct range
                  final hasAudio = player.sequence.isNotEmpty;
                  if (!hasAudio || isCompleted) {
                    // Wait for surahs to load
                    final surahs = surahsAsync.value;
                    if (surahs == null) return;

                    int startSurah = 1;
                    int startAyah = 1;
                    int endSurah = 1;
                    int endAyah = 1;

                    // Prefer current playing verse, else fallback to first ayah on current page
                    if (currentVerse.ayah != null) {
                      startSurah = currentVerse.ayah!.surahNumber;
                      startAyah = currentVerse.ayah!.numberInSurah;
                    } else {
                      // Fallback: use currentSurah from SurahPage
                      startSurah = currentSurah;
                      startAyah = 1;
                    }

                    // End: last ayah of the selected surah
                    final surah = surahs.firstWhere(
                      (s) => s.number == startSurah,
                    );
                    endSurah = surah.number;
                    endAyah = surah.ayahs.last.numberInSurah;

                    // Always update session config to match these values
                    final configNotifier = ref.read(
                      sessionConfigProvider.notifier,
                    );
                    configNotifier.updateStartSurah(startSurah);
                    configNotifier.updateStartVerse(startAyah);
                    configNotifier.updateEndSurah(endSurah, endAyah);
                    configNotifier.updateEndVerse(endAyah);

                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(ctx).viewInsets.bottom,
                          ),
                          child: BottomSettings(
                            initialStartSurah: startSurah,
                            initialStartVerse: startAyah,
                            initialEndSurah: endSurah,
                            initialEndVerse: endAyah,
                            onApply: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    isPlaying ? player.pause() : player.play();
                  }
                },
                isPlaying: isPlaying && !isCompleted,
                isLoading: player.processingState == ProcessingState.loading,
                isReplay: isCompleted,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMediaButtons(
    AudioPlayer player,
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<dynamic>> surahsAsync,
  ) {
    return Row(
      children: [
        MediaControlButton(
          icon: Icons.settings,
          handleTap: () async {
            // Open settings sheet with current config and sync config to currentSurah
            final surahs = surahsAsync.value;
            if (surahs == null) return;
            final configNotifier = ref.read(sessionConfigProvider.notifier);

            // Always update session config to match currentSurah
            final surah = surahs.firstWhere((s) => s.number == currentSurah);
            final maxAyah = surah.ayahs.last.numberInSurah;
            configNotifier.updateStartSurah(currentSurah);
            configNotifier.updateStartVerse(1);
            configNotifier.updateEndSurah(currentSurah, maxAyah);
            configNotifier.updateEndVerse(maxAyah);

            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  ),
                  child: BottomSettings(
                    initialStartSurah: currentSurah,
                    initialStartVerse: 1,
                    initialEndSurah: currentSurah,
                    initialEndVerse: maxAyah,
                    onApply: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                );
              },
            );
          },
        ),
        MediaControlButton(
          icon: Icons.fast_rewind,
          handleTap: () {
            player.seekToPrevious();
          },
        ),
        MediaControlButton(
          icon: Icons.fast_forward,
          handleTap: () {
            player.seekToNext();
          },
        ),
        InkWell(
          onTap: () => changeSpeed(player),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${player.speed.toStringAsFixed(2)}x",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        MediaControlButton(
          icon: Icons.stop,
          handleTap: () {
            player.stop();
            player.clearAudioSources();
          },
        ),
      ],
    );
  }

  void changeSpeed(AudioPlayer player) {
    // increase the speed by 0.25 till its 1.75 then reset to 0.5
    if (player.speed < 1.75) {
      player.setSpeed(player.speed + 0.25);
    } else {
      player.setSpeed(0.5);
    }
  }
}
