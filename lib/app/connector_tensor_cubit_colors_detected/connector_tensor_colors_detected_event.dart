import 'package:freezed_annotation/freezed_annotation.dart';

part 'connector_tensor_colors_detected_event.freezed.dart';

@freezed
class ConnectorTensorColorsDetectedEvent with _$ConnectorTensorColorsDetectedEvent{
  factory ConnectorTensorColorsDetectedEvent.colorsDetermined() = ColorsDetermined;
  factory ConnectorTensorColorsDetectedEvent.colorsNotDetermined() = ColorsNotDetermined;
  factory ConnectorTensorColorsDetectedEvent.colorsDeterminedAnimateIsEnded() = ColorsNotDeterminedAnimateIsEnded;
}

