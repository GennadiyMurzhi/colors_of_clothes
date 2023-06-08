import 'dart:ui';

import 'package:colors_of_clothes/app/gallery_cubit/gallery_cubit.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/global.dart';
import 'package:colors_of_clothes/ui/camera/camera_screen.dart';
import 'package:colors_of_clothes/ui/home/widgets/button_widget.dart';
import 'package:colors_of_clothes/ui/home/widgets/camera_and_gallery_buttons_widget.dart';
import 'package:colors_of_clothes/ui/home/widgets/caption_widget.dart';
import 'package:colors_of_clothes/ui/home/widgets/clippers.dart';
import 'package:colors_of_clothes/ui/home/widgets/gallery_widget.dart';
import 'package:colors_of_clothes/ui/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin implements RouteAware {
  late AnimationController galleryAnimationController;
  late ScrollController galleryScrollController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });

    galleryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    galleryScrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    galleryAnimationController.dispose();
    galleryScrollController.dispose();

    super.dispose();
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

  void openGallery(double height) {
    BlocProvider.of<GalleryCubit>(context).openGallery();
    galleryScrollController.jumpTo(height * 0.5);
    galleryAnimationController.animateTo(
      1,
      curve: Curves.easeOutBack,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height - MediaQuery.of(context).padding.top;

    const double bigButtonSize = 100;

    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) async {
        if (details.delta.dy < -10) {
          openGallery(height);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: AnimatedBuilder(
            animation: galleryAnimationController,
            builder: (BuildContext context, Widget? child) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox.fromSize(
                    size: MediaQuery.of(context).size,
                  ),
                  Positioned(
                    top: 2,
                    left: 3,
                    child: GradientButtonWidget(
                      width: 37,
                      height: 30,
                      padding: const EdgeInsets.all(20),
                      clipper: MenuButtonClipper(),
                      onTap: () {},
                    ),
                  ),
                  Positioned(
                    top: height / 2 - bigButtonSize * 0.7,
                    child: Column(
                      children: <Widget>[
                        CameraAndGalleryButtonsWidget(
                          buttonSize: bigButtonSize,
                          buttonPadding: const EdgeInsets.all(25),
                          onTapCameraButton: () {
                            Navigator.push(
                              context,
                              buildRoute(const CameraScreen()),
                            );
                          },
                          onTapGalleryButton: () {
                            openGallery(height);
                          },
                        ),
                        const SizedBox(height: 40),
                        const CaptionWidget(),
                      ],
                    ),
                  ),
                  if (galleryAnimationController.value != 0)
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2 * galleryAnimationController.value,
                        sigmaY: 2 * galleryAnimationController.value,
                      ),
                      child: SizedBox.fromSize(
                        size: MediaQuery.of(context).size,
                      ),
                    ),
                  Positioned(
                    top: height * (1 - galleryAnimationController.value),
                    child: GalleryWidget(
                      galleryAnimationController: galleryAnimationController,
                      scrollController: galleryScrollController,
                      size: size,
                      height: height,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
