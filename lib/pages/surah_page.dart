import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/providers/current_verse_provider.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/providers/session_config_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';
import 'package:hifzh_buddy/widgets/bottom_settings.dart';
import 'package:hifzh_buddy/widgets/footer_player.dart';
import 'package:hifzh_buddy/widgets/quran_page_view.dart';

class SurahPage extends ConsumerStatefulWidget {
  final int surahNumber;
  final int page;

  const SurahPage({super.key, required this.surahNumber, required this.page});

  @override
  ConsumerState<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends ConsumerState<SurahPage> {
  String? _currentTitle;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.page - 1);
    // Future.microtask(() {
    //   ref.read(audioPlayerProvider.notifier).loadPage(widget.page);
    // });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Surah> surahs = ref.watch(surahsProvider).value!;
    _currentTitle ??= QuranUtils.getSurah(
      widget.surahNumber,
      surahs,
    ).englishName;

    void onPageChanged(int page) {
      final pageData = QuranUtils.getAllSurahsByPage(page + 1, surahs);

      setState(() {
        _currentTitle = pageData.last.englishName;
      });

      // ref.read(audioPlayerProvider.notifier).loadPage(page);
    }

    // handleHighlightVerse(surahNumber, verseNumber) {
    //   final currentVerse = ref.watch(currentPlayingVerseProvider).ayah;
    //   if (currentVerse != null) {
    //     if (currentVerse.surahNumber == surahNumber &&
    //         currentVerse.numberInSurah == verseNumber) {
    //       return Theme.of(context).primaryColor.withAlpha(0x33);
    //     }
    //   }
    //   return null;
    // }

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

      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: QuranPageView(
                initialPage: widget.page,
                onPageChanged: onPageChanged,
                controller: _pageController,
              ),
            ),

            FooterPlayer(
              showModal: () => _showSessionSettingsBottomSheet(context),
            ),
          ],
        ),
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
        return BottomSettings(onApply: () => onApply(context));
      },
    );
  }

  void onApply(BuildContext context) {
    log("called on apply");
    final startAyah = QuranUtils.getAyah(
      ref.read(sessionConfigProvider).startSurah,
      ref.read(sessionConfigProvider).startVerse,
      ref.read(surahsProvider).value!,
    );

    context.pop();

    _pageController.jumpToPage(startAyah.page - 1);
  }
}
