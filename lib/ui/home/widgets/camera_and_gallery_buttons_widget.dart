import 'package:colors_of_clothes/ui/home/widgets/button_widget.dart';
import 'package:colors_of_clothes/ui/home/widgets/clippers.dart';
import 'package:flutter/cupertino.dart';

class CameraAndGalleryButtonsWidget extends StatefulWidget {
  const CameraAndGalleryButtonsWidget({
    super.key,
    required this.onTapCameraButton,
    required this.onTapGalleryButton,
    required this.buttonSize,
  });

  final double buttonSize;
  final void Function() onTapCameraButton;
  final void Function() onTapGalleryButton;

  @override
  State<StatefulWidget> createState() => _CameraAndGalleryButtonsState();
}

class _CameraAndGalleryButtonsState extends State<CameraAndGalleryButtonsWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
    )..animateTo(
        1,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInCubic,
      );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0,
          0.7,
          curve: Curves.linear,
        ),
      ),
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
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, widget.buttonSize / 2 * (1 - _controller.value)),
            child: Row(
              children: <Widget>[
                GradientButtonWidget(
                  width: widget.buttonSize,
                  onTap: widget.onTapCameraButton,
                  clipper: CameraButtonClipper(),
                ),
                const SizedBox(width: 50),
                GradientButtonWidget(
                  width: widget.buttonSize,
                  onTap: widget.onTapGalleryButton,
                  clipper: GalleryButtonClipper(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
