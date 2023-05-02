import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
      final int assetCount = await PhotoManager.getAssetCount();
      final List<AssetEntity> entities = await PhotoManager.getAssetListRange(
        start: 0,
        end: assetCount,
      );

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();

      for (int i = 0; i < entities.length; i++) {
        final File? photoFile = await entities[i].file;
        if (photoFile != null && photoFile.path.contains('.jpg', photoFile.path.length - 4)) {
          final List<File> photoFiles = List<File>.from(state.photoFiles)..add(photoFile);
          emit(
            state.copyWith(
              photoFiles: photoFiles,
            ),
          );
        }
      }

      emit(
        state.copyWith(
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

  Future<void> openGallery() async {
    emit(
      state.copyWith(
        isOpen: true,
      ),
    );
  }

  void closeGallery() async {
    emit(
      state.copyWith(
        isOpen: false,
      ),
    );
  }
}
