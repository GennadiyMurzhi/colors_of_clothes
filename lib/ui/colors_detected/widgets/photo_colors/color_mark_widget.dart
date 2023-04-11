import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:flutter/material.dart';

class ColorMarkWidget extends StatelessWidget {
  const ColorMarkWidget({
    super.key,
    required this.isSelected,
    required this.determinedPixel,
    required this.changeSizesIndex,
    required this.markSize,
    required this.selectedMarkSize,
    required this.circleBorder,
    required this.pixelIndex,
    required this.selectPixel,
  });

  final bool isSelected;
  final DeterminedPixel determinedPixel;
  final double changeSizesIndex;
  final double markSize;
  final double selectedMarkSize;
  final double circleBorder;
  final int pixelIndex;
  final void Function(int index) selectPixel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _correctPosition(
          isSelected, determinedPixel.x, changeSizesIndex, markSize, selectedMarkSize, circleBorder),
      top: _correctPosition(
          isSelected, determinedPixel.y, changeSizesIndex, markSize, selectedMarkSize, circleBorder),
      child: GestureDetector(
        onTap: () {
          selectPixel(pixelIndex);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: isSelected ? selectedMarkSize : markSize,
              height: isSelected ? selectedMarkSize : markSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: determinedPixel.color,
                    width: isSelected ? 3.5 : 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double _correctPosition(
  bool isSelected,
  int coordinate,
  double changeSizesIndex,
  double markSize,
  double selectedMarkSize,
  double circleBorder,
) =>
    isSelected
        ? coordinate / changeSizesIndex + (-selectedMarkSize / 2) - circleBorder / 2
        : coordinate / changeSizesIndex + (-markSize / 2) - circleBorder / 2;
