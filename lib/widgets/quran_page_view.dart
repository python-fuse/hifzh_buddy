import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/models/glyph_box.dart';
import 'package:hifzh_buddy/providers/current_verse_provider.dart';
import 'package:hifzh_buddy/widgets/ayah_highlight_painter.dart';

class QuranPageView extends ConsumerStatefulWidget {
  final int initialPage;
  final PageController? controller;
  final Function(int)? onPageChanged;
  final List<GlyphBox>? Function(int pageNumber)? getHighlightedGlyphsForPage;

  const QuranPageView({
    super.key,
    required this.initialPage,
    this.onPageChanged,
    this.controller,
    this.getHighlightedGlyphsForPage,
  });

  @override
  ConsumerState<QuranPageView> createState() => _QuranPageViewState();
}

class _QuranPageViewState extends ConsumerState<QuranPageView> {
  final double originalWidth = 1260;
  late final PageController pageController;
  int? _lastAnimatedPage;

  @override
  void initState() {
    super.initState();
    pageController =
        widget.controller ?? PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentPlayingVerseProvider, (previous, next) {
      final ayah = next.ayah;
      if (ayah == null) return;
      final targetPage = ayah.page - 1;

      if (_lastAnimatedPage != targetPage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          pageController.animateToPage(
            targetPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        });
        _lastAnimatedPage = targetPage;
      }
    });

    return PageView.builder(
      controller: pageController,
      onPageChanged: widget.onPageChanged,
      itemCount: 604,
      scrollDirection: Axis.horizontal,
      reverse: true,
      itemBuilder: (context, index) {
        final pageNumber = index + 1;
        final imagePath =
            'assets/pages/page${pageNumber.toString().padLeft(3, '0')}.webp';
        final highlightedVerseGlyphs = widget.getHighlightedGlyphsForPage?.call(
          pageNumber,
        );

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: [
              Center(child: Image.asset(imagePath, fit: BoxFit.contain)),
              if (highlightedVerseGlyphs != null &&
                  highlightedVerseGlyphs.isNotEmpty)
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Use both width and height for scaling
                      const double originalWidth = 1260;
                      const double originalHeight = 2038;
                      double scaleX = constraints.maxWidth / originalWidth;
                      double scaleY = constraints.maxHeight / originalHeight;

                      return CustomPaint(
                        painter: AyahHighlightPainter(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          highlightColor: Theme.of(
                            context,
                          ).primaryColor.withAlpha(0x22),
                          glyphs: highlightedVerseGlyphs,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
