import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/camera/image_receiver.dart';
import 'package:colors_of_clothes/global.dart';
import 'package:colors_of_clothes/ui/colors_of_clothes_custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'camera_state.dart';

part 'camera_cubit.freezed.dart';

@Injectable()
class CameraCubit extends Cubit<CameraState> {
  CameraCubit(this._imageReceiver) : super(CameraState.initial());

  final ImageReceiver _imageReceiver;
  late CameraController _cameraController;
  final BehaviorSubject<CameraImage> _precacheEmitStream = BehaviorSubject();
  late final StreamSubscription<CameraImage> _precacheEmitSubscription;
  int _baledImage = 0;


  Future<void> init({
    required Size deviceSize,
    required Future<void> Function(Uint8List) precachePreview,
    required void Function() resetSwitchButtonAnimation,
    required TickerFuture Function(double target, {Duration? duration, Curve curve})
        animateToOpacityImageToRotateAnimation,
    required void Function() resetToOpacityImageToRotateAnimation,
  }) async {
    _cameraController = createController(cameras[0]);
    await _cameraController.initialize();
    await _cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);

    final Size previewSizeController = _cameraController.value.previewSize!;
    final double previewHeight = deviceSize.height;
    final double previewWidth = previewHeight * previewSizeController.height / previewSizeController.width;

    emit(
      state.copyWith(
        isInit: true,
        previewSize: Size(previewWidth, previewHeight),
        flashIconList: _flashIconListOnInit(_cameraController.value.flashMode),
        isDisplayPreview: true,
      ),
    );
    
    _precacheEmitSubscription = _precacheEmitStream.listen((CameraImage image) async {
      await _onPrecacheEmitStreamEvent(image, precachePreview);

      if (state.isDisplayPreview == true && state.isDisplayImageToRotate == true && state.isEnabledButtons == false) {
        await animateToOpacityImageToRotateAnimation(
          1,
          curve: Curves.fastOutSlowIn,
        );

        emit(
          state.copyWith(
            imageToRotate: null,
            isDisplayImageToRotate: false,
            isEnabledButtons: true,
            isSwitchButtonRotated: !state.isSwitchButtonRotated,
            needBlur: false,
          ),
        );

        resetToOpacityImageToRotateAnimation();
        resetSwitchButtonAnimation();
      }
    });

    _startImageStream();
  }

  List<IconData> _flashIconListOnInit(FlashMode flashMode) {
    final List<IconData> flashIconList = <IconData>[];

    switch (flashMode) {
      case FlashMode.off:
        flashIconList.add(ColorsOfClothesCustomIcons.flash_off);
        break;
      case FlashMode.auto:
        flashIconList.add(ColorsOfClothesCustomIcons.flash_auto);
        break;
      case FlashMode.always:
        flashIconList.add(ColorsOfClothesCustomIcons.flash_on);
        break;
      case FlashMode.torch:
        flashIconList.add(ColorsOfClothesCustomIcons.flash_lighter);
        break;
      default:
        flashIconList.add(ColorsOfClothesCustomIcons.flash_off);
    }

    return flashIconList;
  }

  Future<void> setFlashModeAndIcon({
    required TickerFuture Function(double target, {Duration? duration, Curve curve}) animateToFlashButtonAnimation,
    required void Function() resetFlashButtonAnimation,
  }) async {
    emit(
      state.copyWith(
        isEnabledButtons: false,
      ),
    );

    switch (_cameraController.value.flashMode) {
      case FlashMode.off:
        _addIcon(ColorsOfClothesCustomIcons.flash_auto);
        await _cameraController.setFlashMode(FlashMode.auto);
        break;
      case FlashMode.auto:
        _addIcon(ColorsOfClothesCustomIcons.flash_on);
        await _cameraController.setFlashMode(FlashMode.always);
        break;
      case FlashMode.always:
        _addIcon(ColorsOfClothesCustomIcons.flash_lighter);
        await _cameraController.setFlashMode(FlashMode.torch);
        break;
      case FlashMode.torch:
        _addIcon(ColorsOfClothesCustomIcons.flash_off);
        await _cameraController.setFlashMode(FlashMode.off);
        break;
    }

    await animateToFlashButtonAnimation(
      1,
      curve: Curves.ease,
    );

    emit(
      state.copyWith(
        flashIconList: List<IconData>.from(state.flashIconList)..removeAt(0),
      ),
    );

    resetFlashButtonAnimation();

    emit(
      state.copyWith(
        isEnabledButtons: true,
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
    required void Function(File) pushColorsDetected,
  }) async {
    emit(
      state.copyWith(
        isEnabledButtons: false,
      ),
    );

    await _cameraController.stopImageStream();

    XFile pictureXFile = await _cameraController.takePicture();

    pushColorsDetected(File(pictureXFile.path));
  }

  Future<void> switchCameraButtonOnTap({
    required TickerFuture Function(double target, {Duration? duration, Curve curve}) animateToSwitchButtonAnimation,
    required Future<void> Function(Uint8List) precachePreview,
  }) async {
    emit(
      state.copyWith(
        isEnabledButtons: false,
      ),
    );

    final List<IconData> flashIconList;
    if (_cameraController.value.flashMode == FlashMode.torch && state.isCameraNotSwitched) {
      await _cameraController.setFlashMode(FlashMode.off);
      flashIconList = <IconData>[ColorsOfClothesCustomIcons.flash_off];
    } else {
      flashIconList = state.flashIconList;
    }

    emit(
      state.copyWith(
        isCameraNotSwitched: !state.isCameraNotSwitched,
        imageToRotate: _imageReceiver.lastImage,
        isDisplayPreview: false,
        isDisplayImageToRotate: true,
        flashIconList: flashIconList,
        needBlur: true,
      ),
    );

    animateToSwitchButtonAnimation(1, curve: Curves.fastOutSlowIn);

    await _cameraController.dispose();

    if (state.isCameraNotSwitched) {
      _cameraController = createController(cameras[0]);
    } else {
      _cameraController = createController(cameras[1]);
    }

    await _cameraController.initialize();

    emit(
      state.copyWith(
        isDisplayPreview: true,
      ),
    );

    _baledImage = 0;
    _startImageStream();
  }

  Future<void> _startImageStream() async {
    await _cameraController.startImageStream((CameraImage image) {
      if (_baledImage == 1) {
        _precacheEmitStream.add(image);
      } else {
        _baledImage++;
      }
    });
  }

  Future<void> _onPrecacheEmitStreamEvent(
    CameraImage cameraImage,
    Future<void> Function(Uint8List) precachePreview,
  ) async {
    final Uint8List image = cameraImage.planes[0].bytes;

    await precachePreview(image);
    _imageReceiver.addImage(image);
  }

  @override
  Future<void> close() async {
    await _cameraController.stopImageStream();
    await _cameraController.dispose();
    await _imageReceiver.close();
    await _precacheEmitSubscription.cancel();
    await _precacheEmitStream.close();

    super.close();
  }

  Stream<Uint8List> get imageStream => _imageReceiver.imageStream;
}

CameraController createController(CameraDescription cameraDescription) => CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
