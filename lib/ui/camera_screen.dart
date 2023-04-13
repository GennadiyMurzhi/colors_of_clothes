import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/injection.dart';
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
  late AnimationController flashAnimationController;
  late AnimationController cameraAnimationController;
  bool _isEnabledPhotoButton = true;
  bool _isEnabledFlashButton = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
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

    flashAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    cameraAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    flashAnimationController.dispose();

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

  Future<void> _setFlashMode() async {
    _isEnabledFlashButton = false;

    switch (controller.value.flashMode) {
      case FlashMode.off:
        iconList.add(Icons.flash_auto);
        await controller.setFlashMode(FlashMode.auto);
        break;
      case FlashMode.auto:
        iconList.add(Icons.flash_on);
        await controller.setFlashMode(FlashMode.always);
        break;
      case FlashMode.always:
        iconList.add(Icons.flashlight_on);
        await controller.setFlashMode(FlashMode.torch);
        break;
      case FlashMode.torch:
        iconList.add(Icons.flash_off);
        await controller.setFlashMode(FlashMode.off);
        break;
      default:
        iconList.add(Icons.flash_off);
        await controller.setFlashMode(FlashMode.off);
    }

    setState(() {});

    await flashAnimationController.animateTo(
      1,
      curve: Curves.easeInOutCubic,
    );
    iconList.removeAt(0);
    flashAnimationController.reset();

    _isEnabledFlashButton = true;
  }

  final List<IconData> iconList = <IconData>[];

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    if (iconList.isEmpty) {
      switch (controller.value.flashMode) {
        case FlashMode.off:
          iconList.add(Icons.flash_off);
          break;
        case FlashMode.auto:
          iconList.add(Icons.flash_auto);
          break;
        case FlashMode.always:
          iconList.add(Icons.flash_on);
          break;
        case FlashMode.torch:
          iconList.add(Icons.flashlight_on);
          break;
        default:
          iconList.add(Icons.flash_off);
      }
    }

    print(flashAnimationController.status);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1 / controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              //alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: flashAnimationController,
                    builder: (BuildContext context, Widget? widget) {
                      return FlashButton(
                        currentFlashMode: controller.value.flashMode,
                        setFlashMode: _isEnabledFlashButton ? _setFlashMode : null,
                        positionedTop: iconList.length == 1 ? 0 : -45 + flashAnimationController.value * 45,
                        iconList: iconList,
                        opacity: flashAnimationController.value,
                      );
                    },
                  ),
                  AnimatedBuilder(
                      animation: cameraAnimationController,
                      builder: (BuildContext context, Widget? widget) {
                        return CameraButton(
                          onTap: () async {
                            if (_isEnabledPhotoButton) {
                              cameraAnimationController.animateTo(0.5);

                              XFile pictureXFile = await controller.takePicture();
                              await cameraAnimationController.animateTo(0);

                              _takePictureAndOpenPhoto(pictureXFile);
                            }
                          },
                          onTapCancel: () {
                            cameraAnimationController.animateTo(0);
                          },
                          onLongPressStart: (LongPressStartDetails details) {
                            cameraAnimationController.animateTo(0.5);
                          },
                          onLongPressEnd: (LongPressEndDetails details) async {
                            XFile pictureXFile = await controller.takePicture();
                            await cameraAnimationController.animateTo(0);
                            _takePictureAndOpenPhoto(pictureXFile);
                          },
                          onLongPressCancel: () {
                            cameraAnimationController.animateTo(0);
                          },
                          innerCameraSize: 80 * (1 - cameraAnimationController.value),
                          innerCameraAngle: math.pi * cameraAnimationController.value,
                        );
                      }),
                  _CameraButton(
                    onTap: () async {},
                    icon: Icons.cameraswitch_outlined,
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

class CameraButton extends StatelessWidget {
  const CameraButton({
    super.key,
    required this.onTap,
    required this.onTapCancel,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onLongPressCancel,
    required this.innerCameraSize,
    required this.innerCameraAngle,
  });

  final void Function() onTap;
  final void Function(LongPressStartDetails) onLongPressStart;
  final void Function(LongPressEndDetails) onLongPressEnd;
  final void Function() onLongPressCancel;
  final void Function() onTapCancel;
  final double innerCameraSize;
  final double innerCameraAngle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      onLongPressCancel: onLongPressCancel,
      onTapCancel: onTapCancel,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: Colors.white,
              ),
            ),
          ),
          Transform.rotate(
            angle: innerCameraAngle,
            child: Icon(
              Icons.camera,
              color: Colors.white,
              size: innerCameraSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraButton extends StatelessWidget {
  const _CameraButton({
    required this.onTap,
    required this.icon,
    this.size,
  });

  final void Function() onTap;
  final IconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.white,
        size: size ?? 35,
      ),
    );
  }
}

class FlashButton extends StatelessWidget {
  const FlashButton({
    super.key,
    required this.currentFlashMode,
    required this.setFlashMode,
    required this.positionedTop,
    required this.iconList,
    required this.opacity,
  });

  final FlashMode currentFlashMode;
  final Future<void> Function()? setFlashMode;
  final double positionedTop;
  final List<IconData> iconList;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (setFlashMode != null) {
          await setFlashMode!();
        }
      },
      child: SizedBox(
        width: 35,
        height: 45,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: positionedTop,
              child: Column(
                verticalDirection: VerticalDirection.up,
                children: List<Widget>.generate(
                  iconList.length,
                  (int index) => Opacity(
                    opacity: index == 0 ? 1 - opacity : opacity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Icon(
                        iconList[index],
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
