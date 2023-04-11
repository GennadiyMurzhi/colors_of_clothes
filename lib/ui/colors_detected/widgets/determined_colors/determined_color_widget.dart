import 'package:flutter/material.dart';

class DeterminedColorWidget extends StatelessWidget {
  const DeterminedColorWidget({
    super.key,
    required this.selectPixel,
    required this.colorContainerSize,
    required this.color,
    required this.isSelected,
    required this.compatible,
  });

  final void Function() selectPixel;
  final double colorContainerSize;
  final Color color;
  final bool isSelected;
  final bool compatible;

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
            const SizedBox(height: 20),
            Text(
              color.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: color,
                    fontWeight: isSelected ? FontWeight.w600 : null,
                  ),
            ),
            const SizedBox(height: 5),
            compatible
                ? Icon(
                    Icons.check_box_outlined,
                    color: Colors.green.shade500,
                  )
                : Icon(
                    Icons.indeterminate_check_box_outlined,
                    color: Colors.red.shade900,
                  ),
          ],
        ),
      ),
    );
  }
}
