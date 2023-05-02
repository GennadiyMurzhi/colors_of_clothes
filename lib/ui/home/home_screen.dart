import 'package:colors_of_clothes/app/gallery_cubit/gallery_cubit.dart';
import 'package:colors_of_clothes/ui/camera/camera_screen.dart';
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

  void openGallery(double jumpTo) {
    BlocProvider.of<GalleryCubit>(context).openGallery();
    galleryScrollController.jumpTo(jumpTo);
    galleryAnimationController.animateTo(
      1,
      curve: Curves.easeOutBack,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final Size size = MediaQuery.of(context).size;
    const double headerHeight = 30;
    final double height = size.height - MediaQuery.of(context).padding.top;

    return BlocBuilder<GalleryCubit, GalleryState>(builder: (BuildContext context, GalleryState state) {
      return GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) async {
          if (details.delta.dy < -10 && !state.isOpen) {
            openGallery(height * 0.5);
          }
        },
        child: Scaffold(
          body: AnimatedBuilder(
            animation: galleryAnimationController,
            builder: (BuildContext context, Widget? child) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox.fromSize(
                    size: MediaQuery.of(context).size,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              buildRoute(const CameraScreen()),
                            );
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            openGallery(height * 0.5);
                          },
                          icon: const Icon(
                            Icons.image_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: height * (1 - galleryAnimationController.value),
                    child: GalleryWidget(
                      galleryAnimationController: galleryAnimationController,
                      animationValue: galleryAnimationController.value,
                      photoFiles: state.photoFiles,
                      isGrantedPhotos: state.isGrantedPhotos,
                      isLoading: state.isLoading,
                      scrollController: galleryScrollController,
                      size: size,
                      height: height,
                      headerHeight: headerHeight,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}
