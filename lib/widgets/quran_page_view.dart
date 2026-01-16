import 'package:flutter/material.dart';

class QuranPageView extends StatelessWidget {
  final int page;
  const QuranPageView({super.key, required this.page});

  final double originalWidth = 1260;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // double scale = constraints.maxWidth / originalWidth;

            return PageView.builder(
              itemCount: 604,
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemBuilder: (context, index) {
                return Image.asset(
                  "assets/pages/page${(index + page).toString().padLeft(3, '0')}.png",
                  fit: BoxFit.contain,
                  width: constraints.maxWidth,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
