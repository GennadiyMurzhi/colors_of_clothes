import 'dart:io';

import 'package:colors_of_clothes/app/camera_cubit/camera_cubit.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/system.dart';
import 'package:colors_of_clothes/ui/camera/widgets/camera_body.dart';
import 'package:colors_of_clothes/ui/colors_detected/colors_detected_screen.dart';
import 'package:colors_of_clothes/ui/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController flashButtonAnimationController;
  late AnimationController switchAnimationController;
  late AnimationController orientationAnimationController;
  late AnimationController opacityImageToRotateAnimationController;

  @override
  void initState() {
    super.initState();

    setSystemUIToEdge();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    WidgetsBinding.instance.addObserver(this);

    flashButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    switchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    opacityImageToRotateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    orientationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..value = 0.5;

    NativeDeviceOrientationCommunicator().resume();
    NativeDeviceOrientationCommunicator().orientation().then((NativeDeviceOrientation orientation) {
      switch (orientation) {
        case NativeDeviceOrientation.portraitDown:
          break;
        case NativeDeviceOrientation.unknown:
          break;
        case NativeDeviceOrientation.portraitUp:
          break;
        case NativeDeviceOrientation.landscapeLeft:
          orientationAnimationController.animateTo(1, curve: Curves.easeIn);
          break;
        case NativeDeviceOrientation.landscapeRight:
          orientationAnimationController.animateBack(0, curve: Curves.easeIn);
          break;
      }
    });
    NativeDeviceOrientationCommunicator().onOrientationChanged(useSensor: true).listen(
      (NativeDeviceOrientation orientation) {
        switch (orientation) {
          case NativeDeviceOrientation.portraitDown:
            break;
          case NativeDeviceOrientation.unknown:
            break;
          case NativeDeviceOrientation.portraitUp:
            if (orientationAnimationController.value != 0.5) {
              orientationAnimationController.animateTo(0.5, curve: Curves.easeIn);
            }
            break;
          case NativeDeviceOrientation.landscapeLeft:
            if (orientationAnimationController.value != 1) {
              orientationAnimationController.animateTo(1, curve: Curves.easeIn);
            }
            break;
          case NativeDeviceOrientation.landscapeRight:
            if (orientationAnimationController.value != 0) {
              orientationAnimationController.animateBack(0, curve: Curves.easeIn);
            }
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    flashButtonAnimationController.dispose();
    switchAnimationController.dispose();
    orientationAnimationController.dispose();

    WidgetsBinding.instance.removeObserver(this);

    NativeDeviceOrientationCommunicator().pause();

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

  void backButtonOnPressed() {
    _setDefaultSystemSettings();

    Navigator.of(context).pop();
  }

  Future<bool> onWillPop() async {
    _setDefaultSystemSettings();

    return true;
  }

  void pushColorsDetected(File imageFile) {
    _setDefaultSystemSettings();

    getIt<TensorCubit>().setPicture(imageFile);

    Navigator.pushReplacement(
      context,
      buildRoute(const ColorsDetectedScreen()),
    );
  }

  void _setDefaultSystemSettings() {
    setSystemUI();

    setDefaultOrientation();
  }

  Future<void> precachePreview(Uint8List capturePreview) async {
    if (context.mounted) {
      await precacheImage(MemoryImage(capturePreview), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: BlocProvider<CameraCubit>(
        create: (BuildContext context) => getIt<CameraCubit>()
          ..init(
            deviceSize: MediaQuery.of(this.context).size,
            precachePreview: precachePreview,
            resetSwitchButtonAnimation: switchAnimationController.reset,
            animateToOpacityImageToRotateAnimation:
            opacityImageToRotateAnimationController.animateTo,
            resetToOpacityImageToRotateAnimation: opacityImageToRotateAnimationController.reset,
          ),
        child: BlocBuilder<CameraCubit, CameraState>(
          builder: (BuildContext context, CameraState state) {
            if (state.isInit) {
              return Scaffold(
                extendBodyBehindAppBar: true,
                extendBody: true,
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: BackButton(
                    onPressed: backButtonOnPressed,
                  ),
                ),
                body: CameraBody(
                  previewSize: state.previewSize,
                  switchAnimationController: switchAnimationController,
                  orientationAnimationController: orientationAnimationController,
                  isCameraNotSwitched: state.isCameraNotSwitched,
                  flashButtonAnimationController: flashButtonAnimationController,
                  flashIconList: state.flashIconList,
                  pushColorsDetected: pushColorsDetected,
                  isSwitchButtonRotated: state.isSwitchButtonRotated,
                  precachePreview: precachePreview,
                  isDisplayPreview: state.isDisplayPreview,
                  isDisplayImageToRotate: state.isDisplayImageToRotate,
                  imageToRotate: state.imageToRotate,
                  imageStream: BlocProvider.of<CameraCubit>(context).imageStream,
                  needBlur: state.needBlur,
                  opacityImageToRotateAnimationController: opacityImageToRotateAnimationController,
                  isEnabledButtons: state.isEnabledButtons,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
