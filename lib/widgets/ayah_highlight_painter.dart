import 'package:flutter/material.dart';
import 'package:hifzh_buddy/models/glyph_box.dart';

class AyahHighlightPainter extends CustomPainter {
  final List<GlyphBox>? glyphs;
  final double scaleX;
  final double scaleY;
  final Color highlightColor;

  AyahHighlightPainter({
    super.repaint,
    this.glyphs,
    required this.scaleX,
    required this.scaleY,
    required this.highlightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (glyphs == null || glyphs!.isEmpty) return;

    final paint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.fill;

    // Group glyphs by lineNumber
    final Map<int, List<GlyphBox>> glyphsByLine = {};
    for (final glyph in glyphs!) {
      glyphsByLine.putIfAbsent(glyph.lineNumber, () => []).add(glyph);
    }

    for (final lineGlyphs in glyphsByLine.values) {
      // Get the bounding box in image coordinates
      final rect = _createLineBoundingBox(lineGlyphs);
      // Scale the bounding box to screen coordinates using scaleX and scaleY
      final scaledRect = Rect.fromLTRB(
        rect.left * scaleX,
        rect.top * scaleY,
        rect.right * scaleX,
        rect.bottom * scaleY,
      );

      const double leftRightPadding = 2;
      const double bottomPadding = 4;
      final paddedRect = Rect.fromLTRB(
        scaledRect.left - leftRightPadding,
        scaledRect.top,
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
        oldDelegate.scaleX != scaleX ||
        oldDelegate.scaleY != scaleY;
  }
}
