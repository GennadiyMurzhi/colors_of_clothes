import 'package:colors_of_clothes/app/picture_transporter.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:get_it/get_it.dart';

Future<void> injectionSetup() async {
  GetIt.I.registerLazySingleton<PictureTransporter>(() => PictureTransporter());

  Tensor? tensor = await Tensor.loadWith(
    labelsFileName: 'assets/labels.txt',
    modelFileName: 'model_unquant.tflite',
  );

  if (tensor != null) {
    GetIt.I.registerLazySingleton<Tensor>(() => tensor);
  } else {
    throw ('No load tensor');
  }
}
