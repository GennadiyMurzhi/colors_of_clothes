import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:get_it/get_it.dart';
import 'package:image/image.dart' as img;

class PictureTransporter {
  Uint8List? _picture;
  bool? _isPeople;

  Future<void> setPicture(Future<XFile> pictureFileFuture) async {
    XFile pictureFile = await pictureFileFuture;

    Uint8List pictureBits = await File(pictureFile.path).readAsBytes();
    _picture = pictureBits;

    img.Image? decodedImage = img.decodeImage(pictureBits);

    if(decodedImage != null) {
      final bool isPeople = GetIt.I<Tensor>().predictPeople(decodedImage);
      _isPeople = isPeople;
    } else {
      throw ('decode image fail');
    }
  }

  Uint8List get picture {
    return _picture != null
        ? _picture!
        : throw ('no picture set in picture transporter');
  }

  bool get isPeople {
    return _isPeople != null
        ? _isPeople!
        : throw ('no people information in picture transporter');
  }
}
