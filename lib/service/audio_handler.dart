import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioHandler extends BaseAudioHandler {
  final AudioPlayer audioPlayer;

  QuranAudioHandler(this.audioPlayer) {
    audioPlayer.playbackEventStream.listen(_broadcaseState);
    audioPlayer.playerStateStream.listen((playerState) {});
  }

  void updateNowPlaying({
    required String surahName,
    required int ayahNumber,
    required int pageNumber,
  }) {
    final mediaItem = MediaItem(
      id: '$surahName:$ayahNumber',
      title: "$surahName - $pageNumber ",
      album: surahName,
      artist: "Muhammad Siddiq Al-Minshawy",
    );

    this.mediaItem.add(mediaItem);
  }

  void _broadcaseState(PlaybackEvent event) {
    final playing = audioPlayer.playing;

    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[event.processingState]!,
        playing: playing,
        speed: audioPlayer.speed,
      ),
    );
  }

  @override
  Future<void> play() {
    return audioPlayer.play();
  }

  @override
  Future<void> pause() {
    return audioPlayer.pause();
  }

  @override
  Future<void> skipToNext() {
    return audioPlayer.seekToNext();
  }

  @override
  Future<void> skipToPrevious() {
    return audioPlayer.seekToPrevious();
  }
}
