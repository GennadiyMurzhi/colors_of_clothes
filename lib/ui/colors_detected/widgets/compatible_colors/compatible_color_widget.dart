import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:flutter/material.dart';

class CompatibleColorWidget extends StatelessWidget {
  const CompatibleColorWidget({
    super.key,
    required this.compatibleColor,
  });

  final CompatibleColor compatibleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: compatibleColor.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 20),
        Text(
          'Harmony: ${compatibleColor.harmony}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
