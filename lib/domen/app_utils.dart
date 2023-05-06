import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

Future<List<AssetEntity>> selectJPGEntity(List<AssetEntity> assetEntities) async {
  final List<AssetEntity> entitiesJPGSelected = List<AssetEntity>.empty(growable: true);

  for (AssetEntity entity in assetEntities) {
    if(Platform.isIOS) {
      if(entity.mimeType != null && (await entity.mimeTypeAsync)!.contains('jpeg')) {
        entitiesJPGSelected.add(entity);
      }
    } else {
      if(entity.mimeType != null && entity.mimeType!.contains('jpeg')) {
        entitiesJPGSelected.add(entity);
      }
    }
  }

  return entitiesJPGSelected;
}
