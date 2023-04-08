import 'dart:typed_data';

import 'package:colors_of_clothes/app/picture_transporter.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/ui/preview/photo_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DeterminedPixels pixels = GetIt.I<PictureTransporter>().pixels;

    final Uint8List bytes = GetIt.I<PictureTransporter>().cameraPicture;

    final double colorContainerSize =
        MediaQuery.of(context).size.width / pixels.pixelList.length - 10;
    final double colorRowSymmetricPadding = (MediaQuery.of(context).size.width -
            colorContainerSize * pixels.pixelList.length) /
        pixels.pixelList.length;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 70),
            PhotoPreviewWidget(
              image: bytes,
              determinedPixels: pixels,
            ),
            Text(
              'camera picture',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            Text(
              'Determined Colors',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: colorRowSymmetricPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  pixels.pixelList.length,
                  (int index) => SizedBox(
                    width: colorContainerSize,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: colorContainerSize,
                          color: pixels.pixelList[index].color,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          pixels.pixelList[index].color.toString(),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: pixels.pixelList[index].color,
                                  ),
                        ),
                      ],
                    ),
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
