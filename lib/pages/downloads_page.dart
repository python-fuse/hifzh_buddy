import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hifzh_buddy/service/quran_audio_download_service.dart';
import 'package:hifzh_buddy/uitls/constants.dart';
import 'package:hifzh_buddy/widgets/my_appbar.dart';

class DownloadManagerPage extends StatelessWidget {
  DownloadManagerPage({super.key});
  final QuranDownloadService quranDownloadService = QuranDownloadService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "All Reciters"),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final reciter = reciters[index];
                  final reciterTotalDownloaded = quranDownloadService
                      .getReciterFiles(reciter);

                  return FutureBuilder(
                    future: reciterTotalDownloaded,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      final files = asyncSnapshot.data ?? [];
                      final progress = files.length / 6236;

                      return InkWell(
                        onTap: () => context.push('/downloads/${reciter.id}'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              // 1. Leading Number Icon
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          reciter.englishName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: reciters.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
