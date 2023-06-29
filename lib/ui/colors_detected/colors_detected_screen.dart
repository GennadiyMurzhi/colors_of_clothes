import 'package:colors_of_clothes/app/colors_detected_cubit/colors_detected_cubit.dart';
import 'package:colors_of_clothes/app/connector_tensor_cubit_colors_detected/connector_tensor_colors_detected.dart';
import 'package:colors_of_clothes/app/connector_tensor_cubit_colors_detected/connector_tensor_colors_detected_event.dart';
import 'package:colors_of_clothes/app/tensor_cubit/tensor_cubit.dart';
import 'package:colors_of_clothes/injection.dart';
import 'package:colors_of_clothes/ui/colors_detected/widgets/colors_detected_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsDetectedScreen extends StatefulWidget {
  const ColorsDetectedScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ColorsDetectedScreenState();
}

class _ColorsDetectedScreenState extends State<ColorsDetectedScreen> with TickerProviderStateMixin {
  late AnimationController _loadingAnimationController;
  late AnimationController _afterDeterminedAnimationController;
  final ConnectorTensorColorsDetected _connectorTensorColorsDetected = getIt<ConnectorTensorColorsDetected>();

  @override
  void initState() {
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    )..repeat();

    _afterDeterminedAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _connectorTensorColorsDetected.addListener(
      (ConnectorTensorColorsDetectedEvent event) {
        event.maybeWhen(
          colorsDetermined: () async {
            await _loadingAnimationController.animateTo(1);
            _loadingAnimationController.stop();
            await _afterDeterminedAnimationController.animateTo(0.6);
            _connectorTensorColorsDetected
                .addEvent(ConnectorTensorColorsDetectedEvent.colorsDeterminedAnimateIsEnded());
          },
          colorsDeterminedAnimateIsEnded: () {
            _afterDeterminedAnimationController.animateTo(1);
          },
          orElse: () {},
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    _afterDeterminedAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double circleSize = MediaQuery.of(context).size.width / 5;
    const double appBarHeight = 70;
    final double correctSlidingUpColorsWidget = appBarHeight + MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<TensorCubit, TensorState>(
        builder: (BuildContext context, TensorState tensorState) {
          return BlocProvider(
            create: (BuildContext context) => getIt<ColorsDetectedCubit>(),
            child: BlocBuilder<ColorsDetectedCubit, ColorsDetectedState>(
              builder: (BuildContext context, ColorsDetectedState colorsDetectedState) {
                return ColorsDetectedBody(
                  isSlidingUpColorsWidgetExpanded: colorsDetectedState.isSlidingUpColorsWidgetExpanded,
                  correctSlidingUpColorsWidget: correctSlidingUpColorsWidget,
                  circleSize: circleSize,
                  isColorDetermination: colorsDetectedState.isColorDetermination,
                  loadingAnimationController: _loadingAnimationController,
                  afterDeterminedAnimationController: _afterDeterminedAnimationController,
                  image: tensorState.image,
                  pixels: tensorState.pixels,
                  compatibleDeterminedColors: tensorState.compatibleDeterminedColors,
                  selectedPixelIndex: colorsDetectedState.selectedPixelIndex,
                  selectPixel: BlocProvider.of<ColorsDetectedCubit>(context).selectPixel,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
