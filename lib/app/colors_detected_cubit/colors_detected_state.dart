part of 'colors_detected_cubit.dart';

@freezed
class ColorsDetectedState with _$ColorsDetectedState {
  const factory ColorsDetectedState({
    required Uint8List? cameraImage,
    required DeterminedPixels? pixels,
    required CompatibleColorsList? compatibleDeterminedColors,
    required int? selectedPixelIndex,
  }) = _ColorsDetectedState;

  factory ColorsDetectedState.empty() => const ColorsDetectedState(
        cameraImage: null,
        pixels: null,
        compatibleDeterminedColors: null,
        selectedPixelIndex: null,
      );
}
