import 'package:flutter/material.dart';
import 'package:hifzh_buddy/widgets/search_input.dart';
import 'package:hifzh_buddy/widgets/surah_list.dart';
import 'package:hifzh_buddy/widgets/tabb_button.dart';

class SurahsListPage extends StatelessWidget {
  SurahsListPage({super.key});

  final TextEditingController _searchController = TextEditingController();

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
            SearchInput(controller: _searchController),

            SizedBox(height: 16),

            // Render list of Surahs here
            Expanded(child: SurahList()),
          ],
        ),
      ),
    );
  }
}
