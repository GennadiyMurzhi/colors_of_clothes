import 'package:colors_of_clothes/ui/home/widgets/clippers.dart';
import 'package:colors_of_clothes/ui/home/widgets/gradient_widget.dart';
import 'package:flutter/material.dart';

class CaptionWidget extends StatefulWidget {
  const CaptionWidget({super.key});

  @override
  State<CaptionWidget> createState() => _CaptionState();
}

class _CaptionState extends State<CaptionWidget> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
    )..animateTo(
        1,
        duration: const Duration(seconds: 2),
      );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Determine your colors by taking a photo or by simply selecting from the device',
      verticalOffset: 40,
      height: 25,
      triggerMode: TooltipTriggerMode.tap,
      textAlign: TextAlign.center,
      textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
      showDuration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: Container(
        width: 284.4,
        height: 34,
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: _controller.value,
              child: ClipPath(
                clipper: CaptionClipper(),
                child: const SizedBox(
                  width: 284.4,
                  height: 34,
                  child: GradientWidget(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
