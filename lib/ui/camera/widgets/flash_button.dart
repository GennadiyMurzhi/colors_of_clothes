import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlashButton extends StatelessWidget {
  const FlashButton({
    super.key,
    required this.currentFlashMode,
    required this.setFlashMode,
    required this.positionedTop,
    required this.iconList,
    required this.opacity,
  });

  final FlashMode currentFlashMode;
  final Future<void> Function()? setFlashMode;
  final double positionedTop;
  final List<IconData> iconList;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (setFlashMode != null) {
          await setFlashMode!();
        }
      },
      child: SizedBox(
        width: 35,
        height: 45,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: positionedTop,
              child: Column(
                verticalDirection: VerticalDirection.up,
                children: List<Widget>.generate(
                  iconList.length,
                      (int index) => Opacity(
                    opacity: index == 0 ? 1 - opacity : opacity,
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
  }
}