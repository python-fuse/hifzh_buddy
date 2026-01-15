import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/audio_player_provider.dart';
import 'package:hifzh_buddy/widgets/media_control_button.dart';
import 'package:hifzh_buddy/widgets/play_button.dart';
import 'package:just_audio/just_audio.dart';

class FooterPlayer extends ConsumerWidget {
  final VoidCallback showModal;
  const FooterPlayer({super.key, required this.showModal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioNotifier = ref.watch(audioPlayerProvider.notifier);
    final player = audioNotifier.player;

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (ctx, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;
        final isCompleted =
            playerState?.processingState == ProcessingState.completed;

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.11),
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
                      // Top: Reciter name
                      // Bottom, Session setting button to open bottomsheet,
                      buildMediaButtons(player),
                    ],
                  ),
                ],
              ),
              PlayButton(
                onTap: () => isPlaying ? player.pause() : player.play(),
                isPlaying: isPlaying && !isCompleted,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMediaButtons(AudioPlayer player) {
    return Row(
      spacing: 10,
      children: [
        MediaControlButton(icon: Icons.keyboard_arrow_up, handleTap: showModal),
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
