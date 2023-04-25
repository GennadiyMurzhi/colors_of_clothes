import 'package:colors_of_clothes/app/gallery_cubit/gallery_cubit.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/camera/camera_screen.dart';
import 'package:colors_of_clothes/ui/colors_detected/colors_detected_screen.dart';
import 'package:colors_of_clothes/ui/home/widgets/gallery_widget.dart';
import 'package:colors_of_clothes/ui/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController galleryAnimationController;

  @override
  void initState() {
    galleryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        print('details.toString()');
        print(details.toString());
        if (details.delta.dy <= 0) {
          BlocProvider.of<GalleryCubit>(context).openGallery(galleryAnimationController.animateTo);
        }
        if (details.delta.dy > 0) {
          BlocProvider.of<GalleryCubit>(context).closeGallery(galleryAnimationController.animateBack);
        }
      },
      child: Scaffold(
        body: BlocBuilder<GalleryCubit, GalleryState>(
          builder: (BuildContext context, GalleryState state) {
            return AnimatedBuilder(
              animation: galleryAnimationController,
              builder: (BuildContext context, Widget? child) {
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox.fromSize(
                      size: MediaQuery.of(context).size,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 300),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                buildRoute(const CameraScreen()),
                              );
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              XFile? pickedImage = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 50,
                              );
                              if (pickedImage != null && context.mounted) {
                                getIt<TensorCubit>().setPicture(pickedImage);

                                Navigator.push(
                                  context,
                                  buildRoute(const ColorsDetectedScreen()),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.image_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.isOpen)
                      GalleryWidget(
                        animationValue: galleryAnimationController.value,
                        entities: state.entities,
                        isGrantedPhotos: state.isGrantedPhotos,
                        isLoading: state.isLoading,
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
