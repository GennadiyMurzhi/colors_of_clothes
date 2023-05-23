import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraPreviewCustom extends StatelessWidget {
  const CameraPreviewCustom({
    super.key,
    required this.previewSize,
    required this.isCameraNotSwitched,
    required this.imageToRotate,
    required this.isDisplayPreview,
    required this.isDisplayImageToRotate,
    required this.imageStream,
    required this.opacityImageToRotateAnimationController,
  });

  final Size previewSize;
  final bool isCameraNotSwitched;
  final bool isDisplayPreview;
  final bool isDisplayImageToRotate;
  final Uint8List? imageToRotate;
  final Stream<Uint8List> imageStream;
  final AnimationController opacityImageToRotateAnimationController;

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    final double top = MediaQuery.of(context).padding.top;
    final Size previewSize = Size(this.previewSize.width + top, this.previewSize.height + top);

    return SizedBox.fromSize(
      size: mediaSize,
      child: ClipRect(
        clipper: _PreviewClipper(mediaSize),
        child: UnconstrainedBox(
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (isDisplayPreview)
                StreamBuilder<Uint8List>(
                  stream: imageStream,
                  builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Transform(
                        transform: isCameraNotSwitched ? Matrix4.identity() : Matrix4.rotationY(pi),
                        alignment: Alignment.center,
                        child: Transform.rotate(
                          angle: isCameraNotSwitched ? pi / 2 : -pi / 2,
                          child: SizedBox(
                            width: previewSize.height,
                            height: previewSize.width,
                            child: Image(
                              image: MemoryImage(snapshot.data!),
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              if (isDisplayImageToRotate)
                AnimatedBuilder(
                  animation: opacityImageToRotateAnimationController,
                  builder: (BuildContext context, Widget? widget) {
                    return Opacity(
                      opacity: 1 - opacityImageToRotateAnimationController.value,
                      child: Transform(
                        transform: !isCameraNotSwitched ? Matrix4.identity() : Matrix4.rotationY(pi),
                        alignment: Alignment.center,
                        child: Transform.rotate(
                          angle: !isCameraNotSwitched ? pi / 2 : -pi / 2,
                          child: imageToRotate != null
                              ? SizedBox(
                                  width: previewSize.height,
                                  height: previewSize.width,
                                  child: Image(
                                    image: MemoryImage(
                                      imageToRotate!,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
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
