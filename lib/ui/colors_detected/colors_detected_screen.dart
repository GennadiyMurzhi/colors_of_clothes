import 'package:colors_of_clothes/ui/colors_detected/widgets/colors_detected_body.dart';
import 'package:flutter/material.dart';

class ColorsDetectedScreen extends StatelessWidget {
  const ColorsDetectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: const ColorsDetectedBody(),
    );
  }
}
