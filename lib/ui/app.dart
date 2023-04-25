import 'package:colors_of_clothes/app/gallery_cubit/gallery_cubit.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsClothesApp extends StatelessWidget {
  const ColorsClothesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<TensorCubit>(
          create: (BuildContext context) => getIt<TensorCubit>(),
        ),
        BlocProvider<GalleryCubit>(
          create: (BuildContext context) => getIt<GalleryCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Colors of Clothes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
