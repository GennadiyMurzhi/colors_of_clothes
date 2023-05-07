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
    return AnimatedBuilder(
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
    );
  }
}
