import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/domen/ui_utils.dart';
import 'package:flutter/material.dart';

import 'determined_color_widget.dart';

class DeterminedColorsWidget extends StatelessWidget {
  const DeterminedColorsWidget({
    super.key,
    required this.compatibleDeterminedColors,
    this.selectedPixelIndex,
    required this.selectPixel,
    required this.circleSize,
    required this.isDisplayingInfo,
    required this.sideAnimationValue,
    required this.downAnimationValue,
  });

  final List<CompatibleColors> compatibleDeterminedColors;
  final int? selectedPixelIndex;
  final void Function(int indexPixel) selectPixel;
  final double circleSize;
  final bool isDisplayingInfo;
  final double sideAnimationValue;
  final double downAnimationValue;

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    final double sizeWidth = mediaSize.width;
    final double colorRowSymmetricPadding = circleSize / 2;

    final int compatibleDeterminedColorsLength = compatibleDeterminedColors.length;
    final double translateCircle = (sizeWidth - colorRowSymmetricPadding) / compatibleDeterminedColorsLength * 2;

    final bool isOddCountColors = compatibleDeterminedColorsLength % 2 == 0;
    final int inHalfCount = compatibleDeterminedColorsLength ~/ 2;

    return Stack(
      alignment: Alignment.center,
      children: List.generate(
        compatibleDeterminedColorsLength,
        (int index) {
          final bool isSelected = isSelectedPixel(index, selectedPixelIndex);

          final int animationIndex = isOddCountColors
              ? index < inHalfCount
                  ? inHalfCount - index
                  : index - inHalfCount + 1
              : index < inHalfCount
                  ? inHalfCount - index
                  : index ~/ 2;

          final double? animateTranslateCircle;
          final bool? isInHalfCount;
          if (!isOddCountColors) {
            isInHalfCount = index == inHalfCount;
          } else {
            isInHalfCount = null;
          }

          if (isOddCountColors && (index == inHalfCount - 1 || index == inHalfCount)) {
            animateTranslateCircle = translateCircle / 2 * sideAnimationValue * animationIndex;
          } else if (isOddCountColors) {
            animateTranslateCircle = (translateCircle * animationIndex - translateCircle / 2) * sideAnimationValue;
          } else if ((!isOddCountColors && !isInHalfCount!)) {
            animateTranslateCircle = translateCircle * sideAnimationValue * animationIndex;
          } else {
            animateTranslateCircle = null;
          }

          return Positioned(
            top: downAnimationValue,
            child: Padding(
              padding: isOddCountColors
                  ? index < inHalfCount
                      ? EdgeInsets.only(right: animateTranslateCircle!)
                      : EdgeInsets.only(left: animateTranslateCircle!)
                  : isInHalfCount!
                      ? EdgeInsets.zero
                      : index < inHalfCount
                          ? EdgeInsets.only(right: animateTranslateCircle!)
                          : EdgeInsets.only(left: animateTranslateCircle!),
              child: DeterminedColorWidget(
                selectPixel: () => selectPixel(index),
                colorContainerSize: circleSize,
                color: compatibleDeterminedColors[index].color,
                isSelected: isSelected,
                compatible: compatibleDeterminedColors[index].compatible,
                isDisplayingInfo: isDisplayingInfo,
              ),
            ),
          );
        },
      ),
    );
  }
}
