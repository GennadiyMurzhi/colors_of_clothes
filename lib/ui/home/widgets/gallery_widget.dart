import 'package:colors_of_clothes/app/gallery_cubit/gallery_cubit.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/domen/gallery_album.dart';
import 'package:colors_of_clothes/domen/ui_utils.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/colors_detected/colors_detected_screen.dart';
import 'package:colors_of_clothes/ui/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({
    super.key,
    required this.animationValue,
    required this.galleryAnimationController,
    required this.scrollController,
    required this.size,
    required this.height,
    required this.headerHeight,
  });

  final double animationValue;
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
  final double backButtonWidth = 50;

  double radius = 15;
  double opacity = 1;
  bool isClosingByEmptySliver = false;
  bool ignoringCloseButton = true;

  @override
  void initState() {
    super.initState();

    headerHeight = widget.headerHeight;
  }

  Future<void> closeGalleryWithAnimation() async {
    isClosingByEmptySliver = true;
    await widget.galleryAnimationController.animateBack(
      0,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
    widget.scrollController.jumpTo(0);
    isClosingByEmptySliver = false;
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
      closeGalleryWithAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: widget.size.width,
        height: widget.height,
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
              child: BlocBuilder<GalleryCubit, GalleryState>(
                builder: (BuildContext context, GalleryState state) {
                  final int childCount = state.galleryAlbums.albums[state.selectedAlbumIndex].entities.length;
                  final double childrenHeight = (childCount < 3 ? 1 : childCount / 3) * (widget.size.width / 3);

                  print('childCount: $childCount');
                  print('childrenHeight: $childrenHeight');
                  print('widget.height - childrenHeight: ${widget.height - childrenHeight}');

                  return CustomScrollView(
                    controller: widget.scrollController,
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onHorizontalDragStart: (DragStartDetails dragStartDetails) {
                            closeGalleryWithAnimation();
                          },
                          onVerticalDragStart: (DragStartDetails dragStartDetails) {
                            closeGalleryWithAnimation();
                          },
                          onTap: () {
                            closeGalleryWithAnimation();
                          },
                          onLongPressStart: (LongPressStartDetails details) {
                            closeGalleryWithAnimation();
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
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AnimatedOpacity(
                                    opacity: 1 - opacity,
                                    duration: const Duration(milliseconds: 5),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        IgnorePointer(
                                          ignoring: ignoringCloseButton,
                                          child: BackButton(
                                            onPressed: () {
                                              closeGalleryWithAnimation();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: widget.size.width - 50,
                                          child: DropdownButton(
                                            isDense: false,
                                            isExpanded: true,
                                            value: state.galleryAlbums.albums[state.selectedAlbumIndex],
                                            items: state.galleryAlbums.albums
                                                .map<DropdownMenuItem<GalleryAlbum>>(
                                                  (GalleryAlbum album) => DropdownMenuItem<GalleryAlbum>(
                                                    value: album,
                                                    child: Text(
                                                      album.assetPathEntity == null
                                                          ? 'All'
                                                          : album.assetPathEntity!.name,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (GalleryAlbum? album) {
                                              if (album != null) {
                                                BlocProvider.of<GalleryCubit>(context)
                                                    .loadAlbum(
                                                      albumId: album.assetPathEntity != null
                                                          ? album.assetPathEntity!.id
                                                          : null,
                                                    )
                                                    .whenComplete(() => setState(() {}));
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: AnimatedOpacity(
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverStack(
                        children: <Widget>[
                          SliverPositioned.fill(
                            child: Container(
                              color: Colors.grey,
                              width: widget.size.width,
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.all(spacing),
                            sliver: SliverGrid(
                              key: UniqueKey(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: spacing,
                                crossAxisSpacing: spacing,
                                crossAxisCount: 3,
                              ),
                              delegate: SliverChildListDelegate(
                                List<Widget>.generate(
                                  state.galleryAlbums.albums[state.selectedAlbumIndex].entities.length,
                                  (int index) => state.galleryAlbums.albums[state.selectedAlbumIndex].entitiesFiles !=
                                              null &&
                                          index <=
                                              state.galleryAlbums.albums[state.selectedAlbumIndex].entitiesFiles!
                                                      .length -
                                                  1
                                      ? GestureDetector(
                                          onTap: () {
                                            getIt<TensorCubit>().setPicture(state
                                                .galleryAlbums.albums[state.selectedAlbumIndex].entitiesFiles![index]);

                                            Navigator.push(
                                              context,
                                              buildRoute(const ColorsDetectedScreen()),
                                            );
                                            closeGalleryWithAnimation();
                                          },
                                          child: Image.file(
                                            state.galleryAlbums.albums[state.selectedAlbumIndex].entitiesFiles![index],
                                            cacheWidth: widget.size.width ~/ 3,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : SizedBox(
                                          width: widget.size.width / 3,
                                          height: widget.size.width / 3,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (childrenHeight < widget.height)
                        SliverToBoxAdapter(
                          child: Container(
                            width: widget.size.width,
                            height: widget.height - childrenHeight - headerHeight,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  );
                },
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
