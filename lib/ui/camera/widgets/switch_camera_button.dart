import 'package:flutter/material.dart';

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({
    super.key,
    required this.onTap,
    required this.animationMatrix,
    required this.isNotSwitched,
  });

  final void Function() onTap;
  final Matrix4 animationMatrix;
  final bool isNotSwitched;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform(
        transform: animationMatrix,
        child: Icon(
          isNotSwitched ? Icons.cameraswitch_outlined : Icons.camera_front,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}