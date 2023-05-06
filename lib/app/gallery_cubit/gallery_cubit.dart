import 'dart:io';

import 'package:colors_of_clothes/domen/app_utils.dart';
import 'package:colors_of_clothes/domen/gallery_album.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

part 'gallery_state.dart';

part 'gallery_cubit.freezed.dart';

@LazySingleton()
class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit() : super(GalleryState.initial());

  Future<void> init() async {
    final PermissionState permissionState = await PhotoManager.requestPermissionExtend();
    final bool isGrantedPhotos =
        permissionState == PermissionState.authorized || permissionState == PermissionState.limited;

    emit(
      state.copyWith(
        isGrantedPhotos: isGrantedPhotos,
      ),
    );

    if (isGrantedPhotos) {
      final List<GalleryAlbum> albums = <GalleryAlbum>[];

      final int allCount = await PhotoManager.getAssetCount();
      final List<AssetEntity> allEntities = await selectJPGEntity(
        await PhotoManager.getAssetListRange(
          start: 0,
          end: allCount,
        ),
      );

      albums.add(GalleryAlbum(entities: allEntities));

      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
      for (AssetPathEntity path in paths) {
        final int count = await path.assetCountAsync;
        final List<AssetEntity> entities = await path.getAssetListRange(start: 0, end: count);
        final bool containsJpg = entities.any(
          (AssetEntity element) {
            return element.mimeType != null && element.mimeType!.contains('jpeg');
          },
        );
        if (containsJpg) {
          albums.add(
            GalleryAlbum(
              assetPathEntity: path,
              entities: await selectJPGEntity(entities),
            ),
          );
        }
      }

      emit(
        state.copyWith(
          galleryAlbums: GalleryAlbums(albums: albums),
          isLoading: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    }
  }

  Future<void> loadAlbum({
    String? albumId,
    bool onOpenGallery = false,
  }) async {
    if (!onOpenGallery){
      final int albumIndex;
      if (albumId == null) {
        albumIndex = 0;
      } else {
        albumIndex = state.galleryAlbums.getAlbumIndex(albumId);
      }

      emit(
        state.copyWith(
          selectedAlbumIndex: albumIndex,
        ),
      );
    }

    final List<File> entitiesFiles = state.galleryAlbums.albums[state.selectedAlbumIndex].entitiesFiles != null
        ? List.from(state.galleryAlbums.albums[state.selectedAlbumIndex].entitiesFiles!, growable: true)
        : List<File>.empty(growable: true);

    final int entitiesCount = state.galleryAlbums.albums[state.selectedAlbumIndex].entities.length - 1;
    for (int i = entitiesFiles.length;
        i <= state.galleryAlbums.albums[state.selectedAlbumIndex].entities.length - 1;
        i++) {
      final AssetEntity entity = state.galleryAlbums.albums[state.selectedAlbumIndex].entities[i];
      final File? photoFile = await entity.file;
      if (photoFile != null) {
        entitiesFiles.add(photoFile);

        final GalleryAlbums newGalleryAlbums = GalleryAlbums.createUpdatedGalleryFromOldAlbumsEntitiesFiles(
          oldAlbums: state.galleryAlbums.albums,
          indexAlbum: state.selectedAlbumIndex,
          entitiesFiles: List<File>.from(entitiesFiles),
        );
        if (i % 3 == 0 || i == entitiesCount) {
          emit(
            state.copyWith(
              galleryAlbums: newGalleryAlbums,
            ),
          );
        }
      }
    }
  }

  Future<void> openGallery() async {
    loadAlbum(onOpenGallery: true);
  }
}
