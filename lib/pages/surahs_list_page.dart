import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';
import 'package:hifzh_buddy/widgets/pages_list.dart';
import 'package:hifzh_buddy/widgets/search_input.dart';
import 'package:hifzh_buddy/widgets/surah_list.dart';
import 'package:hifzh_buddy/widgets/tabb_button.dart';

class SurahsListPage extends StatelessWidget {
  const SurahsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Surahs'),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
        scrolledUnderElevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(width: double.infinity, child: TabbButton()),
            SizedBox(height: 16),
            SearchInput(),

            SizedBox(height: 16),

            // Render list of Surahs here
            Consumer(
              builder: (context, ref, child) {
                final activeTab = ref.watch(activeTabProvider);

                log('ac $activeTab');

                if (activeTab.contains('surah')) {
                  return Expanded(child: SurahList());
                } else {
                  return Expanded(child: PagesList());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
