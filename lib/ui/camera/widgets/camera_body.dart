import 'dart:typed_data';

import 'package:camera/camera.dart';
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
    required this.previewWidth,
    required this.previewHeight,
    required this.isEnabledSwitchButton,
    required this.controllerIsInitialized,
    required this.capturePreview,
    required this.orientationAnimationController,
    required this.isCameraNotSwitched,
    required this.flashButtonAnimationController,
    required this.cameraButtonAnimationController,
    required this.flashIconList,
    required this.isEnabledFlashButton,
    required this.cameraController,
    required this.pushColorsDetected,
    required this.isSwitchButtonRotated,
    required this.switchAnimationController,
    required this.precacheCapturePreview,
    required this.setCameraControllerAndIsInitialized,
  });

  final double previewWidth;
  final double previewHeight;
  final bool isEnabledSwitchButton;
  final bool controllerIsInitialized;
  final Uint8List? capturePreview;
  final AnimationController orientationAnimationController;
  final bool isCameraNotSwitched;
  final AnimationController flashButtonAnimationController;
  final AnimationController cameraButtonAnimationController;
  final List<IconData> flashIconList;
  final bool isEnabledFlashButton;
  final CameraController cameraController;
  final void Function(XFile) pushColorsDetected;
  final bool isSwitchButtonRotated;
  final AnimationController switchAnimationController;
  final Future<void> Function(Uint8List) precacheCapturePreview;
  final void Function(CameraController, bool) setCameraControllerAndIsInitialized;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PreviewWidget(
          previewWidth: previewWidth,
          previewHeight: previewHeight,
          isEnabledSwitchButton: isEnabledSwitchButton,
          controllerIsInitialized: controllerIsInitialized,
          switchAnimationController: switchAnimationController,
          capturePreview: capturePreview,
          cameraController: cameraController,
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
                      setFlashMode: isEnabledFlashButton
                          ? () async => await BlocProvider.of<CameraCubit>(context).setFlashModeAndIcon(
                                flashMode: cameraController.value.flashMode,
                                setFlashMode: cameraController.setFlashMode,
                                animateToFlashButtonAnimation: flashButtonAnimationController.animateTo,
                                resetFlashButtonAnimation: flashButtonAnimationController.reset,
                              )
                          : null,
                      iconList: flashIconList,
                      orientationAnimationValue: orientationAnimationController.value,
                    ),
                    CameraButton(
                      cameraButtonAnimationController: cameraButtonAnimationController,
                      orientationAnimationValue: orientationAnimationController.value,
                      onTap: () => BlocProvider.of<CameraCubit>(context).cameraButtonOnTap(
                        takePicture: cameraController.takePicture,
                        animateToCameraButtonAnimation: cameraButtonAnimationController.animateTo,
                        animateBackCameraButtonAnimation: cameraButtonAnimationController.animateBack,
                        pushColorsDetected: pushColorsDetected,
                      ),
                    ),
                    SwitchCameraButton(
                      onTap: () async {
                        BlocProvider.of<CameraCubit>(context).switchCameraButtonOnTap(
                          cameraController: cameraController,
                          precacheCapturePreview: precacheCapturePreview,
                          animateToCameraButtonAnimation: switchAnimationController.animateTo,
                          resetCameraButtonAnimation: switchAnimationController.reset,
                          setCameraControllerAndIsInitialized: setCameraControllerAndIsInitialized,
                        );
                      },
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
