import 'package:colors_of_clothes/ui/camera_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const CameraScreen();
                },
              ),
            );
          },
          icon: const Icon(
            Icons.camera_alt,
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
