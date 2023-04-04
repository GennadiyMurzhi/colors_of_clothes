import 'package:colors_of_clothes/app/picture_transporter.dart';
import 'package:colors_of_clothes/app/tensor.dart';
import 'package:get_it/get_it.dart';

Future<void> injectionSetup() async {
  GetIt.I.registerLazySingleton<PictureTransporter>(() => PictureTransporter());

  GetIt.I.registerLazySingleton<Tensor>(() => Tensor()..loadModel());
}
