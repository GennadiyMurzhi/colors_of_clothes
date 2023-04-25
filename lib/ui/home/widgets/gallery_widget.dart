import 'package:flutter/material.dart';

import 'package:photo_manager/photo_manager.dart';

class GalleryWidget extends StatelessWidget {
  const GalleryWidget({
    super.key,
    required this.entities,
    required this.animationValue,
    required this.isGrantedPhotos,
    required this.isLoading,
  });

  final List<AssetEntity> entities;
  final double animationValue;
  final bool isGrantedPhotos;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const Radius radius = Radius.circular(30);

    print('isGrantedPhotos: $isGrantedPhotos');
    print('isLoading: $isLoading');
    print('entities: ${entities.length}');

    return Positioned(
      bottom: -size.height * 0.9 + size.height * 0.9 * animationValue,
      child: Container(
        width: size.width,
        height: size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: radius,
            topRight: radius,
          ),
        ),
        child: isGrantedPhotos
            ? isLoading
                ? const Center(
                    child: Text('Loading photos...'),
                  )
                : Wrap(
                    children: List<Widget>.generate(
                      entities.length,
                      (int index) => AssetEntityImage(
                        entities[index],
                        thumbnailSize: const ThumbnailSize.square(200), // Preferred value.
                        thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
                      ),
                    ),
                  )
            : const Center(
                child: Text('No granted photos...'),
              ),
      ),
    );
  }
}
