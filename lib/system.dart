import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

final Color _overlayColor = Colors.black.withOpacity(0.002);

final SystemUiOverlayStyle _systemUIOverlayStyleLight = SystemUiOverlayStyle.light.copyWith(
  statusBarColor: _overlayColor,
  systemNavigationBarDividerColor: _overlayColor,
);

final SystemUiOverlayStyle _systemUIOverlayStyleDark = SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: _overlayColor,
);

final SystemUiOverlayStyle _systemUIOverlayStyleToEdge = _systemUIOverlayStyleLight.copyWith(
  statusBarColor: _overlayColor,
  systemNavigationBarDividerColor: _overlayColor,
  systemNavigationBarColor: _overlayColor,
);

void setSystemUI() {
  if (SchedulerBinding.instance.window.platformBrightness == Brightness.light) {
    SystemChrome.setSystemUIOverlayStyle(_systemUIOverlayStyleLight);
  } else if (SchedulerBinding.instance.window.platformBrightness == Brightness.dark) {
    SystemChrome.setSystemUIOverlayStyle(_systemUIOverlayStyleDark);
  }

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: <SystemUiOverlay>[
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );
}

void setSystemUIToEdge() {
  SystemChrome.setSystemUIOverlayStyle(_systemUIOverlayStyleToEdge);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
}

void setDefaultOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
  ]);
}
