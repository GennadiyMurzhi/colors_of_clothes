import 'dart:io';

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/camera_cubit/camera_cubit.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/camera/widgets/camera_body.dart';
import 'package:colors_of_clothes/ui/colors_detected/colors_detected_screen.dart';
import 'package:colors_of_clothes/system.dart';
import 'package:colors_of_clothes/global.dart';
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
  late CameraController cameraController;
  late AnimationController flashButtonAnimationController;
  late AnimationController cameraButtonAnimationController;
  late AnimationController switchAnimationController;
  late AnimationController orientationAnimationController;
  bool controllerIsInitialized = false;

  @override
  void initState() {
    super.initState();

    setSystemUIToEdge();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);



    cameraController = createController(cameras[0]);

    cameraController.initialize().then(
      (value) {
        if (!mounted) {
          return;
        }

        controllerIsInitialized = true;

        WidgetsBinding.instance.addObserver(this);

        setState(() {});
      },
    );

    flashButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    cameraButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    switchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    orientationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..value = 0.5;

    NativeDeviceOrientationCommunicator().resume();

    NativeDeviceOrientationCommunicator().onOrientationChanged(useSensor: true).listen(
      (NativeDeviceOrientation event) {
        switch (event) {
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
    cameraController.dispose();
    flashButtonAnimationController.dispose();
    cameraButtonAnimationController.dispose();
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

  Future<void> precacheCapturePreview(Uint8List capturePreview) async {
    if (context.mounted) {
      await precacheImage(MemoryImage(capturePreview), context);
    }
  }

  void setCameraControllerAndIsInitialized(CameraController cameraController, bool isInitialized) {
    this.cameraController = cameraController;
    controllerIsInitialized = isInitialized;
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Container();
    }

    final Size previewSize = cameraController.value.previewSize!;
    final double previewHeight = MediaQuery.of(context).size.height;
    final double previewWidth = previewHeight * previewSize.height / previewSize.width;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
        body: BlocProvider<CameraCubit>(
          create: (context) => getIt<CameraCubit>()..setFlashIconOnInit(cameraController.value.flashMode),
          child: BlocBuilder<CameraCubit, CameraState>(
            builder: (BuildContext context, CameraState state) {
              return CameraBody(
                previewWidth: previewWidth,
                previewHeight: previewHeight,
                isEnabledSwitchButton: state.isEnabledSwitchButton,
                controllerIsInitialized: controllerIsInitialized,
                switchAnimationController: switchAnimationController,
                capturePreview: state.capturePreview,
                cameraController: cameraController,
                orientationAnimationController: orientationAnimationController,
                isCameraNotSwitched: state.isCameraNotSwitched,
                flashButtonAnimationController: flashButtonAnimationController,
                cameraButtonAnimationController: cameraButtonAnimationController,
                flashIconList: state.flashIconList,
                isEnabledFlashButton: state.isEnabledFlashButton,
                pushColorsDetected: pushColorsDetected,
                isSwitchButtonRotated: state.isSwitchButtonRotated,
                precacheCapturePreview: precacheCapturePreview,
                setCameraControllerAndIsInitialized: setCameraControllerAndIsInitialized,
              );
            },
          ),
        ),
      ),
    );
  }
}
