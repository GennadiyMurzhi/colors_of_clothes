import 'package:colors_of_clothes/app/connector_tensor_cubit_colors_detected/connector_tensor_colors_detected.dart';
import 'package:colors_of_clothes/app/connector_tensor_cubit_colors_detected/connector_tensor_colors_detected_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'colors_detected_cubit.freezed.dart';

part 'colors_detected_state.dart';

@Injectable()
class ColorsDetectedCubit extends Cubit<ColorsDetectedState> {
  ColorsDetectedCubit(this._connectorTensorColorsDetected) : super(ColorsDetectedState.colorDetermination()) {
    _connectorTensorColorsDetected.addListener(
      (ConnectorTensorColorsDetectedEvent event) {
        //TODO
        event.maybeWhen(
          colorsNotDetermined: () {
            _isColorsNotDeterminedEmit();
          },
          colorsDeterminedAnimateIsEnded: () {
            _isColorsNotDeterminedEmit();
          },
          orElse: () {},
        );
      },
    );
  }

  final ConnectorTensorColorsDetected _connectorTensorColorsDetected;

  void selectPixel(int indexPixel) {
    emit(
      state.copyWith(
        selectedPixelIndex: indexPixel,
      ),
    );
  }

  void _isColorsNotDeterminedEmit() {
    emit(
      state.copyWith(
        isColorDetermination: false,
      ),
    );
  }

  void switchExpanded(bool isSlidingUpColorsWidgetExpanded) {
    emit(
      state.copyWith(
        isSlidingUpColorsWidgetExpanded: isSlidingUpColorsWidgetExpanded,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _connectorTensorColorsDetected.clear();

    super.close();
  }
}
