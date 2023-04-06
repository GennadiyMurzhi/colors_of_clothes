import 'dart:typed_data';

import 'package:colors_of_clothes/app/picture_transporter.dart';
import 'package:colors_of_clothes/domen/determined_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DeterminedColor> colors = GetIt.I<PictureTransporter>().colors;

    final Uint8List bytes = GetIt.I<PictureTransporter>().cameraPicture;
    final Image image = Image.memory(bytes);
    print('\nwidth: ${image.width}');
    print('\nheight: ${image.width}');

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
            Stack(
              children: <Widget>[
                image,
              ],
            ),
            Text(
              'camera picture',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            //_PreviewMemoryImage(GetIt.I<PictureTransporter>().segmentationPicture),
            Text(
              'Determined Colors',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                colors.length,
                (int index) => Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    width: 200,
                    height: 200,
                    color: colors[index].color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}