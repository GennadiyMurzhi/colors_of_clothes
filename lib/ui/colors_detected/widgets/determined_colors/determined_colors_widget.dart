import 'package:colors_of_clothes/domen/compatible_colors.dart';
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
    required this.sideAnimationFirstValue,
    required this.sideAnimationSecondValue,
    required this.circleBorderWidth,
    required this.determinedColorsWidgetHeight,
    required this.horizontalSymmetricPadding,
  });

  final List<CompatibleColors> compatibleDeterminedColors;
  final int? selectedPixelIndex;
  final void Function(int indexPixel) selectPixel;
  final double circleSize;
  final bool isDisplayingInfo;
  final double sideAnimationFirstValue;
  final double sideAnimationSecondValue;
  final double circleBorderWidth;
  final double determinedColorsWidgetHeight;
  final double horizontalSymmetricPadding;

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    final double sizeWidth = mediaSize.width - horizontalSymmetricPadding * 2;

    final int compatibleDeterminedColorsLength = compatibleDeterminedColors.length;

    const double padding = 10;

    final double circlesCountsWidth = circleSize * compatibleDeterminedColorsLength;
    final double innerPaddingCount = padding * (compatibleDeterminedColorsLength - 1);

    final double fullCirclesWidth = circlesCountsWidth + innerPaddingCount + horizontalSymmetricPadding * 2;

    final double translateCircle =
        circleSize + (sizeWidth - circlesCountsWidth) / (compatibleDeterminedColorsLength - 1);

    final bool isBiggerCirclesCountsWidth = circlesCountsWidth >= sizeWidth;

    return SizedBox(
      width: mediaSize.width,
      height: determinedColorsWidgetHeight * 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: isBiggerCirclesCountsWidth ? fullCirclesWidth : mediaSize.width,
          height: determinedColorsWidgetHeight,
          child: Stack(
            alignment: Alignment.topCenter,
            children: List.generate(
              compatibleDeterminedColorsLength,
              (int index) {
                final bool isSelected = isSelectedPixel(index, selectedPixelIndex);

                final double positionLeft = (sizeWidth - circleSize) / 2 * (1 - sideAnimationFirstValue) +
                    (index != 0
                        ? (index * translateCircle + horizontalSymmetricPadding) * sideAnimationFirstValue
                        : horizontalSymmetricPadding) +
                    (isBiggerCirclesCountsWidth && index != 0
                        ? sideAnimationSecondValue *
                            ((circlesCountsWidth - sizeWidth) / (compatibleDeterminedColorsLength - 1) + padding) *
                            index
                        : 0);

                return Positioned(
                  top: circleBorderWidth,
                  left: positionLeft,
                  child: DeterminedColorWidget(
                    selectPixel: () => selectPixel(index),
                    colorContainerSize: circleSize,
                    color: compatibleDeterminedColors[index].color,
                    isSelected: isSelected,
                    compatible: compatibleDeterminedColors[index].compatible,
                    isDisplayingInfo: isDisplayingInfo,
                    circleBorderWidth: circleBorderWidth,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
