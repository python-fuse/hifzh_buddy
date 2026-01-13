import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/models/ayah.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';
import 'package:just_audio/just_audio.dart';

class FooterPlayer extends ConsumerStatefulWidget {
  final int currentPage;
  const FooterPlayer({super.key, required this.currentPage});

  @override
  ConsumerState<FooterPlayer> createState() => _FooterPlayerState();
}

class _FooterPlayerState extends ConsumerState<FooterPlayer> {
  final player = AudioPlayer();
  bool isPlaying = false;

  List<String> audioUrls = [];

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void loadPageAudios() async {
    audioUrls.clear();

    final surahs = ref.read(surahsProvider).value!;
    final pageAyahs = QuranUtils.getPageAyahs(widget.currentPage, surahs);

    if (pageAyahs.isNotEmpty) {
      for (Ayah ayah in pageAyahs) {
        audioUrls.add(ayah.audioPath);
      }
    }

    try {
      await player.setAudioSources(
        audioUrls
            .map((url) => AudioSource.asset("assets/quranAudio/$url"))
            .toList(),
      );
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadPageAudios();
  }

  void handlePlayPage() async {
    if (isPlaying) {
      player.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      player.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          InkWell(
            onTap: handlePlayPage,
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: isPlaying
                  ? Icon(Icons.pause, color: Colors.white, size: 40)
                  : Icon(Icons.play_arrow, color: Colors.white, size: 40),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
