part of 'colors_detected_cubit.dart';

@freezed
class ColorsDetectedState with _$ColorsDetectedState {
  const factory ColorsDetectedState({
    required bool isColorDetermination,
    required int? selectedPixelIndex,
  }) = _ColorsDetectedState;

  factory ColorsDetectedState.colorDetermination() => const ColorsDetectedState(
        isColorDetermination: true,
        selectedPixelIndex: null,
      );
}



