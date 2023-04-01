import 'package:camera/camera.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/app.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await injectionSetup();

  cameras = await availableCameras();
  runApp(const ColorsClothesApp());
}
