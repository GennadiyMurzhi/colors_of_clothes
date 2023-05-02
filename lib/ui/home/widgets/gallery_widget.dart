import 'dart:io';

import 'package:colors_of_clothes/app/gallery_cubit/gallery_cubit.dart';
import 'package:colors_of_clothes/domen/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

class GalleryWidget extends StatefulWidget {
  GalleryWidget({
    super.key,
    required this.photoFiles,
    required this.animationValue,
    required this.isGrantedPhotos,
    required this.isLoading,
    required this.galleryAnimationController,
    required this.scrollController,
    required this.size,
    required this.height,
    required this.headerHeight,
  });

  final List<File> photoFiles;
  final double animationValue;
  final bool isGrantedPhotos;
  final bool isLoading;
  final AnimationController galleryAnimationController;
  final ScrollController scrollController;
  final Size size;
  final double height;
  final double headerHeight;

  @override
  State<StatefulWidget> createState() => _GalleryState();
}

class _GalleryState extends State<GalleryWidget> {
  late double headerHeight;
  final double spacing = 6;
  double radius = 15;
  double opacity = 1;
  bool isClosingByEmptySliver = false;
  bool ignoringCloseButton = true;

  @override
  void initState() {
    super.initState();

    headerHeight = widget.headerHeight;
  }

  Future<void> closeGalleryWithAnimation(void Function() closeGallery) async {
    isClosingByEmptySliver = true;
    await widget.galleryAnimationController.animateBack(
      0,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
    widget.scrollController.jumpTo(0);
    isClosingByEmptySliver = false;
    closeGallery();
  }

  // onNotification
  void changeHeaderIfCollapsed(ScrollNotification notification) {
    if (notification.metrics.pixels < widget.height * 0.9) {
      bool changed = false;
      if (radius != 10) {
        radius = 10;
        changed = true;
      }
      if (opacity != 1) {
        opacity = 1;
        if (!changed) {
          changed = true;
        }
      }
      if (headerHeight != widget.headerHeight) {
        headerHeight = widget.headerHeight;
        if (!changed) {
          changed = true;
        }
      }
      if (changed) {
        setState(() {});
      }
    }
  }

  void changeHeaderIfExpanded(ScrollNotification notification) {
    if (notification.metrics.pixels >= widget.height) {
      bool changed = false;
      if (radius != 0) {
        radius = 0;
        changed = true;
      }
      if (opacity != 0) {
        opacity = 0;
        if (!changed) {
          changed = true;
        }
      }
      if (headerHeight != widget.headerHeight * 2) {
        headerHeight = widget.headerHeight * 2;
        if (!changed) {
          changed = true;
        }
      }
      if (changed) {
        setState(() {});
      }
    }
  }

  void changeHeaderOnScroll(ScrollNotification notification) {
    if (notification.metrics.pixels >= widget.height * 0.9 && notification.metrics.pixels <= widget.height) {
      final double deleteIndex = (1 - (notification.metrics.pixels / (widget.height / 100) / 100)) * 10;
      final double headerIndex = 2 - (1 - (notification.metrics.pixels / (widget.height / 100) / 100)) * 10;
      setState(() {
        radius = 10 * deleteIndex;
        headerHeight = widget.headerHeight * headerIndex;
        opacity = 1 * deleteIndex;
      });

      print('deleteIndex: $deleteIndex');
      print('radiusIndex: $headerIndex');
    }
  }

  void changeIgnoringCloseButton(ScrollNotification notification) {
    if (notification.metrics.pixels >= widget.height * 0.95 && ignoringCloseButton != false) {
      ignoringCloseButton = false;
    } else if (notification.metrics.pixels <= widget.height * 0.95 && ignoringCloseButton != true) {
      ignoringCloseButton = true;
    }
  }

  void customEndPosition(ScrollNotification notification) {
    if (!isClosingByEmptySliver &&
        notification is ScrollUpdateNotification &&
        widget.scrollController.position.activity != null &&
        widget.scrollController.position.activity!.velocity <= 0 &&
        notification.metrics.pixels >= widget.height * 0.5) {
      final double velocity = widget.scrollController.position.activity!.velocity.abs();
      final double distance = (widget.height * 0.5 - notification.metrics.pixels).abs();

      if (velocity > distance) {
        widget.scrollController.animateTo(
          widget.height * 0.5,
          curve: Curves.linear,
          duration: calculateScrollTime(distance: distance, velocity: velocity),
        );
      }
    }
  }

  void closeGallery(ScrollNotification notification) {
    if (notification is ScrollEndNotification && notification.metrics.pixels < widget.height * 0.5) {
      closeGalleryWithAnimation(BlocProvider.of<GalleryCubit>(context).closeGallery);
    }

    if (notification is ScrollUpdateNotification && notification.metrics.pixels == 0) {
      BlocProvider.of<GalleryCubit>(context).closeGallery();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: widget.size.width,
        height: widget.height * 2,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            changeHeaderIfCollapsed(notification);
            changeHeaderIfExpanded(notification);
            changeHeaderOnScroll(notification);
            changeIgnoringCloseButton(notification);
            customEndPosition(notification);
            closeGallery(notification);

            return true;
          },
          child: ScrollConfiguration(
            behavior: DeleteGlowBehavior(),
            child: Scrollbar(
              child: CustomScrollView(
                controller: widget.scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onHorizontalDragStart: (DragStartDetails dragStartDetails) {
                        closeGalleryWithAnimation(BlocProvider.of<GalleryCubit>(context).closeGallery);
                      },
                      onVerticalDragStart: (DragStartDetails dragStartDetails) {
                        closeGalleryWithAnimation(BlocProvider.of<GalleryCubit>(context).closeGallery);
                      },
                      onTap: () {
                        closeGalleryWithAnimation(BlocProvider.of<GalleryCubit>(context).closeGallery);
                      },
                      onLongPressStart: (LongPressStartDetails details) {
                        closeGalleryWithAnimation(BlocProvider.of<GalleryCubit>(context).closeGallery);
                      },
                      child: Container(
                        width: widget.size.width,
                        height: widget.height,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: HeaderDelegate(
                      width: widget.size.width,
                      height: headerHeight,
                      radius: radius,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AnimatedOpacity(
                            opacity: 1 - opacity,
                            duration: const Duration(milliseconds: 5),
                            child: SizedBox(
                              width: 81,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IgnorePointer(
                                    ignoring: ignoringCloseButton,
                                    child: BackButton(
                                      onPressed: () {
                                        closeGalleryWithAnimation(BlocProvider.of<GalleryCubit>(context).closeGallery);
                                      },
                                    ),
                                  ),
                                  const Text('Album'),
                                ],
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: opacity,
                            duration: const Duration(milliseconds: 5),
                            child: Container(
                              width: 30,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 81),
                        ],
                      ),
                    ),
                  ),
                  SliverStack(
                    children: <Widget>[
                      SliverPositioned.fill(
                        child: Container(
                          color: Colors.grey,
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: spacing),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: spacing,
                            crossAxisSpacing: spacing,
                            crossAxisCount: 3,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  print('tap image: $index');
                                },
                                child: Image.file(
                                  widget.photoFiles[index],
                                  cacheWidth: 100,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                            childCount: widget.photoFiles.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  const HeaderDelegate({
    required this.width,
    required this.height,
    required this.radius,
    required this.child,
  });

  final double width;
  final double height;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
        ),
        alignment: Alignment.center,
        child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class DeleteGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
