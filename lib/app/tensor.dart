import 'dart:io';

import 'package:colors_of_clothes/domen/determined_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;

class Tensor {
  Future<String> loadModel() async {
    String? res = await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt',
        numThreads: 1,
        // defaults to 1
        isAsset: true,
        // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    if (res != null) {
      return res;
    } else {
      throw ('not load model');
    }
  }

  Future<List<DeterminedColor>> personIdentification(File image) async {
    final Uint8List imageBits = image.readAsBytesSync();
    final img.Image? decodedImage = img.decodeImage(imageBits);
    if (decodedImage == null) {
      throw ('no decode image in the predict segmentation');
    }

    Uint8List? segmentation =
        await Tflite.runSegmentationOnImage(path: image.path);
    if (segmentation == null) {
      throw ('no segmentation result');
    }

    final img.Image? decodedSegmentation = img.decodePng(segmentation);
    if (decodedSegmentation == null) {
      throw ('no decode result in the predict segmentation');
    }
    final img.Image resizedDecodedSegmentation = img.copyResize(
      decodedSegmentation,
      width: decodedImage.width,
      height: decodedImage.height,
    );

    List<img.Pixel> segmentedPixels = <img.Pixel>[];
    //the value of color for person: Color.fromARGB(255, 192, 128, 128)
    for (img.Pixel pixel in resizedDecodedSegmentation) {
      if (pixel.r == 192 || pixel.g == 128 || pixel.b == 128) {
        segmentedPixels.add(decodedImage.getPixel(pixel.x, pixel.y));
      }
    }

    final img.Image personImage = img.Image(
      width: decodedImage.width,
      height: decodedImage.height,
    )..clear(img.ColorRgb8(255, 255, 255));
    for (img.Pixel pixel in segmentedPixels) {
      personImage.setPixel(pixel.x, pixel.y, pixel.clone());
    }

    final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
      MemoryImage(
        img.encodeJpg(personImage),
      ),
    );

    if (kDebugMode) {
      print('\npalette.colors.length: ${palette.colors.length}');
      print(
          '\npalette.selectedSwatches.length: ${palette.selectedSwatches.length}\n ${palette.selectedSwatches}');
      print('\npalette.paletteColors.length: ${palette.paletteColors.length}');
    }
    final List<Color> selectedSwatches = <Color>[];

    for (PaletteTarget swatch in palette.selectedSwatches.keys) {
      selectedSwatches.add(palette.selectedSwatches[swatch]!.color);
    }

    List<DeterminedColor> determinedColors = <DeterminedColor>[];

    for (int i = 0; i <= selectedSwatches.length - 1; i++) {
      final img.Pixel selectedPixel = segmentedPixels.firstWhere(
          (img.Pixel pixel) =>
              pixel.r == selectedSwatches[i].red &&
              pixel.g == selectedSwatches[i].green &&
              pixel.b == selectedSwatches[i].blue);

      determinedColors.add(DeterminedColor(
        selectedPixel.x,
        selectedPixel.y,
        selectedSwatches[i],
      ));
    }

    return determinedColors;
  }
}
