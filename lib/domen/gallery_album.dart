import 'dart:io';

import 'package:photo_manager/photo_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery_album.freezed.dart';

@freezed
class GalleryAlbums with _$GalleryAlbums {
  const GalleryAlbums._();

  const factory GalleryAlbums({
    required List<GalleryAlbum> albums,
  }) = _GalleryAlbums;

  factory GalleryAlbums.empty() => const GalleryAlbums(albums: <GalleryAlbum>[]);

  factory GalleryAlbums.createUpdatedGalleryFromOldAlbumsEntitiesFiles({
    required List<GalleryAlbum> oldAlbums,
    required int indexAlbum,
    required List<File> entitiesFiles,
  }) {
    return GalleryAlbums(
      albums: List<GalleryAlbum>.from(oldAlbums)
        ..[indexAlbum] = oldAlbums[indexAlbum].copyWith(entitiesFiles: entitiesFiles),
    );
  }

  int getAlbumIndex(String albumId) => albums.indexWhere((GalleryAlbum element) => element.checkId(albumId));

  int get count => albums.length;
}

@freezed
class GalleryAlbum with _$GalleryAlbum {
  const GalleryAlbum._();

  const factory GalleryAlbum({
    AssetPathEntity? assetPathEntity,
    required List<AssetEntity> entities,
    List<File>? entitiesFiles,
  }) = _GalleryAlbum;

  bool checkId(String compareAlbumId) =>
      assetPathEntity != null ? assetPathEntity!.id.compareTo(compareAlbumId) == 0 : false;
}
