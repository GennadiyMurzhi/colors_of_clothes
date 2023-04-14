import 'dart:math' as math;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/domen/ui_helpers.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/camera/widgets/camera_button.dart';
import 'package:colors_of_clothes/ui/camera/widgets/flash_button.dart';
import 'package:colors_of_clothes/ui/camera/widgets/switch_camera_button.dart';
import 'package:colors_of_clothes/ui/colors_detected/colors_detected_screen.dart';
import 'package:flutter/material.dart';
import 'package:colors_of_clothes/main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  late CameraController controller;
  late AnimationController flashButtonAnimationController;
  late AnimationController cameraButtonAnimationController;
  late AnimationController switchAnimationController;
  bool _isEnabledPhotoButton = true;
  bool _isEnabledFlashButton = true;
  bool _isEnabledSwitchButton = true;
  bool _isCameraNotSwitched = true;
  final List<IconData> flashIconList = <IconData>[];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    controller = _createController(cameras[0]);

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });

    flashButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    cameraButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    switchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    flashButtonAnimationController.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      Navigator.of(context).pop();
    }
  }

  CameraController _createController(CameraDescription cameraDescription) => CameraController(
        cameraDescription,
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

  Future<void> _selectCamera(CameraDescription cameraDescription) async {
    await controller.dispose();

    controller = _createController(cameraDescription);

    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });


  }

  void _takePictureAndOpenPhoto(XFile pictureXFile) {
    _isEnabledPhotoButton = false;
    controller.pausePreview();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          getIt<TensorCubit>().setPicture(pictureXFile);

          return const ColorsDetectedScreen();
        },
      ),
    );
  }

  Future<void> _cameraButtonOnTap() async {
    if (_isEnabledPhotoButton) {
      cameraButtonAnimationController.animateTo(0.5);

      XFile pictureXFile = await controller.takePicture();
      await cameraButtonAnimationController.animateTo(0);

      _takePictureAndOpenPhoto(pictureXFile);
    }
  }

  void _cameraButtonOnLongPressStart(LongPressStartDetails details) {
    cameraButtonAnimationController.animateTo(0.5);
  }

  Future<void> _cameraButtonOnLongPressEnd(LongPressEndDetails details) async {
    XFile pictureXFile = await controller.takePicture();
    await cameraButtonAnimationController.animateTo(0);
    _takePictureAndOpenPhoto(pictureXFile);
  }

  void _cameraButtonOnLongPressCancel() {
    cameraButtonAnimationController.animateTo(0);
  }

  Future<void> _setFlashModeAndIcon() async {
    _isEnabledFlashButton = false;

    switch (controller.value.flashMode) {
      case FlashMode.off:
        flashIconList.add(Icons.flash_auto);
        await controller.setFlashMode(FlashMode.auto);
        break;
      case FlashMode.auto:
        flashIconList.add(Icons.flash_on);
        await controller.setFlashMode(FlashMode.always);
        break;
      case FlashMode.always:
        flashIconList.add(Icons.flashlight_on);
        await controller.setFlashMode(FlashMode.torch);
        break;
      case FlashMode.torch:
        flashIconList.add(Icons.flash_off);
        await controller.setFlashMode(FlashMode.off);
        break;
      default:
        flashIconList.add(Icons.flash_off);
        await controller.setFlashMode(FlashMode.off);
    }

    setState(() {});

    await flashButtonAnimationController.animateTo(
      1,
      curve: Curves.easeInOutCubic,
    );
    flashIconList.removeAt(0);
    flashButtonAnimationController.reset();

    _isEnabledFlashButton = true;
  }

  void _setFlashIconOnStart() {
    if (flashIconList.isEmpty) {
      switch (controller.value.flashMode) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    _setFlashIconOnStart();

    final double translatePreview = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: Stack(
        children: <Widget>[
          AnimatedBuilder(
              animation: switchAnimationController,
              builder: (BuildContext context, Widget? widget) {
                return Transform(
                  transform: createSwitchPreviewMatrix(switchAnimationController.value, translatePreview),
                  child: AspectRatio(
                    aspectRatio: 1 / controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                );
              }),
          Positioned(
            bottom: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (_isCameraNotSwitched) AnimatedBuilder(
                    animation: flashButtonAnimationController,
                    builder: (BuildContext context, Widget? widget) {
                      return FlashButton(
                        currentFlashMode: controller.value.flashMode,
                        setFlashMode: _isEnabledFlashButton ? _setFlashModeAndIcon : null,
                        positionedTop: flashIconList.length == 1 ? 0 : -45 + flashButtonAnimationController.value * 45,
                        iconList: flashIconList,
                        opacity: flashButtonAnimationController.value,
                      );
                    },
                  ),
                  AnimatedBuilder(
                      animation: cameraButtonAnimationController,
                      builder: (BuildContext context, Widget? widget) {
                        return CameraButton(
                          onTap: _cameraButtonOnTap,
                          onLongPressStart: _cameraButtonOnLongPressStart,
                          onLongPressEnd: _cameraButtonOnLongPressEnd,
                          onLongPressCancel: _cameraButtonOnLongPressCancel,
                          innerCameraSize: 80 * (1 - cameraButtonAnimationController.value),
                          innerCameraAngle: math.pi * cameraButtonAnimationController.value,
                        );
                      }),
                  AnimatedBuilder(
                    animation: switchAnimationController,
                    builder: (BuildContext context, Widget? widget) {
                      return SwitchCameraButton(
                        onTap: () async {
                          _isEnabledSwitchButton = false;
                          await switchAnimationController.animateTo(1);
                          _isCameraNotSwitched = !_isCameraNotSwitched;
                          if (_isCameraNotSwitched) {
                            await _selectCamera(cameras[0]);
                          } else {
                            await _selectCamera(cameras[1]);
                          }


                          await switchAnimationController.animateTo(0);
                          _isEnabledSwitchButton = true;
                        },
                        animationMatrix: createSwitchButtonMatrix(switchAnimationController.value, 17.5),
                        isNotSwitched: _isCameraNotSwitched,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
