part of 'gallery_cubit.dart';

@freezed
class GalleryState with _$GalleryState {
  const factory GalleryState({
    required bool isGrantedPhotos,
    required bool isLoading,
    required List<AssetEntity> entities,
    required bool isOpen,
  }) = _GalleryState;

  factory GalleryState.initial() => const GalleryState(
        isGrantedPhotos: false,
        isLoading: true,
        entities: <AssetEntity>[],
        isOpen: false,
      );
}
