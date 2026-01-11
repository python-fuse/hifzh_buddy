import 'package:flutter/material.dart';

class SurahPage extends StatefulWidget {
  final int surahNumber;
  final int page;

  const SurahPage({super.key, required this.surahNumber, required this.page});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Surah ${widget.surahNumber} - Page ${widget.page}"),
      ),
    );
  }
}
