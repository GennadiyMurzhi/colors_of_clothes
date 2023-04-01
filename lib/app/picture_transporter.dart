import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';

class PictureTransporter {
  Uint8List? _picture;

  Future<void> setPicture(Future<XFile> pictureFileFuture) async {
    XFile pictureFile = await pictureFileFuture;

    Uint8List pictureBits = await File(pictureFile.path).readAsBytes();

    _picture = pictureBits;
  }

  Uint8List get picture {
    return _picture != null
        ? _picture!
        : throw ('no picture set in picture transporter');
  }
}
