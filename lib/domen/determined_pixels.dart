import 'package:colors_of_clothes/domen/value_transformers.dart';
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

  List<Color> get determinedColors => determinedPixelToColors(this);
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
