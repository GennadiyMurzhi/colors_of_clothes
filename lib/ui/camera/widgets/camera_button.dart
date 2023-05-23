import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    const double outsideButtonSize = 80;
    const double innerButtonSize = outsideButtonSize - 15;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
          width: outsideButtonSize,
          height: outsideButtonSize,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: Colors.white,
            ),
          ),
        ),
        ClipOval(
          child: SizedBox(
            width: innerButtonSize,
            height: innerButtonSize,
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: onTap,
                splashColor: Colors.transparent,
                highlightColor: Colors.grey,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}