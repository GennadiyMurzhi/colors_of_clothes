import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/domen/ui_helpers.dart';
import 'package:colors_of_clothes/app/global.dart';
import 'package:flutter/cupertino.dart';

class PreviewWidget extends StatelessWidget {
  const PreviewWidget({
    super.key,
    required this.previewWidth,
    required this.previewHeight,
    required this.isEnabledSwitchButton,
    required this.controllerIsInitialized,
    required this.switchAnimationController,
    required this.capturePreview,
    required this.cameraController,
  });

  final double previewWidth;
  final double previewHeight;
  final bool isEnabledSwitchButton;
  final bool controllerIsInitialized;
  final AnimationController switchAnimationController;
  final Uint8List? capturePreview;
  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return !isEnabledSwitchButton
        ? ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
              tileMode: TileMode.repeated,
            ),
            child: AnimatedBuilder(
              animation: switchAnimationController,
              builder: (BuildContext context, Widget? widget) {
                return Transform(
                  transform: createSwitchPreviewMatrix(switchAnimationController.value),
                  alignment: Alignment.center,
                  child: Transform(
                    transform: createSwitchRotationMatrix(switchAnimationController.value),
                    alignment: Alignment.center,
                    child: capturePreview != null
                        ? Image(
                            image: MemoryImage(capturePreview!),
                          )
                        : const SizedBox(),
                  ),
                );
              },
            ),
          )
        : controllerIsInitialized
            ? RepaintBoundary(
                key: previewRepaintBoundaryKey,
                child: ClipRect(
                  clipper: _PreviewClipper(MediaQuery.of(context).size),
                  child: UnconstrainedBox(
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: previewWidth,
                      height: previewHeight,
                      child: CameraPreview(cameraController),
                    ),
                  ),
                ),
              )
            : const SizedBox();
  }
}

class _PreviewClipper extends CustomClipper<Rect> {
  _PreviewClipper(this.screenSize);

  final Size screenSize;

  @override
  ui.Rect getClip(ui.Size size) {
    ui.Rect rect = ui.Rect.fromPoints(Offset.zero, Offset(screenSize.width, screenSize.height));

    return rect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<ui.Rect> oldClipper) {
    return true;
  }
}
