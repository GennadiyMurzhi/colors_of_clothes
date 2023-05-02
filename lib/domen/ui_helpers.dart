import 'dart:math';

import 'package:flutter/material.dart';

bool isSelectedPixel(int index, int? selectedPixelIndex) {
  if (selectedPixelIndex == null) {
    return false;
  } else {
    return index == selectedPixelIndex;
  }
}

Matrix4 createSwitchButtonMatrix(double animationValue, double translate) {
  final Matrix4 matrix;
  if (animationValue < 0.5) {
    matrix = Matrix4.rotationY(3.14 * animationValue);
  } else {
    matrix = Matrix4.rotationY(3.14 * (1 - animationValue));
  }

  return matrix;
}

Matrix4 createSwitchPreviewMatrix(double animationValue) {
  final double tilt = ((animationValue - 0.5).abs() - 0.5) * 0.003;

  final Matrix4 matrix = Matrix4.rotationY(3.14 * (1 - animationValue))..setEntry(3, 0, tilt / 2);

  return matrix;
}

Matrix4 createSwitchRotationMatrix(double animationValue) {
  final Matrix4 matrix;
  if (animationValue < 0.5) {
    matrix = Matrix4.rotationY(3.14);
  } else {
    matrix = Matrix4.identity();
  }

  return matrix;
}

double orientationAngle(double animationValue) => -pi / 2 + pi * animationValue;

Duration calculateScrollTime({
  required double distance,
  required double velocity,
}) {
  print('distance: $distance');
  print('velocity: $velocity');
  final int milliseconds;
  final double time = distance / velocity;
  if (!time.isInfinite && !time.isNaN){
    final int seconds = time.truncate();
    milliseconds = (seconds * 1000 + ((time - seconds) * 1000).truncate()).abs();
    print('seconds: $seconds');
  } else {
    milliseconds = 500;
  }

  print('milliseconds: $milliseconds');
  return Duration(
    milliseconds: milliseconds > 500 ? milliseconds : 500,
  );
}
