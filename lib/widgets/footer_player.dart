import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/audio_player_provider.dart';
import 'package:hifzh_buddy/widgets/media_control_button.dart';
import 'package:hifzh_buddy/widgets/play_button.dart';
import 'package:just_audio/just_audio.dart';

class FooterPlayer extends ConsumerWidget {
  const FooterPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioNotifier = ref.watch(audioPlayerProvider.notifier);
    final player = audioNotifier.player;

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (ctx, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;

        return Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
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
            children: [
              Container(),
              Row(
                spacing: 10,
                children: [
                  MediaControlButton(
                    icon: Icons.fast_rewind,
                    handleTap: () {
                      player.seekToPrevious();
                    },
                  ),
                  PlayButton(
                    onTap: () => isPlaying ? player.pause() : player.play(),
                    isPlaying: isPlaying,
                  ),
                  MediaControlButton(
                    icon: Icons.fast_forward,
                    handleTap: () {
                      player.seekToNext();
                    },
                  ),
                ],
              ),
              Container(),
            ],
          ),
        );
      },
    );
  }
}
