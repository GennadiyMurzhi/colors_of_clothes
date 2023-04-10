import 'package:colors_of_clothes/domen/determined_pixels.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhotoColorsWidget extends StatelessWidget {
  const PhotoColorsWidget({
    super.key,
    required this.image,
    required this.imageWidth,
    required this.imageHeight,
    required this.pixelList,
    required this.selectedPixelIndex,
    required this.selectPixel,
  });

  final Uint8List image;
  final double imageWidth;
  final double imageHeight;
  final List<DeterminedPixel> pixelList;
  final int? selectedPixelIndex;
  final void Function(int index) selectPixel;

  @override
  Widget build(BuildContext context) {
    final double changeSizesIndex =
        imageWidth / MediaQuery.of(context).size.width;

    const double indicatorSize = 30;
    const double selectedIndicatorSize = 50;
    const double colorCircleRadius = 3;

    return Stack(
      children: <Widget>[
        Image.memory(
          image,
          width: imageWidth / changeSizesIndex,
          height: imageHeight / changeSizesIndex,
        ),
        ...List<Widget>.generate(
          pixelList.length,
          (int index) {
            final bool isSelected = _isSelectedPixel(index, selectedPixelIndex);

            return Positioned(
              left: _correctPosition(
                  isSelected,
                  pixelList[index].x,
                  true,
                  changeSizesIndex,
                  indicatorSize,
                  selectedIndicatorSize,
                  colorCircleRadius),
              top: _correctPosition(
                  isSelected,
                  pixelList[index].y,
                  true,
                  changeSizesIndex,
                  indicatorSize,
                  selectedIndicatorSize,
                  colorCircleRadius),
              child: GestureDetector(
                onTap: () {
                  selectPixel(index);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: isSelected ? selectedIndicatorSize : indicatorSize,
                      height:
                          isSelected ? selectedIndicatorSize : indicatorSize,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: pixelList[index].color,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      pixelList[index].color.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: pixelList[index].color),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

double _correctPosition(
  bool isSelect,
  int coordinate,

  ///The abscissa axis Ox is the horizontal axis.
  bool isAbscissa,
  double changeSizesIndex,
  double indicatorSize,
  double selectedIndicatorSize,
  double circleBorder,
) =>
    isSelect
        ? coordinate / changeSizesIndex +
            ((isAbscissa ? -selectedIndicatorSize : selectedIndicatorSize) /
                2) -
            circleBorder / 2
        : coordinate / changeSizesIndex +
            ((isAbscissa ? -indicatorSize : indicatorSize) / 2) -
            circleBorder / 2;

bool _isSelectedPixel(int index, int? selectedPixelIndex) {
  if (selectedPixelIndex == null) {
    return false;
  } else {
    return index == selectedPixelIndex;
  }
}