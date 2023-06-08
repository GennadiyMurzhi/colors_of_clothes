import 'dart:typed_data';

import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/compatible_colors/compatible_colors_widget.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/determined_colors/determined_colors_widget.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/loading_circles/loading_circles_widget.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/photo_colors/photo_colors_widget.dart';
import 'package:flutter/material.dart';

class ColorsDetectedBody extends StatelessWidget {
  const ColorsDetectedBody({
    super.key,
    required this.isColorDetermination,
    required this.loadingAnimationController,
    required this.image,
    required this.pixels,
    required this.compatibleDeterminedColors,
    required this.selectedPixelIndex,
    required this.selectPixel,
    required this.circleSize,
    required this.afterDeterminedAnimationController,
  });

  final bool isColorDetermination;
  final AnimationController loadingAnimationController;
  final AnimationController afterDeterminedAnimationController;
  final Uint8List? image;
  final DeterminedPixels? pixels;
  final CompatibleColorsList? compatibleDeterminedColors;
  final int? selectedPixelIndex;
  final void Function(int indexPixel) selectPixel;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;

    final Animation<double> opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: afterDeterminedAnimationController,
        curve: const Interval(
          0.6,
          1,
          curve: Curves.ease,
        ),
      ),
    );

    final Animation<double> sideAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: afterDeterminedAnimationController,
        curve: const Interval(
          0.7,
          1,
          curve: Curves.ease,
        ),
      ),
    );

    final Animation<double> downAnimation = Tween<double>(
      begin: mediaSize.height / 2 - circleSize / 2,
      end: mediaSize.height - circleSize,
    ).animate(
      CurvedAnimation(
        parent: afterDeterminedAnimationController,
        curve: const Interval(
          0,
          0.6,
          curve: Curves.ease,
        ),
      ),
    );

    return SafeArea(
      top: false,
      child: Center(
        child: isColorDetermination
            ? LoadingCirclesWidget(
                loadingAnimationController: loadingAnimationController,
                circleSize: circleSize,
              )
            : Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: afterDeterminedAnimationController,
                    builder: (BuildContext context, Widget? widget) {
                      return Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          PhotoColorsWidget(
                            image: image!,
                            imageWidth: pixels!.imageWidth,
                            imageHeight: pixels!.imageHeight,
                            pixelList: pixels!.pixelList,
                            selectedPixelIndex: selectedPixelIndex,
                            selectPixel: selectPixel,
                            opacity: opacityAnimation.value,
                          ),
                          if (compatibleDeterminedColors!.list.isNotEmpty)
                            DeterminedColorsWidget(
                              circleSize: circleSize,
                              compatibleDeterminedColors: compatibleDeterminedColors!.list,
                              selectedPixelIndex: selectedPixelIndex,
                              selectPixel: selectPixel,
                              isDisplayingInfo: false,
                              sideAnimationValue: sideAnimation.value,
                              downAnimationValue: downAnimation.value,
                            ),
                        ],
                      );
                    }
                  ),

                  /*Text(
                  compatibleDeterminedColors!.list.isNotEmpty ? 'Determined Colors' : 'Wrong Image',
                  style: Theme.of(context).textTheme.titleLarge,
                ),*/

                  if (compatibleDeterminedColors!.list.isNotEmpty)
                    CompatibleColorsWidget(
                      compatibleColors:
                          selectedPixelIndex != null ? compatibleDeterminedColors!.list[selectedPixelIndex!] : null,
                    )
                  else
                    Text(
                      'There is no person in the photo',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                ],
              ),
      ),
    );
  }
}
