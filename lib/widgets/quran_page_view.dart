import 'package:flutter/material.dart';

class QuranPageView extends StatefulWidget {
  const QuranPageView({super.key});

  @override
  State<QuranPageView> createState() => _QuranPageViewState();
}

class _QuranPageViewState extends State<QuranPageView> {
  final double originalWidth = 1260;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double scale = constraints.maxWidth / originalWidth;

            return Image.asset(
              "assets/pages/page001.png",
              fit: BoxFit.contain,
              width: constraints.maxWidth,
            );
          },
        ),
      ),
    );
  }
}
