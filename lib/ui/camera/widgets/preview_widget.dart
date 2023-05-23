import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/domen/ui_utils.dart';
import 'package:colors_of_clothes/ui/camera/widgets/camera_preview_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class PreviewWidget extends StatelessWidget {
  const PreviewWidget({
    super.key,
    required this.previewSize,
    required this.needBlur,
    required this.switchAnimationController,
    required this.isCameraNotSwitched,
    required this.imageToRotate,
    required this.isDisplayPreview,
    required this.isDisplayImageToRotate,
    required this.imageStream,
    required this.opacityImageToRotateAnimationController,
  });

  final Size previewSize;
  final bool needBlur;
  final bool isCameraNotSwitched;
  final bool isDisplayPreview;
  final bool isDisplayImageToRotate;
  final AnimationController switchAnimationController;
  final Uint8List? imageToRotate;
  final Stream<Uint8List> imageStream;

  final AnimationController opacityImageToRotateAnimationController;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
        tileMode: TileMode.decal,
      ),
      enabled: needBlur,
      child: AnimatedBuilder(
        animation: switchAnimationController,
        builder: (BuildContext context, Widget? child) {
          return Transform(
            transform: createSwitchPreviewMatrix(switchAnimationController.value),
            alignment: Alignment.center,
            child: Transform(
              transform: createSwitchRotationMatrix(switchAnimationController.value),
              alignment: Alignment.center,
              child: CameraPreviewCustom(
                imageStream: imageStream,
                previewSize: previewSize,
                isCameraNotSwitched: isCameraNotSwitched,
                imageToRotate: imageToRotate,
                isDisplayPreview: isDisplayPreview,
                isDisplayImageToRotate: isDisplayImageToRotate,
                opacityImageToRotateAnimationController: opacityImageToRotateAnimationController,
              ),
            ),
          );
        },
      ),
    );
  }
}
