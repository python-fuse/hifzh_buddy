import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/audio_player_provider.dart';
import 'package:qcf_quran/qcf_quran.dart';

import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';
import 'package:hifzh_buddy/widgets/footer_player.dart';

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
      final pageData = getPageData(page);
      final newSurah = QuranUtils.getSurah(pageData.first['surah'], surahs);

      setState(() {
        _currentTitle = newSurah.englishName;
      });

      ref.read(audioPlayerProvider.notifier).loadPage(page);
    }

    return Scaffold(
      appBar: AppBar(title: Text(_currentTitle!), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: PageviewQuran(
              onLongPress: (surahNumber, verseNumber) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Surah Number: $surahNumber, Verse Number: $verseNumber",
                    ),
                  ),
                );
              },

              sp: 1.sp,
              h: 1.h,

              onPageChanged: onPageChanged,
              controller: PageController(initialPage: widget.page - 1),
              pageBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          FooterPlayer(),
        ],
      ),
    );
  }
}
