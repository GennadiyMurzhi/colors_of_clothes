import 'package:flutter/painting.dart';

class DeterminedPixels {
  DeterminedPixels(
    this.imageWidth,
    this.imageHeight,
    this.pixelList,
  );

  final double imageWidth;
  final double imageHeight;
  final List<DeterminedPixel> pixelList;
}

class DeterminedPixel {
  DeterminedPixel(
      this.x,
      this.y,
      this.color,
      );

  final int x;
  final int y;
  final Color color;
}
