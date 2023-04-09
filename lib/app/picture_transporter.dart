import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:colors_of_clothes/domen/color_compatibility.dart';
import 'package:colors_of_clothes/domen/compatible_colors.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:colors_of_clothes/domen/value_transformers.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class PictureTransporter {
  Uint8List? _cameraImage;
  DeterminedPixels? _pixels;
  List<CompatibleColors>? _compatibleDeterminedColors;

  Future<void> setPicture(Future<XFile> pictureFileFuture) async {
    XFile pictureXFile = await pictureFileFuture;

    File pictureFile = File(pictureXFile.path);
    _cameraImage = await pictureFile.readAsBytes();
    //_segmentationPicture =
    _pixels = await GetIt.I<Tensor>().selectPixels(pictureFile);
    _compatibleDeterminedColors =
        computeCompatibleColor(determinedPixelToColors(pixels));
  }

  Uint8List get cameraImage {
    return _cameraImage != null
        ? _cameraImage!
        : throw ('no picture set in picture transporter');
  }

  DeterminedPixels get pixels {
    return _pixels != null
        ? _pixels!
        : throw ('no determined pixels set in picture transporter');
  }

  List<CompatibleColors> get compatibleDeterminedColors {
    return _compatibleDeterminedColors != null
        ? _compatibleDeterminedColors!
        : throw ('no Compatible Colors set in picture transporter');
  }
}
