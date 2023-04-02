import 'dart:typed_data';

import 'package:colors_of_clothes/app/picture_transporter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.memory(GetIt.I<PictureTransporter>().picture),
          Text(
            GetIt.I<PictureTransporter>().isPeople
                ? 'is people'
                : 'is not people',
            style: const TextStyle(
              color: Color(0xffffffff),
            ),
          ),
        ],
      ),
    );
  }
}
