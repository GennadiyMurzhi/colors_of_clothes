part of 'colors_detected_cubit.dart';

@freezed
class ColorsDetectedState with _$ColorsDetectedState {
  const factory ColorsDetectedState({
    required int? selectedPixelIndex,
  }) = _ColorsDetectedState;

  factory ColorsDetectedState.initial() => const ColorsDetectedState(
        selectedPixelIndex: null,
      );
}



