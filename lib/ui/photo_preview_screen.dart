import 'dart:typed_data';

import 'package:colors_of_clothes/app/picture_transporter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 70),
            _PreviewMemoryImage(GetIt.I<PictureTransporter>().cameraPicture),
            Text(
              'camera picture',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            _PreviewMemoryImage(GetIt.I<PictureTransporter>().segmentationPicture),
            Text(
              'segmentation picture',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewMemoryImage extends StatelessWidget {
  const _PreviewMemoryImage(this.bytes);

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Image.memory(bytes),
    );
  }
}
