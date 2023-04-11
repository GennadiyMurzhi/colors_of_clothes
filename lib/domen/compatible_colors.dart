import 'package:colors_of_clothes/domen/color_compatibility.dart';
import 'package:colors_of_clothes/domen/enum.dart';
import 'package:flutter/painting.dart';

class CompatibleColorsList {
  CompatibleColorsList(this.list);

  final List<CompatibleColors> list;

  factory CompatibleColorsList.fromDeterminedColors(List<Color> determinedColors) =>
      CompatibleColorsList(computeCompatibleColor(determinedColors));
}

class CompatibleColors {
  CompatibleColors(
    this.color,
    this.compatible,
    this.compatibleList,
  );

  final Color color;
  final bool compatible;
  final List<CompatibleColor> compatibleList;
}

class CompatibleColor {
  CompatibleColor(this.color, this.harmony);

  final Color color;
  final Harmony harmony;
}
