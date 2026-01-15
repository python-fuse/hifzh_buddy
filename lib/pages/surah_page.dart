import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/audio_player_provider.dart';

import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/providers/current_verse_provider.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';
import 'package:hifzh_buddy/widgets/footer_player.dart';
import 'package:quran_library/quran_library.dart';

// import getx

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
        pageNumber: page + 1,
      );

      setState(() {
        _currentTitle = pageData.first.englishName;
      });

      ref.read(audioPlayerProvider.notifier).loadPage(page + 1);
    }

    void setHighlights() {
      final currentVerse = ref.watch(currentPlayingVerseProvider).ayah;
      Map<int, List<int>> toBeHighlighted = {};
      if (currentVerse != null) {
        toBeHighlighted = {
          currentVerse.surahNumber: [currentVerse.numberInSurah],
        };
      }

      final combined = List<int>.empty(growable: true);
      toBeHighlighted.forEach((surah, ayahs) {
        for (final n in ayahs) {
          final id = QuranCtrl.instance.getAyahUQBySurahAndAyah(surah, n);
          if (id != null) combined.add(id);
        }
      });

      QuranCtrl.instance.setExternalHighlights(combined);
    }

    setHighlights();

    return Scaffold(
      appBar: AppBar(title: Text(_currentTitle!), centerTitle: true),
      body: Stack(
        children: [
          Positioned.fill(
            child: QuranPagesScreen(
              parentContext: context,
              ayahSelectedBackgroundColor: Theme.of(
                context,
              ).primaryColor.withAlpha(0x33),
              startPage: widget.page,
              useDefaultAppBar: false,
              endPage: 604,
              onPageChanged: onPageChanged,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onAyahLongPress: (details, ayah) {},
              onSurahBannerPress: (surahNameModel) {},
              onPagePress: () {},
              secondMenuChildOnTap: (ayah) {},
              anotherMenuChildOnTap: (ayah) {},
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: FooterPlayer(),
          ),
        ],
      ),
    );
  }
}
