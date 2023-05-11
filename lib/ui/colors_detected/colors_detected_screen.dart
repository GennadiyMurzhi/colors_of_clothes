import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/colors_detected_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsDetectedScreen extends StatelessWidget {
  const ColorsDetectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<TensorCubit, TensorState>(
        builder: (BuildContext context, TensorState state) {
          return state.colorDetermination
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Color Determination...',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const LinearProgressIndicator(),
                  ],
                )
              : ColorsDetectedBody(
                  image: state.cameraImage!,
                  pixels: state.pixels!,
                  compatibleDeterminedColors: state.compatibleDeterminedColors!.list,
                );
        },
      ),
    );
  }
}
