import 'package:camera/camera.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/app.dart';
import 'package:colors_of_clothes/ui/global.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  cameras = await availableCameras();

  runApp(const ColorsClothesApp());
}
