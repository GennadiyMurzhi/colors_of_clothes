import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class PictureTransporter {
  Uint8List? _cameraPicture;
  Uint8List? _segmentationPicture;
  DeterminedPixels? _pixels;

  Future<void> setPicture(Future<XFile> pictureFileFuture) async {
    XFile pictureXFile = await pictureFileFuture;

    File pictureFile = File(pictureXFile.path);
    _cameraPicture = await pictureFile.readAsBytes();
    //_segmentationPicture =
    _pixels = await GetIt.I<Tensor>().selectPixels(pictureFile);
  }

  Uint8List get cameraPicture {
    return _cameraPicture != null
        ? _cameraPicture!
        : throw ('no picture set in picture transporter');
  }

  Uint8List get segmentationPicture {
    return _segmentationPicture != null
        ? _segmentationPicture!
        : throw ('no picture set in picture transporter');
  }

  DeterminedPixels get pixels {
    return _pixels != null
        ? _pixels!
        : throw ('no picture set in picture transporter');
  }
}
