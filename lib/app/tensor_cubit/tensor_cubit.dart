import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'tensor_state.dart';

part 'tensor_cubit.freezed.dart';

@LazySingleton()
class TensorCubit extends Cubit<TensorState> {
  TensorCubit(this._tensor) : super(TensorState.initial());

  final Tensor _tensor;

  Future<void> setPicture(XFile pictureXFile) async {
    final File pictureFile = File(pictureXFile.path);

    final Uint8List cameraImage = await pictureFile.readAsBytes();
    final DeterminedPixels pixels = await _tensor.selectPixels(pictureFile);
    final CompatibleColorsList compatibleDeterminedColors =
        CompatibleColorsList.fromDeterminedColors(pixels.determinedColors);

    emit(
      state.copyWith(
        colorDetermination: false,
        cameraImage: cameraImage,
        pixels: pixels,
        compatibleDeterminedColors: compatibleDeterminedColors,
      ),
    );
  }

  void setInitial(){
    emit(TensorState.initial());
  }
}
