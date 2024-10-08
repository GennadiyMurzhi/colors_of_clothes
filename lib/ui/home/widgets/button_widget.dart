import 'package:colors_of_clothes/ui/home/widgets/gradient_widget.dart';
import 'package:flutter/material.dart';

class GradientButtonWidget extends StatelessWidget {
  const GradientButtonWidget({
    super.key,
    required this.width,
    this.height,
    this.padding,
    required this.onTap,
    required this.clipper,
  });

  final double width;
  final double? height;
  final EdgeInsets? padding;
  final void Function() onTap;
  final CustomClipper<Path> clipper;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(width / 2),
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.all(width / 3),
        child: SizedBox(
          width: width,
          height: height ?? width,
          child: ClipPath(
            clipper: clipper,
            child: const GradientWidget(),
          ),
        ),
      ),
    );
  }
}
