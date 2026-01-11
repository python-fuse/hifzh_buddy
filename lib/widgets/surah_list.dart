import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';

class SurahList extends StatelessWidget {
  SurahList({super.key});

  final Future<List<Surah>> surahsFuture = QuranUtils.loadSurahs();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Surah>>(
      future: surahsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final surahs = snapshot.data ?? [];

        return ListView.builder(
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            final surah = surahs[index];
            return SurahTile(surah: surah);
          },
        );
      },
    );
  }
}

class SurahTile extends StatelessWidget {
  const SurahTile({super.key, required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                    style: GoogleFonts.scheherazadeNew(fontSize: 20),
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
