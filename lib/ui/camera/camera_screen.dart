import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/camera_cubit/camera_cubit.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/camera/widgets/camera_body.dart';
import 'package:colors_of_clothes/ui/colors_detected/colors_detected_screen.dart';
import 'package:colors_of_clothes/domen/system.dart';
import 'package:colors_of_clothes/ui/global.dart';
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

    WidgetsBinding.instance.addObserver(this);

    cameraController = createController(cameras[0]);

    cameraController.initialize().then(
      (value) {
        controllerIsInitialized = true;

        setState(() {});
      },
    );

    flashButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    cameraButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    switchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    orientationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

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
    setSystemUI();

    setDefaultOrientation();

    Navigator.of(context).pop();
  }

  void pushColorsDetected(XFile pictureXFile) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          getIt<TensorCubit>().setPicture(pictureXFile);

          setSystemUI();

          setDefaultOrientation();

          return const ColorsDetectedScreen();
        },
      ),
    );
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
    );
  }
}
