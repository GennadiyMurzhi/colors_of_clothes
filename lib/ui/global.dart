import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

final GlobalKey previewRepaintBoundaryKey = GlobalKey();

late List<CameraDescription> cameras;