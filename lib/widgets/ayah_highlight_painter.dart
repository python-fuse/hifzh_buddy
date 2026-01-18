import 'package:flutter/material.dart';
import 'package:hifzh_buddy/models/glyph_box.dart';

class AyahHighlightPainter extends CustomPainter {
  final List<GlyphBox>? glyphs;
  final double scaleFactor;
  final Color highlightColor;

  AyahHighlightPainter({
    super.repaint,
    this.glyphs,
    required this.scaleFactor,
    required this.highlightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (glyphs == null || glyphs!.isEmpty) return;

    final paint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.fill;

    // Group glyphs by lineNumber for cleaner logic
    final Map<int, List<GlyphBox>> glyphsByLine = {};
    for (final glyph in glyphs!) {
      glyphsByLine.putIfAbsent(glyph.lineNumber, () => []).add(glyph);
    }

    for (final lineGlyphs in glyphsByLine.values) {
      // First, get the bounding box in image coordinates
      final rect = _createLineBoundingBox(lineGlyphs);
      // Scale the bounding box to screen coordinates
      final scaledRect = rect.scale(scaleFactor);
      // Apply asymmetric padding: small margin on top, extra padding on bottom
      const double leftRightPadding = 2;
      const double topMargin = 3;
      const double bottomPadding = 6;
      final paddedRect = Rect.fromLTRB(
        scaledRect.left - leftRightPadding,
        scaledRect.top - topMargin,
        scaledRect.right + leftRightPadding,
        scaledRect.bottom + bottomPadding,
      );
      final rRect = RRect.fromRectAndRadius(
        paddedRect,
        const Radius.circular(6),
      );
      canvas.drawRRect(rRect, paint);
    }
  }

  Rect _createLineBoundingBox(List<GlyphBox> lineGlyphs) {
    int minX = lineGlyphs.map((g) => g.minX).reduce((a, b) => a < b ? a : b);
    int maxX = lineGlyphs.map((g) => g.maxX).reduce((a, b) => a > b ? a : b);
    int minY = lineGlyphs.map((g) => g.minY).reduce((a, b) => a < b ? a : b);
    int maxY = lineGlyphs.map((g) => g.maxY).reduce((a, b) => a > b ? a : b);

    // No padding here; padding is applied after scaling in the painter
    return Rect.fromLTRB(
      minX.toDouble(),
      minY.toDouble(),
      maxX.toDouble(),
      maxY.toDouble(),
    );
  }

  @override
  bool shouldRepaint(AyahHighlightPainter oldDelegate) {
    return oldDelegate.glyphs != glyphs ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.scaleFactor != scaleFactor;
  }
}

extension RectScaling on Rect {
  Rect scale(double factor) {
    return Rect.fromLTRB(
      left * factor,
      top * factor,
      right * factor,
      bottom * factor,
    );
  }
}
