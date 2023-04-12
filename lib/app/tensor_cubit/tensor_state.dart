part of 'tensor_cubit.dart';

@freezed
class TensorState with _$TensorState {
  const factory TensorState({
    required Uint8List? cameraImage,
    required DeterminedPixels? pixels,
    required CompatibleColorsList? compatibleDeterminedColors,
    required bool colorDetermination,
  }) = _TensorState;

  factory TensorState.initial() => const TensorState(
        cameraImage: null,
        pixels: null,
        compatibleDeterminedColors: null,
        colorDetermination: true,
      );
}
