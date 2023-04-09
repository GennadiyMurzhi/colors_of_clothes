import 'package:colors_of_clothes/domen/determined_pixels.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhotoPreviewWidget extends StatefulWidget {
  const PhotoPreviewWidget({
    super.key,
    required this.image,
    required this.determinedPixels,
  });

  final Uint8List image;
  final DeterminedPixels determinedPixels;

  @override
  PhotoPreviewState createState() => PhotoPreviewState();
}

class PhotoPreviewState extends State<PhotoPreviewWidget> {
  List<bool> selectedPixel = <bool>[];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= widget.determinedPixels.pixelList.length - 1; i++) {
      selectedPixel.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double changeSizesIndex =
        widget.determinedPixels.imageWidth / MediaQuery.of(context).size.width;

    final List<DeterminedPixel> pixelList = widget.determinedPixels.pixelList;

    const double indicatorSize = 30;
    const double selectedIndicatorSize = 50;
    const double colorCircleRadius = 3;

    return Stack(
      children: <Widget>[
        Image.memory(
          widget.image,
          width: widget.determinedPixels.imageWidth / changeSizesIndex,
          height: widget.determinedPixels.imageHeight / changeSizesIndex,
        ),
        ...List<Widget>.generate(
          pixelList.length,
          (int index) => Positioned(
            left: _correctPosition(
                selectedPixel[index],
                pixelList[index].x,
                true,
                changeSizesIndex,
                indicatorSize,
                selectedIndicatorSize,
                colorCircleRadius),
            top: _correctPosition(
                selectedPixel[index],
                pixelList[index].y,
                true,
                changeSizesIndex,
                indicatorSize,
                selectedIndicatorSize,
                colorCircleRadius),
            child: GestureDetector(
              onTap: () {
                for (int i = 0; i <= selectedPixel.length - 1; i++) {
                  setState(() {
                    if (i == index) {
                      selectedPixel[i] = true;
                    } else {
                      selectedPixel[i] = false;
                    }
                  });
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: selectedPixel[index]
                        ? selectedIndicatorSize
                        : indicatorSize,
                    height: selectedPixel[index]
                        ? selectedIndicatorSize
                        : indicatorSize,
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
          ),
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
