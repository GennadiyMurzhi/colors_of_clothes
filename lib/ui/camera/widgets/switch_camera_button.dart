import 'package:colors_of_clothes/domen/ui_helpers.dart';
import 'package:flutter/material.dart';

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({
    super.key,
    required this.onTap,
    required this.isSwitchButtonRotated,
    required this.switchAnimationController,
    required this.orientationAnimationValue,
  });

  final void Function() onTap;
  final bool isSwitchButtonRotated;
  final AnimationController switchAnimationController;
  final double orientationAnimationValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: switchAnimationController,
        builder: (BuildContext context, Widget? widget) {
          return Transform.rotate(
            angle: orientationAngle(orientationAnimationValue),
            alignment: Alignment.center,
            child: Transform(
              transform: createSwitchButtonMatrix(switchAnimationController.value, 17.5),
              alignment: Alignment.center,
              child: Icon(
                isSwitchButtonRotated ? Icons.camera_front : Icons.cameraswitch_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
          );
        },
      ),
    );
  }
}
