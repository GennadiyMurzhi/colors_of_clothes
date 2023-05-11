import 'package:camera/camera.dart';
import 'package:colors_of_clothes/ui/route_observer.dart';
import 'package:flutter/material.dart';

final GlobalKey previewRepaintBoundaryKey = GlobalKey();

late List<CameraDescription> cameras;

final NavigatorObserver routeObserver = RouteObserverCustom();