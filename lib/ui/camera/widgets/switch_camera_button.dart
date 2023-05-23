import 'package:colors_of_clothes/domen/ui_utils.dart';
import 'package:colors_of_clothes/ui/colors_of_clothes_custom_icons_icons.dart';
import 'package:flutter/material.dart';

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({
    super.key,
    required this.onTap,
    required this.isSwitchButtonRotated,
    required this.switchAnimationController,
    required this.orientationAnimationValue,
  });

  final void Function()? onTap;
  final bool isSwitchButtonRotated;
  final AnimationController switchAnimationController;
  final double orientationAnimationValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: orientationAngle(orientationAnimationValue),
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: switchAnimationController,
          builder: (BuildContext context, Widget? widget) {
            return switchAnimationController.value == 0
                ? Icon(
                    isSwitchButtonRotated
                        ? ColorsOfClothesCustomIcons.camera_front_switch
                        : ColorsOfClothesCustomIcons.camera_switch,
                    color: Colors.white,
                    size: 35,
                  )
                : Transform(
                    transform: createSwitchButtonMatrix(switchAnimationController.value, 17.5),
                    alignment: Alignment.center,
                    child: Icon(
                      switchAnimationController.value <= 0.5
                          ? isSwitchButtonRotated
                              ? ColorsOfClothesCustomIcons.camera_front_switch
                              : ColorsOfClothesCustomIcons.camera_switch
                          : !isSwitchButtonRotated
                              ? ColorsOfClothesCustomIcons.camera_front_switch
                              : ColorsOfClothesCustomIcons.camera_switch,
                      color: Colors.white,
                      size: 35,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
