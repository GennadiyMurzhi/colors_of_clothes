import 'package:colors_of_clothes/domen/tensor_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Tensor {
  Tensor._({
    required List<String> labels,
    required TensorModel model,
  })  : _labels = labels,
        _model = model;

  final List<String> _labels;
  final TensorModel _model;

  static Future<Tensor?> loadWith({
    required String labelsFileName,
    required String modelFileName,
  }) async {
    try {
      final List<String> labels = await _loadLabels(labelsFileName);
      final TensorModel model = await _loadModel(modelFileName);

      return Tensor._(labels: labels, model: model);
    } catch (e) {
      if (kDebugMode) {
        print('Can\'t initialize Classifier: ${e.toString()}');
        if (e is Error) {
          print(e.stackTrace);
        }
      }

      return null;
    }
  }

  static Future<List<String>> _loadLabels(String labelsFileName) async {
    // Loads the labels
    final String labelFileStrings = await rootBundle.loadString(labelsFileName);
    final List<String> indexedLabels = labelFileStrings.split('\n');
    //TODO: dangerous
    if (indexedLabels.last.isEmpty) {
      indexedLabels.removeAt(indexedLabels.length - 1);
    }

    // Removes the index number prefix from the labels you previously downloaded.
    final List<String> labels = indexedLabels
        .map((label) => label.substring(label.trim().indexOf(' ')).trim())
        .toList();

    if (kDebugMode) {
      print('Labels: $labels');
    }

    return labels;
  }

  static Future<TensorModel> _loadModel(String modelFileName) async {
    // Creates an interpreter with the provided model file — the interpreter is a tool to predict the result.
    final Interpreter interpreter = await Interpreter.fromAsset(modelFileName);

    // Read the input and output shapes, which you’ll use to conduct pre-processing and post-processing of your data.
    List<int> inputShape = interpreter.getInputTensors().shape;
    List<int> outputShape = interpreter.getOutputTensor(0).shape;

    if (kDebugMode) {
      print('Input shape: $inputShape');
      print('Output shape: $outputShape');
    }

    /// Read the input and output types so that you’ll know what type of data you have.
    final TfLiteType inputType = interpreter.getInputTensor(0).type;
    final TfLiteType outputType = interpreter.getOutputTensor(0).type;

    if (kDebugMode) {
      print('Input type: $inputType');
      print('Output output: $outputType');
    }

    return TensorModel(
      interpreter: interpreter,
      inputShape: inputShape,
      outputShape: outputShape,
      inputType: inputType,
      outputType: outputType,
    );
  }


}
