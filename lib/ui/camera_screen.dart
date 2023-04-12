import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/colors_detected_cubit/colors_detected_cubit.dart';
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

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool _isDisabledPhotoButton = false;

  @override
  void initState() {
    super.initState();

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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _takePictureAndOpenPhoto(XFile pictureXFile) {
    _isDisabledPhotoButton = true;
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

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
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
              alignment: Alignment.center,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                onTap: () async {
                  if (!_isDisabledPhotoButton) {
                    XFile pictureXFile = await controller.takePicture();
                    _takePictureAndOpenPhoto(pictureXFile);
                  }
                },
                child: const Icon(
                  Icons.circle_outlined,
                  color: Colors.white70,
                  size: 80,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
