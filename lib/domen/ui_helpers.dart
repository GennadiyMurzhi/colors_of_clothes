import 'package:flutter/material.dart';

bool isSelectedPixel(int index, int? selectedPixelIndex) {
  if (selectedPixelIndex == null) {
    return false;
  } else {
    return index == selectedPixelIndex;
  }
}

Matrix4 createSwitchButtonMatrix(double animationIndex, double translate) => Matrix4.rotationY(3.14 * animationIndex);

Matrix4 createSwitchPreviewMatrix(double animationIndex) {
  final double tilt = ((animationIndex - 0.5).abs() - 0.5) * 0.003;

  final Matrix4 matrix = Matrix4.rotationY(3.14 * (1 - animationIndex))..setEntry(3, 0, tilt / 2);

  return matrix;
}

Matrix4 createSwitchCaptureMatrix(double animationIndex) {
  final Matrix4 matrix;
  if (animationIndex < 0.5) {
    matrix = Matrix4.rotationY(3.14);
  } else {
    matrix = Matrix4.identity();
  }

  return matrix;
}
