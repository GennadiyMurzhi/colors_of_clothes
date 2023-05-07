import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class GradientWidget extends StatefulWidget {
  const GradientWidget({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<GradientWidget> createState() => _GradientState();
}

class _GradientState extends State<GradientWidget> with TickerProviderStateMixin {
  late AnimationController _controller;

  final List<Color> _colors = const [
    Color(0xFF658E99),
    Color(0xFFFF554C),
    Color(0xFFCC3769),
  ];
  int _primaryColorIndex = 0;
  int _secondaryColorIndex = 1;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addListener(() {
        if (_controller.value == 1) {
          if (_primaryColorIndex != _colors.length - 1) {
            _primaryColorIndex++;
          } else {
            _primaryColorIndex = 0;
          }

          setState(() {});

          _controller.animateBack(0);
        }

        if (_controller.value == 0) {
          if (_secondaryColorIndex != _colors.length - 1) {
            _secondaryColorIndex++;
          } else {
            _secondaryColorIndex = 0;
          }

          setState(() {});

          _controller.animateTo(1);
        }
      })
      ..animateTo(1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimateGradient(
      key: UniqueKey(),
      controller: _controller,
      primaryColors: <Color>[
        _colors[_primaryColorIndex],
        const Color(0xFFCC3769),
      ],
      secondaryColors: <Color>[
        const Color(0xFFCC3769),
        _colors[_secondaryColorIndex],
      ],
      child: widget.child,
    );
  }
}
