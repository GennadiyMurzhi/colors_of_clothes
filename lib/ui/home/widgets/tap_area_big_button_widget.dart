import 'package:flutter/material.dart';

class TapAreaBigButtonWidget extends StatelessWidget {
  const TapAreaBigButtonWidget({
    super.key,
    required this.width,
    required this.onTap,
    required this.child,
  });

  final double width;
  final Function() onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
