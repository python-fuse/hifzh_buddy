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
                        return ListTile(
                          title: Text(reciter.englishName),
                          leading: Icon(Icons.multitrack_audio),
                          subtitle: LinearProgressIndicator(
                            value: null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }

                      final files = asyncSnapshot.data ?? [];
                      final progress = files.length / 6236;

                      return ListTile(
                        title: Text(reciter.englishName),
                        leading: Icon(Icons.multitrack_audio),
                        subtitle: LinearProgressIndicator(
                          value: progress,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 0,
                        ),

                        onTap: () {
                          context.push("/downloads/${reciter.id}");
                        },
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
