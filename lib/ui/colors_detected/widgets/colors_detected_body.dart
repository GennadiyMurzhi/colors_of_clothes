import 'dart:typed_data';

import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/loading_circles/loading_circles_widget.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/photo_colors/photo_colors_widget.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/sliding_up_colors_widget.dart';
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
    required this.correctSlidingUpColorsWidget,
    required this.isSlidingUpColorsWidgetExpanded,
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
  final double correctSlidingUpColorsWidget;
  final bool isSlidingUpColorsWidgetExpanded;

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    const double circleBorderWidth = 5;
    const double slidingUpColorsWidgetTopPadding = 30;
    const double slidingUpColorsWidgetOpenIconSize = 20;
    final double determinedColorsWidgetHeight = circleSize + circleBorderWidth * 2;
    final double determinedColorsWidgetPosition = mediaSize.height - determinedColorsWidgetHeight;
    final double position = mediaSize.height -
        determinedColorsWidgetHeight -
        slidingUpColorsWidgetTopPadding -
        slidingUpColorsWidgetOpenIconSize;

    final double slidingUpColorsWidgetHeight = mediaSize.height - correctSlidingUpColorsWidget;
    final double offsetTransition = -(slidingUpColorsWidgetHeight - determinedColorsWidgetHeight -
        slidingUpColorsWidgetTopPadding -
        slidingUpColorsWidgetOpenIconSize) /
        (mediaSize.height - MediaQuery.of(context).padding.top);
    print('offsetTransition: $offsetTransition');
    print('correctSlidingUpColorsWidget: $correctSlidingUpColorsWidget');

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

    final Animation<double> sideAnimationFirst = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: afterDeterminedAnimationController,
        curve: const Interval(
          0.7,
          0.8,
          curve: Curves.ease,
        ),
      ),
    );
    final Animation<double> sideAnimationSecond = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: afterDeterminedAnimationController,
        curve: const Interval(
          0.8,
          1,
          curve: Curves.linear,
        ),
      ),
    );

    final Animation<double> downAnimation = Tween<double>(
      begin: mediaSize.height / 2 - circleSize / 2,
      end: determinedColorsWidgetPosition,
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
        child: AnimatedBuilder(
          animation: afterDeterminedAnimationController,
          builder: (BuildContext context, Widget? widget) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                isColorDetermination
                    ? LoadingCirclesWidget(
                        loadingAnimationController: loadingAnimationController,
                        circleSize: circleSize,
                        downAnimationValue: downAnimation.value,
                      )
                    : Stack(
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
                          Positioned(
                            top: position,
                            child: SlidingUpColorsWidget(
                              isExpanded: isSlidingUpColorsWidgetExpanded,
                              offsetTransition: offsetTransition,
                              width: mediaSize.width,
                              height: slidingUpColorsWidgetHeight,
                              determinedColorsWidgetHeight: determinedColorsWidgetHeight,
                              circleSize: circleSize,
                              compatibleDeterminedColors: compatibleDeterminedColors!,
                              selectedPixelIndex: selectedPixelIndex,
                              selectPixel: selectPixel,
                              isDisplayingInfo: false,
                              sideAnimationFirstValue: sideAnimationFirst.value,
                              sideAnimationSecondValue: sideAnimationSecond.value,
                              position: position,
                              circleBorderWidth: circleBorderWidth,
                              slidingUpColorsWidgetTopPadding: slidingUpColorsWidgetTopPadding,
                              slidingUpColorsWidgetOpenIconSize: slidingUpColorsWidgetOpenIconSize,
                            ),
                          ),
                        ],
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
