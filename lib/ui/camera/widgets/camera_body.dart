import 'dart:io';
import 'dart:typed_data';

import 'package:colors_of_clothes/app/camera_cubit/camera_cubit.dart';
import 'package:colors_of_clothes/ui/camera/widgets/camera_button.dart';
import 'package:colors_of_clothes/ui/camera/widgets/flash_button.dart';
import 'package:colors_of_clothes/ui/camera/widgets/preview_widget.dart';
import 'package:colors_of_clothes/ui/camera/widgets/switch_camera_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraBody extends StatelessWidget {
  const CameraBody({
    super.key,
    required this.previewSize,
    required this.orientationAnimationController,
    required this.isCameraNotSwitched,
    required this.flashButtonAnimationController,
    required this.flashIconList,
    required this.pushColorsDetected,
    required this.isSwitchButtonRotated,
    required this.switchAnimationController,
    required this.precachePreview,
    required this.imageToRotate,
    required this.isDisplayPreview,
    required this.isDisplayImageToRotate,
    required this.isEnabledButtons,
    required this.imageStream,
    required this.opacityImageToRotateAnimationController,
    required this.needBlur,
  });

  final Size previewSize;
  final AnimationController orientationAnimationController;
  final bool isCameraNotSwitched;
  final AnimationController flashButtonAnimationController;
  final List<IconData> flashIconList;
  final void Function(File) pushColorsDetected;
  final bool isSwitchButtonRotated;
  final bool isDisplayPreview;
  final bool isDisplayImageToRotate;
  final bool isEnabledButtons;
  final bool needBlur;
  final AnimationController switchAnimationController;
  final AnimationController opacityImageToRotateAnimationController;
  final Future<void> Function(Uint8List) precachePreview;
  final Uint8List? imageToRotate;
  final Stream<Uint8List> imageStream;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PreviewWidget(
          needBlur: needBlur,
          previewSize: previewSize,
          switchAnimationController: switchAnimationController,
          imageToRotate: imageToRotate,
          isCameraNotSwitched: isCameraNotSwitched,
          isDisplayPreview: isDisplayPreview,
          isDisplayImageToRotate: isDisplayImageToRotate,
          imageStream: imageStream,
          opacityImageToRotateAnimationController: opacityImageToRotateAnimationController,
        ),
        Positioned(
          bottom: 80,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedBuilder(
              animation: orientationAnimationController,
              builder: (BuildContext context, Widget? widget) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlashButton(
                      isCameraNotSwitched: isCameraNotSwitched,
                      flashButtonAnimationController: flashButtonAnimationController,
                      setFlashMode: isEnabledButtons
                          ? () async => await BlocProvider.of<CameraCubit>(context).setFlashModeAndIcon(
                                animateToFlashButtonAnimation: flashButtonAnimationController.animateTo,
                                resetFlashButtonAnimation: flashButtonAnimationController.reset,
                              )
                          : null,
                      iconList: flashIconList,
                      orientationAnimationValue: orientationAnimationController.value,
                    ),
                    CameraButton(
                      onTap: isEnabledButtons
                          ? () => BlocProvider.of<CameraCubit>(context).cameraButtonOnTap(
                                pushColorsDetected: pushColorsDetected,
                              )
                          : null,
                    ),
                    SwitchCameraButton(
                      onTap: isEnabledButtons
                          ? () {
                              BlocProvider.of<CameraCubit>(context).switchCameraButtonOnTap(
                                animateToSwitchButtonAnimation: switchAnimationController.animateTo,
                                precachePreview: precachePreview,
                              );
                            }
                          : null,
                      switchAnimationController: switchAnimationController,
                      isSwitchButtonRotated: isSwitchButtonRotated,
                      orientationAnimationValue: orientationAnimationController.value,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
