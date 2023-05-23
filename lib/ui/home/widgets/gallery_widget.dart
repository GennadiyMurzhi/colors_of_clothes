import 'package:colors_of_clothes/app/gallery_cubit/gallery_cubit.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/domen/gallery_album.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/colors_detected/colors_detected_screen.dart';
import 'package:colors_of_clothes/ui/home/widgets/scrollbar_disappearing.dart';
import 'package:colors_of_clothes/ui/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({
    super.key,
    required this.galleryAnimationController,
    required this.scrollController,
    required this.size,
    required this.height,
  });

  final AnimationController galleryAnimationController;
  final ScrollController scrollController;
  final Size size;
  final double height;

  @override
  State<StatefulWidget> createState() => _GalleryState();
}

class _GalleryState extends State<GalleryWidget> {
  final double startHeaderHeight = 30;
  late double headerHeight;
  final double spacing = 3;
  final double backButtonWidth = 50;
  double radius = 15;
  double opacity = 1;
  bool isClosing = false;
  bool ignoringHeaderButtons = true;
  bool isCustomEndPositionScrolling = false;
  bool isNeededScrollbar = false;

  @override
  void initState() {
    headerHeight = startHeaderHeight;

    super.initState();
  }

  Future<void> closeGalleryWithAnimation() async {
    isClosing = true;
    await widget.galleryAnimationController.animateBack(
      0,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 300),
    );
    widget.scrollController.jumpTo(0);
    isClosing = false;
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
      if (headerHeight != startHeaderHeight) {
        headerHeight = startHeaderHeight;
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
      if (headerHeight != startHeaderHeight * 2) {
        headerHeight = startHeaderHeight * 2;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notification is ScrollEndNotification &&
          notification.metrics.pixels >= widget.height * 0.9 &&
          notification.metrics.pixels <= widget.height) {
        ignoringHeaderButtons = false;
        widget.scrollController
            .animateTo(
              widget.height,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
      } else if (notification.metrics.pixels >= widget.height * 0.9 && notification.metrics.pixels <= widget.height) {
        final double deleteIndex = (1 - (notification.metrics.pixels / (widget.height / 100) / 100)) * 10;
        final double headerIndex = 2 - (1 - (notification.metrics.pixels / (widget.height / 100) / 100)) * 10;
        setState(() {
          radius = 10 * deleteIndex;
          headerHeight = startHeaderHeight * headerIndex;
          opacity = 1 * deleteIndex;
        });
      }
    });
  }

  void changeIgnoringCloseButton(ScrollNotification notification) {
    if (notification.metrics.pixels >= widget.height && ignoringHeaderButtons != false) {
      ignoringHeaderButtons = false;
    } else if (notification.metrics.pixels <= widget.height && ignoringHeaderButtons != true) {
      ignoringHeaderButtons = true;
    }
  }

  void changeScrollbar(ScrollNotification notification) {
    if (notification.metrics.pixels >= widget.height && !isNeededScrollbar) {
      setState(() {
        isNeededScrollbar = true;
      });
    }
    if (notification.metrics.pixels <= widget.height && isNeededScrollbar) {
      setState(() {
        isNeededScrollbar = false;
      });
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
            changeScrollbar(notification);

            closeGallery(notification);

            return true;
          },
          child: ScrollConfiguration(
            behavior: DeleteGlowBehavior(),
            child: ScrollbarDisappearing(
              isNeeded: isNeededScrollbar,
              child: BlocBuilder<GalleryCubit, GalleryState>(
                builder: (BuildContext context, GalleryState state) {
                  final double childrenHeight;
                  if (!state.isLoading) {
                    final int childCount = state.galleryAlbums.albums[state.selectedAlbumIndex].entities.length;
                    childrenHeight = (childCount < 3 ? 1 : childCount / 3) * (widget.size.width / 3);
                  } else {
                    childrenHeight = 0;
                  }

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
                                    child: IgnorePointer(
                                      ignoring: ignoringHeaderButtons,
                                      child: Row(
                                        children: <Widget>[
                                          BackButton(
                                            onPressed: () {
                                              closeGalleryWithAnimation();
                                            },
                                          ),
                                          if (!state.isLoading)
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
                                                    widget.scrollController.jumpTo(widget.height);
                                                    BlocProvider.of<GalleryCubit>(context).loadAlbum(
                                                      albumId: album.assetPathEntity != null
                                                          ? album.assetPathEntity!.id
                                                          : null,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
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
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              width: widget.size.width,
                            ),
                          ),
                          if (!state.isLoading)
                            SliverPadding(
                              padding: EdgeInsets.all(spacing),
                              sliver: SliverGrid(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: spacing,
                                  crossAxisSpacing: spacing,
                                  crossAxisCount: 3,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return state.galleryAlbums.albums[state.selectedAlbumIndex].entitiesFiles != null &&
                                            index <=
                                                state.galleryAlbums.albums[state.selectedAlbumIndex].entitiesFiles!
                                                        .length -
                                                    1
                                        ? Stack(
                                            children: <Widget>[
                                              Positioned.fill(
                                                child: Image.file(
                                                  state.galleryAlbums.albums[state.selectedAlbumIndex]
                                                      .entitiesFiles![index],
                                                  cacheWidth: widget.size.width ~/ 3,
                                                  fit: BoxFit.cover,
                                                  frameBuilder: (BuildContext context, Widget child, int? frame,
                                                      bool wasSynchronouslyLoaded) {
                                                    if (wasSynchronouslyLoaded) {
                                                      return child;
                                                    }
                                                    return AnimatedOpacity(
                                                      opacity: frame == null ? 0 : 1,
                                                      duration: const Duration(milliseconds: 700),
                                                      curve: Curves.easeInCubic,
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    getIt<TensorCubit>().setPicture(state.galleryAlbums
                                                        .albums[state.selectedAlbumIndex].entitiesFiles![index]);

                                                    Navigator.push(
                                                      context,
                                                      buildRoute(const ColorsDetectedScreen()),
                                                    );
                                                    closeGalleryWithAnimation();
                                                  },
                                                  child: Container(
                                                    width: widget.size.width / 3 - spacing,
                                                    height: widget.size.width / 3 - spacing,
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : SizedBox(
                                            width: widget.size.width / 3,
                                            height: widget.size.width / 3,
                                          );
                                  },
                                  childCount: state.galleryAlbums.albums[state.selectedAlbumIndex].entities.length,
                                ),
                              ),
                            )
                          else
                            SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: widget.height / 6),
                                  child: Text(
                                    'Loading ...\n So many pics 🤗',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleLarge,
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
                            color: Theme.of(context).colorScheme.secondaryContainer,
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
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
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
