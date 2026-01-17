import 'package:flutter/material.dart';

class QuranPageView extends StatelessWidget {
  final int initialPage;
  final PageController? controller;
  final Function(int)? onPageChanged;
  const QuranPageView({
    super.key,
    required this.initialPage,
    this.onPageChanged,
    this.controller,
  });

  final double originalWidth = 1260;

  @override
  Widget build(BuildContext context) {
    final pageController =
        controller ?? PageController(initialPage: initialPage);

    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: 604,
      scrollDirection: Axis.horizontal,
      reverse: true,
      itemBuilder: (context, index) {
        final pageNumber = index + 1;
        final imagePath =
            'assets/pages/page${pageNumber.toString().padLeft(3, '0')}.webp';
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: originalWidth,
          child: Center(child: Image.asset(imagePath, fit: BoxFit.contain)),
        );
      },
    );
  }
}
