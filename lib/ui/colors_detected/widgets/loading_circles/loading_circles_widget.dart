import 'dart:math';

import 'package:colors_of_clothes/ui/colors_detected/widgets/loading_circles/cirle_widget.dart';
import 'package:colors_of_clothes/ui/theme.dart';
import 'package:flutter/cupertino.dart';

class LoadingCirclesWidget extends StatelessWidget {
  LoadingCirclesWidget({
    super.key,
    required this.loadingAnimationController,
    required this.circleSize,
    required this.downAnimationValue,
  });

  final AnimationController loadingAnimationController;
  final double circleSize;
  final double downAnimationValue;

  final List<Color> _colors = <Color>[
    darkColorScheme.primary,
    darkColorScheme.secondary,
    darkColorScheme.tertiary,
    darkColorScheme.inversePrimary,
  ];

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    final double screenWidth = mediaSize.width;
    final double distanceTranslate = screenWidth / 3;

    final Animation<Offset> translateAnimation = TweenSequence<Offset>(
      <TweenSequenceItem<Offset>>[
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: const Offset(0, 0),
            end: Offset(0, distanceTranslate),
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: Offset(0, distanceTranslate),
            end: const Offset(0, 0),
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 50,
        ),
      ],
    ).animate(loadingAnimationController);

    return Positioned(
      top: downAnimationValue,
      child: AnimatedBuilder(
        animation: loadingAnimationController,
        builder: (BuildContext context, Widget? widget) {
          return Transform.rotate(
            angle: ((3 / 4) * (2 * pi)) * loadingAnimationController.value + pi * 0.35,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(
                4,
                (index) => CircleWidget(
                  circleSize: circleSize,
                  color: _colors[index],
                  offset: translateAnimation.value,
                  rotateIndex: index,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
