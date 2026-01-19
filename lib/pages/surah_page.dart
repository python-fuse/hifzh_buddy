import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/models/glyph_box.dart';

import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/providers/current_verse_provider.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/providers/session_config_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';
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
    super.initState();

    // Sync session config to the opened surah on first load
    Future.microtask(() {
      final configNotifier = ref.read(sessionConfigProvider.notifier);
      final surahs = ref.read(surahsProvider).value;
      int maxAyah = 1;
      if (surahs != null) {
        final surah = surahs.firstWhere((s) => s.number == widget.surahNumber);
        maxAyah = surah.ayahs.length;
      }
      configNotifier.updateStartSurah(widget.surahNumber);
      configNotifier.updateStartVerse(1);
      configNotifier.updateEndSurah(widget.surahNumber, maxAyah);
      configNotifier.updateEndVerse(maxAyah);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Surah> surahs = ref.watch(surahsProvider).value!;
    final currentVerse = ref.watch(currentPlayingVerseProvider);
    final coordinates = ref.watch(coordinatesProvider).value!;
    int currentSurahNumber = widget.surahNumber;

    _currentTitle ??= QuranUtils.getSurah(
      widget.surahNumber,
      surahs,
    ).englishName;

    // Build a map of pageNumber -> glyphs for the current verse, using surah and ayah from the currentPlayingVerse
    Map<int, List<GlyphBox>>? highlightedGlyphsByPage;
    if (currentVerse.ayah != null) {
      final verseKey =
          '${currentVerse.ayah!.surahNumber}_${currentVerse.ayah!.numberInSurah}';
      highlightedGlyphsByPage = {};
      coordinates.forEach((pageNum, verseMap) {
        if (verseMap.containsKey(verseKey)) {
          highlightedGlyphsByPage![pageNum] = verseMap[verseKey]!;
        }
      });
    }

    void onPageChanged(int page) {
      final pageData = QuranUtils.getAllSurahsByPage(page + 1, surahs);

      setState(() {
        _currentTitle = pageData.last.englishName;
        currentSurahNumber = page + 1;
        log("c -> $currentSurahNumber");
      });

      // ref.read(audioPlayerProvider.notifier).loadPage(page);
    }

    return Scaffold(
      body: SafeArea(
        bottom: true,
        top: true,
        child: Column(
          children: [
            Expanded(
              child: QuranPageView(
                initialPage: widget.page,
                onPageChanged: onPageChanged,
                controller: _pageController,
                // Pass a function to get highlights for a specific page
                getHighlightedGlyphsForPage: (int pageNumber) {
                  if (highlightedGlyphsByPage != null &&
                      highlightedGlyphsByPage.containsKey(pageNumber)) {
                    return highlightedGlyphsByPage[pageNumber];
                  }
                  return null;
                },
              ),
            ),

            FooterPlayer(currentSurah: currentSurahNumber),
          ],
        ),
      ),
    );
  }
}
