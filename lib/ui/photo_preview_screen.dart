import 'package:colors_of_clothes/app/picture_transporter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30,60,30,0),
              child: Image.memory(GetIt.I<PictureTransporter>().cameraPicture),
            ),
            Text('camera picture', style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(height: 30),
            Image.memory(GetIt.I<PictureTransporter>().segmentationPicture),
            Text('segmentation picture', style: Theme.of(context).textTheme.titleLarge,),
          ],
        ),
      ),
    );
  }
}
