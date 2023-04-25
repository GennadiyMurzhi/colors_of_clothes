import 'package:bloc/bloc.dart';
import 'package:flutter/animation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

part 'gallery_state.dart';

part 'gallery_cubit.freezed.dart';

@LazySingleton()
class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit() : super(GalleryState.initial());

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final PermissionState permissionState = await PhotoManager.requestPermissionExtend();
    final bool isGrantedPhotos =
        permissionState == PermissionState.authorized || permissionState == PermissionState.limited;
    if (isGrantedPhotos) {
      final int assetCount = await PhotoManager.getAssetCount();
      final List<AssetEntity> entities = await PhotoManager.getAssetListRange(start: 0, end: assetCount);

      emit(
        state.copyWith(
          entities: entities,
          isGrantedPhotos: isGrantedPhotos,
          isLoading: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isGrantedPhotos: isGrantedPhotos,
          isLoading: false,
        ),
      );
    }
  }

  Future<void> openGallery(TickerFuture Function(double, {Curve curve, Duration? duration}) animateTo) async {
    emit(
      state.copyWith(
        isOpen: true,
      ),
    );
    await animateTo(1, curve: Curves.easeIn);
  }

  Future<void> closeGallery(TickerFuture Function(double, {Curve curve, Duration? duration}) animateBack) async {
    await animateBack(0, curve: Curves.easeOut);
    emit(
      state.copyWith(
        isOpen: false,
      ),
    );
  }
}
