import 'package:flutter/widgets.dart';

class GlyphBox {
  final int position;
  final int minX;
  final int minY;
  final int maxX;
  final int maxY;

  GlyphBox({
    required this.position,
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });

  // Parsing from my restructured json [pos,minx,maxx,miny,maxy]
  factory GlyphBox.fromList(List<dynamic> list) {
    return GlyphBox(
      position: list[0] as int,
      minX: list[1] as int,
      minY: list[2] as int,
      maxX: list[3] as int,
      maxY: list[4] as int,
    );
  }

  // Convert to rect with scaling
  Rect toRect(double scaleFactor) {
    return Rect.fromLTRB(
      minX * scaleFactor,
      minY * scaleFactor,
      maxX * scaleFactor,
      maxY * scaleFactor,
    );
  }

  // cheek if a given point exisit withing this glyph
  bool containsPoint(double x, double y) {
    return x >= minX && x <= maxX && y >= minY && y <= maxY;
  }
}
