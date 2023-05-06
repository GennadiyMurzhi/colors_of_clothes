import 'package:colors_of_clothes/domen/ui_utils.dart';
import 'package:flutter/material.dart';

class FlashButton extends StatelessWidget {
  const FlashButton({
    super.key,
    required this.isCameraNotSwitched,
    required this.flashButtonAnimationController,
    required this.setFlashMode,
    required this.iconList,
    required this.orientationAnimationValue,
  });

  final bool isCameraNotSwitched;
  final AnimationController flashButtonAnimationController;
  final Future<void> Function()? setFlashMode;
  final List<IconData> iconList;
  final double orientationAnimationValue;

  @override
  Widget build(BuildContext context) {
    final double flashButtonAnimationValue = flashButtonAnimationController.value;

    return InkWell(
      onTap: () async {
        if (setFlashMode != null) {
          await setFlashMode!();
        }
      },
      child: isCameraNotSwitched
          ? AnimatedBuilder(
              animation: flashButtonAnimationController,
              builder: (BuildContext context, Widget? widget) {
                return Transform.rotate(
                  angle: orientationAngle(orientationAnimationValue),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 35,
                    height: 45,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: iconList.length == 1 ? 0 : -45 + flashButtonAnimationValue * 45,
                          child: Column(
                            verticalDirection: VerticalDirection.up,
                            children: List<Widget>.generate(
                              iconList.length,
                              (int index) => Opacity(
                                opacity: index == 0 ? 1 - flashButtonAnimationValue : flashButtonAnimationValue,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Icon(
                                    iconList[index],
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const SizedBox(width: 35),
    );
  }
}
