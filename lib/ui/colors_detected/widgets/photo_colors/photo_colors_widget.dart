import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/photo_colors/color_mark_widget.dart';
import 'package:colors_of_clothes/domen/ui_utils.dart';

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
    required this.opacity,
  });

  final Uint8List image;
  final double imageWidth;
  final double imageHeight;
  final List<DeterminedPixel> pixelList;
  final int? selectedPixelIndex;
  final void Function(int index) selectPixel;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final double changeSizesIndex = imageWidth / MediaQuery.of(context).size.width;

    const double markSize = 30;
    const double selectedMarkSize = 35;
    const double circleBorder = 3;

    return Opacity(
      opacity: opacity,
      child: Stack(
        children: <Widget>[
          Image.memory(
            image,
            width: imageWidth / changeSizesIndex,
            height: imageHeight / changeSizesIndex,
          ),
          ...List<Widget>.generate(
            pixelList.length,
            (int index) {
              final bool isSelected = isSelectedPixel(index, selectedPixelIndex);

              return ColorMarkWidget(
                isSelected: isSelected,
                determinedPixel: pixelList[index],
                changeSizesIndex: changeSizesIndex,
                markSize: markSize,
                selectedMarkSize: selectedMarkSize,
                circleBorder: circleBorder,
                pixelIndex: index,
                selectPixel: selectPixel,
              );
            },
          ),
        ],
      ),
    );
  }
}
