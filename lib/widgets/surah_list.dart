import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';

class SurahList extends ConsumerWidget {
  SurahList({super.key});

  final Future<List<Surah>> surahsFuture = QuranUtils.loadSurahs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsProvider);

    return surahsAsync.when(
      data: (surahs) => ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return SurahTile(surah: surah);
        },
      ),
      error: (err, stack) => Text(err.toString()),
      loading: () => const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class SurahTile extends StatelessWidget {
  const SurahTile({super.key, required this.surah});

  final Surah surah;

  void onTap(BuildContext context) {
    context.push('/surah/${surah.number}/1');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context),
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
                  surah.number.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Row
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
                      Text(surah.englishName, style: TextStyle(fontSize: 20)),
                      Text(
                        "${surah.englishNameTranslation} ⊙ ${surah.ayahs.length} Ayahs",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  Text(
                    surah.name.split(" ").sublist(1).join(" "),
                    style: TextStyle(
                      fontSize: 22,
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
