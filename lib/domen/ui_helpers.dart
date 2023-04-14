

import 'package:flutter/material.dart';

bool isSelectedPixel(int index, int? selectedPixelIndex) {
  if (selectedPixelIndex == null) {
    return false;
  } else {
    return index == selectedPixelIndex;
  }
}

Matrix4 createSwitchButtonMatrix(double animationIndex, double translate) => Matrix4.identity()
  ..setEntry(0, 0, 1 - 1 * animationIndex)
  ..setEntry(0, 3, translate * animationIndex);

Matrix4 createSwitchPreviewMatrix(double animationIndex, double translate) => Matrix4.identity()
  ..setEntry(0, 0, 1 - 1.1 * animationIndex)
  ..setEntry(0, 3, translate * animationIndex)

  ..setEntry(3, 0, -0.0005 * animationIndex)

  ..rotateX(3.14/12 * animationIndex)
  ..rotateY(3.14/12 * animationIndex)
 ;
