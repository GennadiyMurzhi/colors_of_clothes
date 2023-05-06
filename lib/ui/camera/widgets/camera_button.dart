import 'dart:math';

import 'package:colors_of_clothes/domen/ui_utils.dart';
import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({
    super.key,
    required this.cameraButtonAnimationController,
    required this.orientationAnimationValue,
    required this.onTap,
  });

  final AnimationController cameraButtonAnimationController;
  final double orientationAnimationValue;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final double cameraButtonAnimationValue = cameraButtonAnimationController.value;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: cameraButtonAnimationController,
            builder: (BuildContext context, Widget? widget) {
              return Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          Transform.rotate(
            angle: pi * cameraButtonAnimationValue + orientationAngle(orientationAnimationValue),
            child: Icon(
              Icons.camera,
              color: Colors.white,
              size: 80 * (1 - cameraButtonAnimationValue),
            ),
          ),
        ],
      ),
    );
  }
}
