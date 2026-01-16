import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';

class PagesList extends ConsumerStatefulWidget {
  const PagesList({super.key});

  @override
  ConsumerState<PagesList> createState() => _PagesState();
}

class _PagesState extends ConsumerState<PagesList> {
  @override
  Widget build(BuildContext context) {
    final surahs = ref.read(surahsProvider).value!;

    return ListView.builder(
      itemCount: 604,
      itemBuilder: (context, index) {
        return PageTile(page: index + 1, surahs: surahs);
      },
    );
  }
}

class PageTile extends StatelessWidget {
  final int page;
  final List<Surah> surahs;
  const PageTile({super.key, required this.page, required this.surahs});

  void onTap(BuildContext context, int surahNumber, int page) {
    context.push('/surah/$surahNumber/$page');
  }

  @override
  Widget build(BuildContext context) {
    final surahsInPage = QuranUtils.getAllSurahsByPage(page, surahs);

    return InkWell(
      onTap: () => onTap(context, surahsInPage.first.number, page),
      enableFeedback: true,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              width: 50,
              height: 50,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  page.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${surahsInPage.first.englishNameTranslation} ${surahsInPage.last.englishNameTranslation == surahsInPage.first.englishNameTranslation ? "" : "- ${surahsInPage.last.englishNameTranslation}"}",
                        style: TextStyle(fontSize: 10),
                      ),

                      // from first surah first verse to last surah last verse
                      Text(
                        "${surahsInPage.first.ayahs.firstWhere((a) => a.page == page).numberInSurah} - ${surahsInPage.last.ayahs.lastWhere((a) => a.page == page).numberInSurah}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),

                  Text(
                    "${surahsInPage.first.name.split(" ").sublist(1).join("").replaceAll("\u0633\u064f\u0648\u0631\u064e\u0629\u064f", "")} ${surahsInPage.last.name == surahsInPage.first.name ? "" : "- ${surahsInPage.last.name.replaceAll("\u0633\u064f\u0648\u0631\u064e\u0629\u064f", "")}"}",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "UthmanicHafs",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
