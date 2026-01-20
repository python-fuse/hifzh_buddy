import 'dart:developer';
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
        initialData: <File>[],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 40,
              width: 40,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final data = snapshot.data ?? [];

          return ListView.separated(
            key: ValueKey(data),
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              return SurahDownloadItem(
                surah: surahs[index],
                reciter: reciter,
                downloadsData: data,
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

class SurahDownloadItem extends ConsumerStatefulWidget {
  final Surah surah;
  // final List<File> downloaded;
  final Reciter reciter;

  final List<File> downloadsData;

  SurahDownloadItem({
    super.key,
    required this.surah,
    required this.downloadsData,
    required this.reciter,
  });

  final QuranDownloadService quranDownloadService = QuranDownloadService();

  @override
  ConsumerState<SurahDownloadItem> createState() => _SurahDownloadItemState();
}

class _SurahDownloadItemState extends ConsumerState<SurahDownloadItem> {
  final List<File> downloadedAyahs = [];
  @override
  Widget build(BuildContext context) {
    final surahs = ref.read(surahsProvider).value!;

    for (final file in widget.downloadsData) {
      final globalNumber = widget.quranDownloadService
          .getAyahNumberFromFilePath(file);

      final ayah = QuranUtils.getAyahByGlobalNumber(globalNumber, surahs);

      if (ayah.surahNumber == widget.surah.number) {
        downloadedAyahs.add(file);
      }
    }

    Future<void> onTap() async {
      // Get undownloaded verse
      final undownloadedAyahs = widget.surah.ayahs
          .where(
            (ayah) => !downloadedAyahs.any(
              (file) =>
                  widget.quranDownloadService.getAyahNumberFromFilePath(file) ==
                  ayah.globalNumber,
            ),
          )
          .toList();
      // loop through and download
      for (final ayah in undownloadedAyahs) {
        try {
          await QuranDownloadService().downloadVerse(
            ayah: ayah,
            reciter: widget.reciter,
          );

          final file = await widget.quranDownloadService.getFileFromAyahNumber(
            widget.reciter,
            ayah,
          );
          setState(() {
            downloadedAyahs.add(file);
          });
        } catch (e) {
          log("Failed to download ${ayah.globalNumber}", error: e);
        }
      }
    }

    Future<void> onLongPress() async {
      final surahFiles = [];
      for (final file in widget.downloadsData) {
        final globalNumber = widget.quranDownloadService
            .getAyahNumberFromFilePath(file);

        final ayah = QuranUtils.getAyahByGlobalNumber(globalNumber, surahs);

        if (ayah.surahNumber == widget.surah.number) {
          surahFiles.add(file);
        }
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Surah"),
            content: const Text("Are you sure you want to delete this surah?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  for (final file in surahFiles) {
                    file.deleteSync();
                  }
                  setState(() {
                    downloadedAyahs.clear();
                  });
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    }

    int diskUsage = 0;

    if (downloadedAyahs.isNotEmpty) {
      for (final file in downloadedAyahs) {
        diskUsage += file.lengthSync();
      }
    }

    double progress = widget.surah.ayahs.isEmpty
        ? 0
        : downloadedAyahs.length / widget.surah.ayahs.length;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            // 1. Leading Number Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  widget.surah.number.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 2. Main Content Area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Size Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.surah.englishName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${(diskUsage / (1024 * 1024)).toStringAsFixed(1)} MB",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Progress Bar
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 4),

                  // Download Count Text
                  Text(
                    "${downloadedAyahs.length} / ${widget.surah.ayahs.length} verses downloaded",
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
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
