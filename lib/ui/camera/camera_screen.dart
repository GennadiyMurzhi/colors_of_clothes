import 'dart:math' as math;
import 'dart:ui' as ui;

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
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';

final GlobalKey _previewRepaintBoundaryKey = GlobalKey();

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  late CameraController controller;
  bool controllerIsInitialized = false;
  late AnimationController flashButtonAnimationController;
  late AnimationController cameraButtonAnimationController;
  late AnimationController switchAnimationController;
  bool _isEnabledPhotoButton = true;
  bool _isEnabledFlashButton = true;
  bool _isEnabledSwitchButton = true;
  bool _isCameraNotSwitched = true;
  bool _needBlur = false;
  final List<IconData> flashIconList = <IconData>[];
  Uint8List? _capturePreview;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    WidgetsBinding.instance.addObserver(this);

    controller = _createController(cameras[0]);

    controller.initialize().then((value) {
      if (!mounted) {
        return;
      }

      controllerIsInitialized = true;

      setState(() {});
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
      duration: const Duration(milliseconds: 350),
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

  //camera button

  void _takePictureAndOpenPhoto(XFile pictureXFile) {
    _isEnabledPhotoButton = false;
    controller.pausePreview();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          getIt<TensorCubit>().setPicture(pictureXFile);

          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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

  //flash button
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

  //switch button
  Future<void> _switchCamera(CameraDescription cameraDescription) async {
    controllerIsInitialized = false;

    await controller.dispose();

    controller = _createController(cameraDescription);

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      throw ('Error initializing camera: $e');
    }

    controllerIsInitialized = controller.value.isInitialized;
  }

  Future<Uint8List> _createCapturePreview() async {
    RenderRepaintBoundary boundary =
        _previewRepaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return bytes!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    _setFlashIconOnStart();

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox.fromSize(size: MediaQuery.of(context).size),
          !_isEnabledSwitchButton
              ? AnimatedBuilder(
                  animation: switchAnimationController,
                  builder: (BuildContext context, Widget? widget) {
                    return Transform(
                      transform: createSwitchPreviewMatrix(switchAnimationController.value),
                      alignment: Alignment.center,
                      child: Transform(
                        transform: createSwitchCaptureMatrix(switchAnimationController.value),
                        alignment: Alignment.center,
                        child: Image(
                          image: MemoryImage(_capturePreview!),
                        ),
                      ),
                    );
                  },
                )
              : controllerIsInitialized
                  ? RepaintBoundary(
                      key: _previewRepaintBoundaryKey,
                      child: CameraPreview(controller),
                    )
                  : const SizedBox(),
          Positioned(
            bottom: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _isCameraNotSwitched
                      ? AnimatedBuilder(
                          animation: flashButtonAnimationController,
                          builder: (BuildContext context, Widget? widget) {
                            return FlashButton(
                              currentFlashMode: controller.value.flashMode,
                              setFlashMode: _isEnabledFlashButton ? _setFlashModeAndIcon : null,
                              positionedTop:
                                  flashIconList.length == 1 ? 0 : -45 + flashButtonAnimationController.value * 45,
                              iconList: flashIconList,
                              opacity: flashButtonAnimationController.value,
                            );
                          },
                        )
                      : const SizedBox(width: 35),
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
                          _capturePreview = await _createCapturePreview();

                          if (context.mounted) {
                            await precacheImage(MemoryImage(_capturePreview!), context);
                          }

                          setState(() {
                            _isEnabledSwitchButton = false;
                          });

                          await switchAnimationController.animateTo(1);
                          setState(() {
                            _isCameraNotSwitched = !_isCameraNotSwitched;
                          });
                          if (_isCameraNotSwitched) {
                            await _switchCamera(cameras[0]);
                          } else {
                            await _switchCamera(cameras[1]);
                          }

                          switchAnimationController.reset();

                          setState(() {
                            _isEnabledSwitchButton = true;
                          });

                          _capturePreview = null;
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
