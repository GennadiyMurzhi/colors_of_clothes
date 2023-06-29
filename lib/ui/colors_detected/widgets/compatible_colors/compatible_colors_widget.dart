import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/compatible_colors/compatible_color_widget.dart';
import 'package:flutter/material.dart';

class CompatibleColorsWidget extends StatelessWidget {
  const CompatibleColorsWidget({
    super.key,
    required this.compatibleColors,
    required this.horizontalSymmetricPadding,
  });

  final CompatibleColors? compatibleColors;
  final double horizontalSymmetricPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: compatibleColors == null
          ? Text(
              'Select color to display harmony information',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          : Column(
              children: List<Widget>.generate(
                compatibleColors!.compatibleList.length,
                (int index) => compatibleColors!.compatibleList.length - 1 != index
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CompatibleColorWidget(
                          compatibleColor: compatibleColors!.compatibleList[index],
                        ),
                      )
                    : CompatibleColorWidget(
                        compatibleColor: compatibleColors!.compatibleList[index],
                      ),
              ),
            ),
    );
  }
}
