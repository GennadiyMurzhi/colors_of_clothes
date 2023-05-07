import 'package:colors_of_clothes/app/gallery_cubit/gallery_cubit.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController galleryAnimationController;
  late ScrollController galleryScrollController;

  @override
  void initState() {
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

    const double bigButtonSize = 80;

    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) async {
        if (details.delta.dy < -10) {
          openGallery(height);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE6E6E6),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: galleryAnimationController,
            builder: (BuildContext context, Widget? child) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: 15,
                    left: 15,
                    child: GradientButtonWidget(
                      width: 35,
                      height: 30,
                      clipper: MenuButtonClipper(),
                      onTap: () {},
                    ),
                  ),
                  SizedBox.fromSize(
                    size: MediaQuery.of(context).size,
                  ),
                  Positioned(
                    top: height / 2 - bigButtonSize,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CameraAndGalleryButtonsWidget(
                            buttonSize: bigButtonSize,
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
                        ),
                        const SizedBox(height: 70),
                        const CaptionWidget(),
                      ],
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
