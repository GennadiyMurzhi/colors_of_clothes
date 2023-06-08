import 'dart:async';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

///This receiver is needed for convenient Data to UI transfer
@Injectable()
class ImageReceiver {
  ///When initializing the DataReceiver object, pass an empty data in the constructor parameters
  ImageReceiver() : _imageStream = BehaviorSubject();

  Uint8List? _image;

  ///Stream through which updated data will arrive
  final BehaviorSubject<Uint8List> _imageStream;

  ///add new data in stream
  Future<void> addImage(Uint8List image) async {
    _imageStream.add(_image = image);
  }

  Uint8List get lastImage {
    if (_image != null) {
      return _image!;
    } else {
      throw ('Try to get last image when it is null');
    }
  }

  Future<void> close () async {
    await _imageStream.close();
  }

  Stream<Uint8List> get imageStream => _imageStream.stream;
}
