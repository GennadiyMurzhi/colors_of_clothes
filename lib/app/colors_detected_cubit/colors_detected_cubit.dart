import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:colors_of_clothes/domen/color_compatibility.dart';
import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/domen/value_transformers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'colors_detected_cubit.freezed.dart';

part 'colors_detected_state.dart';

@LazySingleton()
class ColorsDetectedCubit extends Cubit<ColorsDetectedState> {
  ColorsDetectedCubit(this._tensor) : super(ColorsDetectedState.empty());

  final Tensor _tensor;

  Future<void> setPicture(Future<XFile> pictureFileFuture) async {
    final XFile pictureXFile = await pictureFileFuture;

    final File pictureFile = File(pictureXFile.path);

    final Uint8List cameraImage = await pictureFile.readAsBytes();
    final DeterminedPixels pixels = await _tensor.selectPixels(pictureFile);
    final List<CompatibleColors> compatibleDeterminedColors =
        computeCompatibleColor(determinedPixelToColors(pixels));

    emit(
      state.copyWith(
        cameraImage: cameraImage,
        pixels: pixels,
        compatibleDeterminedColors: compatibleDeterminedColors,
      ),
    );
  }

  void selectPixel(int indexPixel) {
    emit(
      state.copyWith(
        selectedPixelIndex: indexPixel,
      ),
    );
  }
}
