part of 'tensor_cubit.dart';

@freezed
class TensorState with _$TensorState {
  const factory TensorState({
    required Uint8List? image,
    required DeterminedPixels? pixels,
    required CompatibleColorsList? compatibleDeterminedColors,
  }) = _TensorState;

  factory TensorState.initial() => const TensorState(
        image: null,
        pixels: null,
        compatibleDeterminedColors: null,
      );
}
