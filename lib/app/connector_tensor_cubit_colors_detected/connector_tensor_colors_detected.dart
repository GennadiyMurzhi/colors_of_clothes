import 'dart:async';

import 'package:colors_of_clothes/app/connector_tensor_cubit_colors_detected/connector_tensor_colors_detected_event.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton()
class ConnectorTensorColorsDetected {
  ConnectorTensorColorsDetected()
      : _stream = BehaviorSubject<ConnectorTensorColorsDetectedEvent>(),
        _compositeSubscription = CompositeSubscription();

  BehaviorSubject<ConnectorTensorColorsDetectedEvent> _stream;
  final CompositeSubscription _compositeSubscription;

  void addEvent(ConnectorTensorColorsDetectedEvent event) {
    _stream.add(event);
  }

  void addListener(void Function(ConnectorTensorColorsDetectedEvent event) onData) {
    _compositeSubscription.add(_stream.stream.listen(onData));
  }

  Future<void> clear() async {
    await _compositeSubscription.clear();
    _stream.close();
    _stream = BehaviorSubject<ConnectorTensorColorsDetectedEvent>();
  }
}
