part of 'colors_detected_cubit.dart';

@freezed
class ColorsDetectedState with _$ColorsDetectedState {
  const factory ColorsDetectedState({
    required Uint8List? cameraImage,
    required DeterminedPixels? pixels,
    required List<CompatibleColors>? compatibleDeterminedColors,
    required int? selectedPixelIndex,
  }) = _ColorsDetectedState;

  factory ColorsDetectedState.empty() => const ColorsDetectedState(
        cameraImage: null,
        pixels: null,
        compatibleDeterminedColors: [],
        selectedPixelIndex: null,
      );
}
