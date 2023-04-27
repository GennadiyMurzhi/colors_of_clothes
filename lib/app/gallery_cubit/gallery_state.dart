part of 'gallery_cubit.dart';

@freezed
class GalleryState with _$GalleryState {
  const factory GalleryState({
    required bool isGrantedPhotos,
    required bool isLoading,
    required List<File> photoFiles,
    required bool isOpen,
    required bool canClose,
    required ScrollPhysics? physics,
  }) = _GalleryState;

  factory GalleryState.initial() => const GalleryState(
        isGrantedPhotos: false,
        isLoading: true,
        photoFiles: <File>[],
        isOpen: false,
        canClose: true,
        physics: NeverScrollableScrollPhysics(),
      );
}
