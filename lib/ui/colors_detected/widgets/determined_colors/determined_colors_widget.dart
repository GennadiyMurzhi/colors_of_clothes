import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/ui_utils.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/determined_colors/determined_color_widget.dart';
import 'package:flutter/material.dart';

class DeterminedColorsWidget extends StatelessWidget {
  const DeterminedColorsWidget({
    super.key,
    required this.colorRowSymmetricPadding,
    required this.colorContainerSize,
    required this.compatibleDeterminedColors,
    this.selectedPixelIndex,
    required this.selectPixel,
  });

  final double colorRowSymmetricPadding;
  final double colorContainerSize;
  final List<CompatibleColors> compatibleDeterminedColors;
  final int? selectedPixelIndex;
  final void Function(int indexPixel) selectPixel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: colorRowSymmetricPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          compatibleDeterminedColors.length,
          (int index) {
            final bool isSelected = isSelectedPixel(index, selectedPixelIndex);

            return DeterminedColorWidget(
              selectPixel: () => selectPixel(index),
              colorContainerSize: colorContainerSize,
              color: compatibleDeterminedColors[index].color,
              isSelected: isSelected,
              compatible: compatibleDeterminedColors[index].compatible,
            );
          },
        ),
      ),
    );
  }
}
