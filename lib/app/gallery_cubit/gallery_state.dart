part of 'gallery_cubit.dart';

@freezed
class GalleryState with _$GalleryState {
  const factory GalleryState({
    required bool isGrantedPhotos,
    required bool isLoading,
    required GalleryAlbums galleryAlbums,
    required int selectedAlbumIndex,
  }) = _GalleryState;

  factory GalleryState.initial() => GalleryState(
        isGrantedPhotos: false,
        isLoading: true,
        galleryAlbums: GalleryAlbums.empty(),
        selectedAlbumIndex: 0,
      );
}

