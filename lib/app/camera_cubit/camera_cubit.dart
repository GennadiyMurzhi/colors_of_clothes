import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'camera_state.dart';

part 'camera_cubit.freezed.dart';

@Injectable()
class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState.initial());

  void setFlashIconOnInit(FlashMode flashMode) {
    final List<IconData> flashIconList = <IconData>[];

    switch (flashMode) {
      case FlashMode.off:
        flashIconList.add(Icons.flash_off);
        break;
      case FlashMode.auto:
        flashIconList.add(Icons.flash_auto);
        break;
      case FlashMode.always:
        flashIconList.add(Icons.flash_on);
        break;
      case FlashMode.torch:
        flashIconList.add(Icons.flashlight_on);
        break;
      default:
        flashIconList.add(Icons.flash_off);
    }

    emit(
      state.copyWith(
        flashIconList: flashIconList,
      ),
    );
  }

  Future<void> setFlashModeAndIcon({
    required FlashMode flashMode,
    required Future<void> Function(FlashMode) setFlashMode,
    required TickerFuture Function(double target, {Duration? duration, Curve curve}) animateToFlashButtonAnimation,
    required void Function() resetFlashButtonAnimation,
  }) async {
    emit(
      state.copyWith(
        isEnabledFlashButton: false,
      ),
    );

    switch (flashMode) {
      case FlashMode.off:
        _addIcon(Icons.flash_auto);
        await setFlashMode(FlashMode.auto);
        break;
      case FlashMode.auto:
        _addIcon(Icons.flash_on);
        await setFlashMode(FlashMode.always);
        break;
      case FlashMode.always:
        _addIcon(Icons.flashlight_on);
        await setFlashMode(FlashMode.torch);
        break;
      case FlashMode.torch:
        _addIcon(Icons.flash_off);
        await setFlashMode(FlashMode.off);
        break;
    }

    await animateToFlashButtonAnimation(
      1,
      curve: Curves.easeInOutCubic,
    );

    emit(
      state.copyWith(
        flashIconList: List<IconData>.from(state.flashIconList)..removeAt(0),
      ),
    );

    resetFlashButtonAnimation();

    emit(
      state.copyWith(
        isEnabledFlashButton: true,
      ),
    );
  }

  void _addIcon(IconData icon) {
    emit(
      state.copyWith(
        flashIconList: List<IconData>.from(state.flashIconList)..add(icon),
      ),
    );
  }

  Future<void> cameraButtonOnTap({
    required Future<XFile> Function() takePicture,
    required TickerFuture Function(double target, {Duration? duration, Curve curve}) animateToCameraButtonAnimation,
    required TickerFuture Function(double target, {Duration? duration, Curve curve}) animateBackCameraButtonAnimation,
    required void Function(XFile) pushColorsDetected,
  }) async {
    if (state.isEnabledPhotoButton) {
      emit(
        state.copyWith(
          isEnabledPhotoButton: false,
        ),
      );

      animateToCameraButtonAnimation(0.5);

      XFile pictureXFile = await takePicture();

      await animateBackCameraButtonAnimation(0);

      pushColorsDetected(pictureXFile);
    }
  }

  Future<void> switchCameraButtonOnTap({
    required CameraController cameraController,
    required Future<void> Function(Uint8List) precacheCapturePreview,
    required TickerFuture Function(double target, {Duration? duration, Curve curve}) animateToCameraButtonAnimation,
    required void Function() resetCameraButtonAnimation,
    required void Function(CameraController, bool) setCameraControllerAndIsInitialized,
  }) async {
    final Uint8List capturePreview = await _createCapturePreview();

    await precacheCapturePreview(capturePreview);

    emit(
      state.copyWith(
        capturePreview: capturePreview,
        isEnabledSwitchButton: false,
        isCameraNotSwitched: !state.isCameraNotSwitched,
      ),
    );

    if (state.isCameraNotSwitched) {
      await _switchCamera(cameras[0], cameraController, setCameraControllerAndIsInitialized);
    } else {
      await _switchCamera(cameras[1], cameraController, setCameraControllerAndIsInitialized);
    }

    await animateToCameraButtonAnimation(0.5, curve: Curves.bounceIn);

    emit(
      state.copyWith(
        isSwitchButtonRotated: !state.isSwitchButtonRotated,
      ),
    );

    await animateToCameraButtonAnimation(1, curve: Curves.bounceOut);

    resetCameraButtonAnimation();

    emit(
      state.copyWith(
        isEnabledSwitchButton: true,
      ),
    );
    //capturePreview = null;
  }

  Future<void> _switchCamera(
    CameraDescription cameraDescription,
    CameraController cameraController,
    void Function(CameraController, bool) setCameraControllerAndIsInitialized,
  ) async {
    emit(
      state.copyWith(
        controllerIsInitialized: false,
      ),
    );

    await cameraController.dispose();

    cameraController = createController(cameraDescription);

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      throw ('Error initializing camera: $e');
    }

    setCameraControllerAndIsInitialized(cameraController, cameraController.value.isInitialized);
  }
}

Future<Uint8List> _createCapturePreview() async {
  RenderRepaintBoundary boundary =
      previewRepaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage();
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  if (bytes != null) {
    return bytes.buffer.asUint8List();
  } else {
    throw ('no bytes on previewRepaintBoundaryKey.currentContext');
  }
}

CameraController createController(CameraDescription cameraDescription) => CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
