import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/global.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/home/home_screen.dart';
import 'package:colors_of_clothes/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsClothesApp extends StatelessWidget {
  const ColorsClothesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TensorCubit>(
      create: (BuildContext context) => getIt<TensorCubit>(),
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        title: 'Colors of Clothes',
        theme: theme,
        darkTheme: darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
