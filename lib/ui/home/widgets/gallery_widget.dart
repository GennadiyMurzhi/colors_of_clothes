import 'dart:io';

import 'package:colors_of_clothes/app/gallery_cubit/gallery_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryWidget extends StatelessWidget {
  const GalleryWidget({
    super.key,
    required this.photoFiles,
    required this.animationValue,
    required this.isGrantedPhotos,
    required this.isLoading,
    required this.galleryAnimationController,
    required this.physics,
  });

  final List<File> photoFiles;
  final double animationValue;
  final bool isGrantedPhotos;
  final bool isLoading;
  final AnimationController galleryAnimationController;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    const Radius radius = Radius.circular(15);
    final double height = size.height - statusBarHeight;
    const double spacing = 6;

    print(physics);

    return Positioned(
      bottom: -height + height * animationValue,
      child: Container(
        width: size.width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: spacing),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: radius,
            topRight: radius,
          ),
        ),
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (galleryAnimationController.value == 1 && details.delta.dy <= 0) {
              BlocProvider.of<GalleryCubit>(context).setPhysics(null);
            } else {
              galleryAnimationController.value =
                  1 - ((details.globalPosition.dy - statusBarHeight - 25) / (height / 100)) * 0.01;
              if (galleryAnimationController.value != 1 && details.delta.dy > 0 && physics == null) {
                BlocProvider.of<GalleryCubit>(context).setPhysics(const NeverScrollableScrollPhysics());
              }
            }
            print('details.delta.dy: ${details.delta.dy}');
          },
          onVerticalDragEnd: (DragEndDetails details) {
            if (galleryAnimationController.value < 0.5) {
              BlocProvider.of<GalleryCubit>(context).closeGallery(galleryAnimationController.animateBack);
            }
            if (details.primaryVelocity! > 1000 && galleryAnimationController.value > 0.5) {
              galleryAnimationController.animateBack(0.5, curve: Curves.easeIn);
            }
            if (details.primaryVelocity! < -1000 && galleryAnimationController.value > 0.5) {
              galleryAnimationController.animateTo(1, curve: Curves.easeIn);
            }

            print('${details.primaryVelocity}');
            print('${details.velocity.pixelsPerSecond}');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Container(
                  width: 30,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              isGrantedPhotos
                  ? SizedBox(
                      height: height - 50,
                      child: BlocBuilder<GalleryCubit, GalleryState>(
                        builder: (BuildContext context, GalleryState state) {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification overscroll) {
                              print('overscroll.metrics.pixels: ${overscroll.metrics.pixels}');
                              // if (overscroll.metrics.pixels == 0 && physics == null) {
                              //   BlocProvider.of<GalleryCubit>(context).setPhysics(const NeverScrollableScrollPhysics());
                              // }

                              return true;
                            },
                            child: GridView.count(
                              physics: physics,
                              padding: EdgeInsets.zero,
                              clipBehavior: Clip.antiAlias,
                              crossAxisCount: 3,
                              mainAxisSpacing: spacing,
                              crossAxisSpacing: spacing,
                              children: List<Widget>.generate(
                                photoFiles.length,
                                (int index) => GestureDetector(
                                  onTap: () {
                                    print('tap image: $index');
                                  },
                                  child: Image.file(
                                    photoFiles[index],
                                    cacheWidth: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text('No granted photos...'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
