import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioHandler extends BaseAudioHandler {
  final AudioPlayer audioPlayer;

  QuranAudioHandler(this.audioPlayer);

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
