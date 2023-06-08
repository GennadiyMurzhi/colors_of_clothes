import 'dart:math';

import 'package:flutter/cupertino.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    super.key,
    required this.circleSize,
    required this.color,
    required this.offset,
    required this.rotateIndex,
  });

  final double circleSize;
  final Color color;
  final Offset offset;
  final int rotateIndex;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 2 * rotateIndex,
      child: Transform.translate(
        offset: offset,
        child: Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
