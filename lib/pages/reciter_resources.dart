import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/models/reciter.dart';
import 'package:hifzh_buddy/models/surah.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/service/quran_audio_download_service.dart';
import 'package:hifzh_buddy/uitls/quran_utils.dart';
import 'package:hifzh_buddy/widgets/my_appbar.dart';

class ReciterResourcesPage extends ConsumerWidget {
  final Reciter reciter;
  final QuranDownloadService quranDownloadService = QuranDownloadService();

  ReciterResourcesPage({super.key, required this.reciter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahs = ref.read(surahsProvider).value!;

    return Scaffold(
      appBar: MyAppBar(title: reciter.englishName),
      body: FutureBuilder(
        future: quranDownloadService.getReciterFiles(reciter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final List<File> downloadedAyahs = [];

              for (final file in data) {
                final globalNumber = quranDownloadService
                    .getAyahNumberFromFilePath(file);

                final ayah = QuranUtils.getAyahByGlobalNumber(
                  globalNumber,
                  surahs,
                );

                if (ayah.surahNumber == surahs[index].number) {
                  downloadedAyahs.add(file);
                }
              }

              return SurahDownloadItem(
                surah: surahs[index],
                downloaded: downloadedAyahs,
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: 114,
          );
        },
      ),
    );
  }
}

class SurahDownloadItem extends StatefulWidget {
  final Surah surah;
  final List<File> downloaded;
  const SurahDownloadItem({
    super.key,
    required this.surah,
    required this.downloaded,
  });

  @override
  State<SurahDownloadItem> createState() => _SurahDownloadItemState();
}

class _SurahDownloadItemState extends State<SurahDownloadItem> {
  @override
  Widget build(BuildContext context) {
    int diskUsage = 0;

    for (final file in widget.downloaded) {
      diskUsage += file.lengthSync();
    }

    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.surah.englishName),
                Text("${(diskUsage / 1000 / 1000).toStringAsFixed(1)} MB"),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(8),
              value: widget.downloaded.length / widget.surah.ayahs.length,
            ),
          ],
        ),
      ),
    );
  }
}
