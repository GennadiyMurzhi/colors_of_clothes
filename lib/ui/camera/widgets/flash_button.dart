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
    const double stackHeight = 90;
    const double iconSize = 35;

    return GestureDetector(
      onTap: () async {
        if (setFlashMode != null) {
          await setFlashMode!();
        }
      },
      child: isCameraNotSwitched
          ? AnimatedBuilder(
              animation: flashButtonAnimationController,
              builder: (BuildContext context, Widget? widget) {
                final double flashButtonAnimationValue = flashButtonAnimationController.value;

                return Transform.rotate(
                  angle: orientationAngle(orientationAnimationValue),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: iconSize,
                    height: stackHeight,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: iconList.length == 1 ? 0 : -stackHeight + flashButtonAnimationValue * stackHeight,
                          child: Column(
                            verticalDirection: VerticalDirection.up,
                            children: List<Widget>.generate(
                              iconList.length,
                              (int index) => Opacity(
                                opacity: index == 0 ? 1 - flashButtonAnimationValue : flashButtonAnimationValue,
                                child: Padding(
                                  // [padding] is considered to be [(stackHeight - iconSize) / 2]
                                  padding: const EdgeInsets.symmetric(vertical: 27.5),
                                  child: Icon(
                                    iconList[index],
                                    color: Colors.white,
                                    size: iconSize,
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
          : const SizedBox(width: iconSize),
    );
  }
}
