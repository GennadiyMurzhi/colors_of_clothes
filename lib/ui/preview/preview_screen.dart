import 'dart:typed_data';

import 'package:colors_of_clothes/app/picture_transporter.dart';
import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/ui/preview/photo_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

PictureTransporter _pictureTransporter = GetIt.I<PictureTransporter>();

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Uint8List bytes = _pictureTransporter.cameraImage;
    final DeterminedPixels pixels = _pictureTransporter.pixels;
    final List<CompatibleColors> compatibleDeterminedColors =
        _pictureTransporter.compatibleDeterminedColors;

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Determined Colors',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: colorRowSymmetricPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  compatibleDeterminedColors.length,
                  (int index) => SizedBox(
                    width: colorContainerSize,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: colorContainerSize,
                          height: colorContainerSize,
                          decoration: BoxDecoration(
                            color: compatibleDeterminedColors[index].color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          compatibleDeterminedColors[index].color.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: compatibleDeterminedColors[index].color,
                              ),
                        ),
                        compatibleDeterminedColors[index].compatible
                            ? Icon(
                                Icons.check_box_outlined,
                                color: Colors.green.shade500,
                              )
                            : Icon(
                                Icons.indeterminate_check_box_outlined,
                                color: Colors.red.shade900,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),

            ),
          ],
        ),
      ),
    );
  }
}
