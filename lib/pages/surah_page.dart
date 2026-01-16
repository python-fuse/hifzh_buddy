import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/audio_player_provider.dart';

import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/providers/current_verse_provider.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';
import 'package:hifzh_buddy/widgets/bottom_settings.dart';
import 'package:hifzh_buddy/widgets/footer_player.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:quran_library/quran_library.dart';

class SurahPage extends ConsumerStatefulWidget {
  final int surahNumber;
  final int page;

  const SurahPage({super.key, required this.surahNumber, required this.page});

  @override
  ConsumerState<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends ConsumerState<SurahPage> {
  String? _currentTitle;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(audioPlayerProvider.notifier).loadPage(widget.page);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Surah> surahs = ref.watch(surahsProvider).value!;
    _currentTitle ??= QuranUtils.getSurah(
      widget.surahNumber,
      surahs,
    ).englishName;

    void onPageChanged(int page) {
      final pageData = QuranLibrary().getAllSurahInPageByPageNumber(
        pageNumber: page,
      );

      setState(() {
        _currentTitle = pageData.first.englishName;
      });

      ref.read(audioPlayerProvider.notifier).loadPage(page);
    }

    handleHighlightVerse(surahNumber, verseNumber) {
      final currentVerse = ref.watch(currentPlayingVerseProvider).ayah;
      if (currentVerse != null) {
        if (currentVerse.surahNumber == surahNumber &&
            currentVerse.numberInSurah == verseNumber) {
          return Theme.of(context).primaryColor.withAlpha(0x33);
        }
      }
      return null;
    }

    // void setHighlights() {
    //   final currentVerse = ref.watch(currentPlayingVerseProvider).ayah;
    //   Map<int, List<int>> toBeHighlighted = {};
    //   if (currentVerse != null) {
    //     toBeHighlighted = {
    //       currentVerse.surahNumber: [currentVerse.numberInSurah],
    //     };
    //   }

    //   final combined = List<int>.empty(growable: true);
    //   toBeHighlighted.forEach((surah, ayahs) {
    //     for (final n in ayahs) {
    //       final id = QuranCtrl.instance.getAyahUQBySurahAndAyah(surah, n);
    //       if (id != null) combined.add(id);
    //     }
    //   });

    //   QuranCtrl.instance.setExternalHighlights(combined);
    // }

    // setHighlights();

    return Scaffold(
      appBar: AppBar(title: Text(_currentTitle!), centerTitle: true),
      body: Stack(
        children: [
          Positioned.fill(
            child: Consumer(
              builder: (context, ref, child) => PageviewQuran(
                initialPageNumber: widget.page,
                pageBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                verseBackgroundColor: handleHighlightVerse,
                onPageChanged: onPageChanged,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: FooterPlayer(
              showModal: () => _showSessionSettingsBottomSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showSessionSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      showDragHandle: true,
      elevation: 1,
      useSafeArea: true,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.bounceInOut,
        duration: const Duration(milliseconds: 400),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),

      builder: (BuildContext context) {
        return BottomSettings();
      },
    );
  }
}
