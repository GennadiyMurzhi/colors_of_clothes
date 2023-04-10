import 'dart:typed_data';

import 'package:colors_of_clothes/app/colors_detected_cubit/colors_detected_cubit.dart';
import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/preview/photo_colors_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsDetectedScreen extends StatelessWidget {
  const ColorsDetectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: BlocProvider<ColorsDetectedCubit>(
          create: (context) => getIt<ColorsDetectedCubit>(),
          child: BlocBuilder<ColorsDetectedCubit, ColorsDetectedState>(
            builder: (BuildContext context, ColorsDetectedState state) {
              _checkState(state.cameraImage, state.pixels,
                  state.compatibleDeterminedColors);

              final DeterminedPixels pixels = state.pixels!;
              final List<CompatibleColors> compatibleDeterminedColors =
                  state.compatibleDeterminedColors!;

              final double colorContainerSize =
                  MediaQuery.of(context).size.width / pixels.pixelList.length -
                      10;
              final double colorRowSymmetricPadding =
                  (MediaQuery.of(context).size.width -
                          colorContainerSize * pixels.pixelList.length) /
                      pixels.pixelList.length;

              return Column(
                children: <Widget>[
                  const SizedBox(height: 70),
                  PhotoColorsWidget(
                    image: state.cameraImage!,
                    imageWidth: pixels.imageWidth,
                    imageHeight: pixels.imageHeight,
                    pixelList: pixels.pixelList,
                    selectedPixelIndex: state.selectedPixelIndex,
                    selectPixel: BlocProvider.of<ColorsDetectedCubit>(context).selectPixel,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Determined Colors',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: colorRowSymmetricPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        compatibleDeterminedColors.length,
                        (int index) => SizedBox(
                          width: colorContainerSize,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: colorContainerSize,
                                height: colorContainerSize,
                                decoration: BoxDecoration(
                                  color:
                                      compatibleDeterminedColors[index].color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                compatibleDeterminedColors[index]
                                    .color
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: compatibleDeterminedColors[index]
                                          .color,
                                    ),
                              ),
                              compatibleDeterminedColors[index].compatible
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

void _checkState(
  Uint8List? cameraImage,
  DeterminedPixels? pixels,
  List<CompatibleColors>? compatibleDeterminedColors
) {
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
