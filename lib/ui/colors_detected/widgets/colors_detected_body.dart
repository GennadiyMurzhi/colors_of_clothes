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
  const ColorsDetectedBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider<ColorsDetectedCubit>(
        create: (context) => getIt<ColorsDetectedCubit>(),
        child: BlocBuilder<ColorsDetectedCubit, ColorsDetectedState>(
          builder: (BuildContext context, ColorsDetectedState state) {
            _checkState(state.cameraImage, state.pixels, state.compatibleDeterminedColors);

            final DeterminedPixels pixels = state.pixels!;
            final List<CompatibleColors> compatibleDeterminedColors = state.compatibleDeterminedColors!.list;

            final double colorContainerSize = MediaQuery.of(context).size.width / pixels.pixelList.length - 10;
            final double colorRowSymmetricPadding =
                (MediaQuery.of(context).size.width - colorContainerSize * pixels.pixelList.length) /
                    pixels.pixelList.length;

            final int? selectedPixelIndex = state.selectedPixelIndex;
            final void Function(int indexPixel) selectPixel = BlocProvider.of<ColorsDetectedCubit>(context).selectPixel;

            return Column(
              children: <Widget>[
                const SizedBox(height: 70),
                PhotoColorsWidget(
                  image: state.cameraImage!,
                  imageWidth: pixels.imageWidth,
                  imageHeight: pixels.imageHeight,
                  pixelList: pixels.pixelList,
                  selectedPixelIndex: state.selectedPixelIndex,
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
                  selectedPixelIndex: state.selectedPixelIndex,
                  selectPixel: selectPixel,
                ),
                CompatibleColorsWidget(
                  compatibleColors: selectedPixelIndex != null ? compatibleDeterminedColors[selectedPixelIndex] : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void _checkState(Uint8List? cameraImage, DeterminedPixels? pixels, CompatibleColorsList? compatibleDeterminedColors) {
  if (cameraImage == null) {
    throw ('cameraImage is not set in the colors detected state');
  }
  if (pixels == null) {
    throw ('pixels is not set in the colors detected state');
  }
  if (compatibleDeterminedColors == null) {
    throw ('compatibleDeterminedColors is not set in the colors detected state');
  }
}
