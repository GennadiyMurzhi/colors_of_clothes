import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

class Tensor {
  Future<String> loadModel() async {
    String? res = await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt',
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
    if(res != null) {
      return res;
    } else {
      throw('not load madel');
    }
  }

  Future<Uint8List> predictSegmentation(File picture) async {
    final Image decodeImage = await decodeImageFromList(picture.readAsBytesSync());
    print(decodeImage.height);
    print(decodeImage.width);

    Uint8List? result = await Tflite.runSegmentationOnImage(
      path: picture.path,
      //imageMean: 127.5,
      //imageStd: 127.5,
    );

    if(result != null) {
      final Image decodeResult = await decodeImageFromList(result);


      return result;
    } else {
      throw('no segmentation result');
    }
  }

  Future<Uint8List> predictSegmentationBinary(Uint8List picture) async {
    Uint8List? result = await Tflite.runSegmentationOnBinary(
        binary: picture,     // required
        //labelColors: [...], // defaults to https://github.com/shaqian/flutter_tflite/blob/master/lib/tflite.dart#L219
        outputType: "png",  // defaults to "png"
        asynch: true,        // defaults to true
    );

    if(result != null) {
      return result;
    } else {
      throw('no segmentation result');
    }
  }

}
