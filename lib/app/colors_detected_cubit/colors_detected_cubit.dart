import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'colors_detected_cubit.freezed.dart';

part 'colors_detected_state.dart';

@Injectable()
class ColorsDetectedCubit extends Cubit<ColorsDetectedState> {
  ColorsDetectedCubit() : super(ColorsDetectedState.initial());

  void selectPixel(int indexPixel) {
    emit(
      state.copyWith(
        selectedPixelIndex: indexPixel,
      ),
    );
  }
}
