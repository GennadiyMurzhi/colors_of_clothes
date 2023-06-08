import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorInfoWidget extends StatelessWidget {
  const ColorInfoWidget({
    super.key,
    required this.color,
    required this.isSelected,
    required this.compatible,
  });

  final Color color;
  final bool isSelected;
  final bool compatible;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
    );
  }
}
