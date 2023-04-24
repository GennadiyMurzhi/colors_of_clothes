import 'dart:typed_data';

import 'package:colors_of_clothes/app/colors_detected_cubit/colors_detected_cubit.dart';
import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/compatible_colors/compatible_colors_widget.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/determined_colors/determined_colors_widget.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/photo_colors/photo_colors_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsDetectedBody extends StatelessWidget {
  const ColorsDetectedBody({
    super.key,
    required this.image,
    required this.pixels,
    required this.compatibleDeterminedColors,
  });

  final Uint8List image;
  final DeterminedPixels pixels;
  final List<CompatibleColors> compatibleDeterminedColors;

  @override
  Widget build(BuildContext context) {
    final double colorContainerSize = MediaQuery.of(context).size.width / pixels.pixelList.length - 10;
    final double colorRowSymmetricPadding =
        (MediaQuery.of(context).size.width - colorContainerSize * pixels.pixelList.length) / pixels.pixelList.length;

    return BlocProvider(
      create: (BuildContext context) => getIt<ColorsDetectedCubit>(),
      child: BlocBuilder<ColorsDetectedCubit, ColorsDetectedState>(
        builder: (BuildContext context, ColorsDetectedState state) {
          final int? selectedPixelIndex = state.selectedPixelIndex;
          final void Function(int indexPixel) selectPixel = BlocProvider.of<ColorsDetectedCubit>(context).selectPixel;

          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 70),
                  PhotoColorsWidget(
                    image: image,
                    imageWidth: pixels.imageWidth,
                    imageHeight: pixels.imageHeight,
                    pixelList: pixels.pixelList,
                    selectedPixelIndex: selectedPixelIndex,
                    selectPixel: selectPixel,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Determined Colors',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  DeterminedColorsWidget(
                    colorRowSymmetricPadding: colorRowSymmetricPadding,
                    colorContainerSize: colorContainerSize,
                    compatibleDeterminedColors: compatibleDeterminedColors,
                    selectedPixelIndex: selectedPixelIndex,
                    selectPixel: selectPixel,
                  ),
                  CompatibleColorsWidget(
                    compatibleColors: selectedPixelIndex != null ? compatibleDeterminedColors[selectedPixelIndex] : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
