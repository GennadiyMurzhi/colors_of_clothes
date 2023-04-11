import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/enum.dart';
import 'package:flutter/painting.dart';

List<CompatibleColors> computeCompatibleColor(List<Color> determinedColors) {
  final List<CompatibleColors> compatibleColors = <CompatibleColors>[];
  for (Color checkColor in determinedColors) {
    final List<CompatibleColor> compatibleColorList = <CompatibleColor>[];
    for (Color targetColor in determinedColors) {
      if (checkColor != targetColor) {
        compatibleColorList.add(
          CompatibleColor(
            targetColor,
            _getColorHarmony(checkColor, targetColor),
          ),
        );
      }
    }

    compatibleColors.add(
      CompatibleColors(
        checkColor,
        _checkCompatible(compatibleColorList),
        compatibleColorList,
      ),
    );
  }

  return compatibleColors;
}

Harmony _getColorHarmony(Color color1, Color color2) {
  final double hue1 = HSVColor.fromColor(color1).hue;
  final double hue2 = HSVColor.fromColor(color2).hue;

  final double difference = (hue1 - hue2).abs();

  if (difference < 30) {
    return Harmony.analogous;
  } else if (difference < 90) {
    return Harmony.complementary;
  } else if (difference < 150) {
    return Harmony.splitComplementary;
  } else if (difference < 180) {
    return Harmony.triadic;
  } else {
    return Harmony.none;
  }
}

bool _checkCompatible(List<CompatibleColor> compatibleColorList) {
  for (CompatibleColor compatibleColor in compatibleColorList) {
    if (compatibleColor.harmony != Harmony.none) {
      return true;
    }
  }
  return false;
}
