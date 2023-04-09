import 'package:colors_of_clothes/domen/enum.dart';
import 'package:flutter/painting.dart';

class CompatibleColors {
  CompatibleColors(
    this.color,
    this.compatible,
    this.compatibleColors,
  );

  final Color color;
  final bool compatible;
  final Map<Color, Harmony> compatibleColors;
}
