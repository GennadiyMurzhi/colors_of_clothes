import 'package:colors_of_clothes/ui/colors_detected/widgets/determined_colors/color_info_widget.dart';
import 'package:flutter/material.dart';

class DeterminedColorWidget extends StatelessWidget {
  const DeterminedColorWidget({
    super.key,
    required this.selectPixel,
    required this.colorContainerSize,
    required this.color,
    required this.isSelected,
    required this.compatible,
    required this.isDisplayingInfo,
  });

  final void Function() selectPixel;
  final double colorContainerSize;
  final Color color;
  final bool isSelected;
  final bool compatible;
  final bool isDisplayingInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectPixel(),
      child: SizedBox(
        width: colorContainerSize,
        child: Column(
          children: <Widget>[
            Container(
              width: colorContainerSize,
              height: colorContainerSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: color.withOpacity(0.5),
                        width: 3,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      )
                    : null,
              ),
            ),
            if (isDisplayingInfo)
              ColorInfoWidget(
                color: color,
                isSelected: isSelected,
                compatible: compatible,
              ),
          ],
        ),
      ),
    );
  }
}
