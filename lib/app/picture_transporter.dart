import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class PictureTransporter {
  Uint8List? _cameraPicture;
  Uint8List? _segmentationPicture;
  bool? _isPeople;

  Future<void> setPicture(Future<XFile> pictureFileFuture) async {
    XFile pictureXFile = await pictureFileFuture;

    File pictureFile = File(pictureXFile.path);
    _cameraPicture = await pictureFile.readAsBytes();
    _segmentationPicture = await GetIt.I<Tensor>().predictSegmentation(pictureFile);

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

  bool get isPeople {
    return _isPeople != null
        ? _isPeople!
        : throw ('no people information in picture transporter');
  }
}
