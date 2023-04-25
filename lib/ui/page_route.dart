import 'package:flutter/material.dart';

Route buildRoute(Widget screen) => PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return screen;
      },
      transitionsBuilder:
          (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, child) {

        const Offset begin = Offset(0.0, 0.0);
        const Offset end = Offset(1.0, 0.0);
        final Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
        final Animation<Offset> offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
