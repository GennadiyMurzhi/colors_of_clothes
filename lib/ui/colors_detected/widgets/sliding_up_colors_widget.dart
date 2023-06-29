import 'package:colors_of_clothes/app/colors_detected_cubit/colors_detected_cubit.dart';
import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/compatible_colors/compatible_colors_widget.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/determined_colors/determined_colors_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SlidingUpColorsWidget extends StatefulWidget {
  const SlidingUpColorsWidget({
    super.key,
    required this.circleSize,
    required this.compatibleDeterminedColors,
    required this.isDisplayingInfo,
    required this.selectedPixelIndex,
    required this.selectPixel,
    required this.sideAnimationFirstValue,
    required this.sideAnimationSecondValue,
    required this.position,
    required this.circleBorderWidth,
    required this.width,
    required this.height,
    required this.offsetTransition,
    required this.determinedColorsWidgetHeight,
    required this.slidingUpColorsWidgetTopPadding,
    required this.slidingUpColorsWidgetOpenIconSize,
    required this.isExpanded,
  });

  final double circleSize;
  final CompatibleColorsList compatibleDeterminedColors;
  final int? selectedPixelIndex;
  final bool isDisplayingInfo;
  final void Function(int indexPixel) selectPixel;
  final double sideAnimationFirstValue;
  final double sideAnimationSecondValue;
  final double position;
  final double circleBorderWidth;
  final double width;
  final double height;
  final double offsetTransition;
  final double determinedColorsWidgetHeight;
  final double slidingUpColorsWidgetTopPadding;
  final double slidingUpColorsWidgetOpenIconSize;
  final bool isExpanded;

  @override
  State<StatefulWidget> createState() => _SlidingUpColorsState();
}

class _SlidingUpColorsState extends State<SlidingUpColorsWidget> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween(
      begin: Offset.zero,
      end: Offset(0, widget.offsetTransition),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalSymmetricPadding = 15;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return SlideTransition(
          position: _offsetAnimation,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: widget.compatibleDeterminedColors.list.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onVerticalDragEnd: (DragEndDetails details) {
                          if (details.velocity.pixelsPerSecond.dy <= 0) {
                            if (!widget.isExpanded) {
                              _animationController.animateTo(1);
                              BlocProvider.of<ColorsDetectedCubit>(context).switchExpanded(true);
                            }
                          } else {
                            if (widget.isExpanded) {
                              _animationController.animateBack(0);
                              BlocProvider.of<ColorsDetectedCubit>(context).switchExpanded(false);
                            }
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: widget.width,
                              height: widget.slidingUpColorsWidgetOpenIconSize + widget.slidingUpColorsWidgetTopPadding,
                              color: Colors.transparent,
                              child: Icon(
                                widget.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                              ),
                            ),
                            DeterminedColorsWidget(
                              circleSize: widget.circleSize,
                              compatibleDeterminedColors: widget.compatibleDeterminedColors.list,
                              selectedPixelIndex: widget.selectedPixelIndex,
                              selectPixel: widget.selectPixel,
                              isDisplayingInfo: true,
                              sideAnimationFirstValue: widget.sideAnimationFirstValue,
                              sideAnimationSecondValue: widget.sideAnimationSecondValue,
                              circleBorderWidth: widget.circleBorderWidth,
                              determinedColorsWidgetHeight: widget.determinedColorsWidgetHeight,
                              horizontalSymmetricPadding: horizontalSymmetricPadding,
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: CompatibleColorsWidget(
                          compatibleColors: widget.selectedPixelIndex != null
                              ? widget.compatibleDeterminedColors.list[widget.selectedPixelIndex!]
                              : null,
                          horizontalSymmetricPadding: horizontalSymmetricPadding,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'There is no person in the photo',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ),
        );
      },
    );
  }
}
