import 'dart:async';
import 'dart:io';

import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/global.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/colors_detected/colors_detected_screen.dart';
import 'package:colors_of_clothes/ui/home/widgets/button_widget.dart';
import 'package:colors_of_clothes/ui/home/widgets/camera_and_gallery_buttons_widget.dart';
import 'package:colors_of_clothes/ui/home/widgets/caption_widget.dart';
import 'package:colors_of_clothes/ui/home/widgets/clippers.dart';
import 'package:colors_of_clothes/ui/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements RouteAware {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });

    super.initState();
  }

  @override
  void didPop() {
    BlocProvider.of<TensorCubit>(context).setInitial();
  }

  @override
  void didPopNext() {}

  @override
  void didPush() {}

  @override
  void didPushNext() {}

  Future<void> pickPictureAndPush(ImageSource imageSource) async {
    final XFile? pictureXFile = await getIt<ImagePicker>().pickImage(
      source: imageSource,
      imageQuality: 50,
      requestFullMetadata: false,
    );
    if (context.mounted && pictureXFile != null) {
      final File pictureFile = File(pictureXFile.path);

      BlocProvider.of<TensorCubit>(context).setPicture(pictureFile);

      Navigator.push(
        context,
        buildRoute(const ColorsDetectedScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double bigButtonSize = 100;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: GradientButtonWidget(
                width: 37,
                height: 30,
                padding: const EdgeInsets.all(20),
                clipper: MenuButtonClipper(),
                onTap: () {},
              ),
            ),
            const Spacer(flex: 3),
            Column(
              children: <Widget>[
                CameraAndGalleryButtonsWidget(
                  buttonSize: bigButtonSize,
                  buttonPadding: const EdgeInsets.all(25),
                  onTapCameraButton: () {
                    pickPictureAndPush(ImageSource.camera);
                  },
                  onTapGalleryButton: () {
                    pickPictureAndPush(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 40),
                const CaptionWidget(),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
