import 'package:flutter/material.dart';
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
            return ListTile(
              title: Text('${surah.name}. ${surah.englishName}'),
              // subtitle: Text(surah.englishNameTranslation),
              // trailing: Text('${surah.ayahs.length} Ayahs'),
            );
          },
        );
      },
    );
  }
}
