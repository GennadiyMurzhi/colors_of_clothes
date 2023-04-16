import 'package:camera/camera.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  cameras = await availableCameras();



  runApp(const ColorsClothesApp());
}
