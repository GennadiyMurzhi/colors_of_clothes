import 'dart:io';
import 'dart:isolate';

import 'package:colors_of_clothes/app/connector_tensor_cubit_colors_detected/connector_tensor_colors_detected.dart';
import 'package:colors_of_clothes/app/connector_tensor_cubit_colors_detected/connector_tensor_colors_detected_event.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'tensor_state.dart';

part 'tensor_cubit.freezed.dart';

@LazySingleton()
class TensorCubit extends Cubit<TensorState> {
  TensorCubit(this._connectorTensorColorsDetected) : super(TensorState.initial());

  final ConnectorTensorColorsDetected _connectorTensorColorsDetected;

  Future<void> setPicture(File pictureFile) async {
    final Uint8List image = await pictureFile.readAsBytes();

    final ReceivePort receivePort = ReceivePort();
    final Isolate isolate = await Isolate.spawn(
      selectPixels,
      IsolateTensorArgs(
        rootIsolateToken: RootIsolateToken.instance!,
        sendPort: receivePort.sendPort,
        pictureFile: pictureFile,
      ),
    );

    receivePort.listen(
      (message) {
        if (message is DeterminedPixels) {
          final DeterminedPixels pixels = message;

          final CompatibleColorsList compatibleDeterminedColors =
              CompatibleColorsList.fromDeterminedColors(pixels.determinedColors);

          emit(
            state.copyWith(
              image: image,
              pixels: pixels,
              compatibleDeterminedColors: compatibleDeterminedColors,
            ),
          );

          if (compatibleDeterminedColors.list.isNotEmpty) {
            _connectorTensorColorsDetected.addEvent(ConnectorTensorColorsDetectedEvent.colorsDetermined());
          } else {
            _connectorTensorColorsDetected.addEvent(ConnectorTensorColorsDetectedEvent.colorsNotDetermined());
          }

          isolate.kill();
          receivePort.close();
        }
      },
    );
  }

  void setInitial() {
    emit(TensorState.initial());
  }
}
