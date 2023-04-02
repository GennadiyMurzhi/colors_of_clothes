import 'dart:math';

import 'package:colors_of_clothes/domen/tensor_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

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
    List<int> inputShape = interpreter.getInputTensor(0).shape;
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

  bool predictPeople(img.Image image) {
    if (kDebugMode) {
      print('Image: ${image.width}x${image.height}');
      print('size: ${image.length} bytes');
    }

    final TensorImage inputImage = _preProcessInput(image);

    if (kDebugMode) {
      print('Pre-processed image: ${inputImage.width}x${image.height}');
      print('size: ${inputImage.buffer.lengthInBytes} bytes');
    }

    // Stores the final scores of your prediction in raw format
    final TensorBuffer outputBuffer = TensorBuffer.createFixedSize(
      _model.outputShape,
      _model.outputType,
    );

    // Interpreter reads the tensor image and stores the output in the buffer
    _model.interpreter.run(inputImage.buffer, outputBuffer.buffer);
    if (kDebugMode) {
      print('OutputBuffer: ${outputBuffer.getDoubleList()}');
    }

    final double peopleScore = _postProcessOutput(outputBuffer);

    final bool isPeople;
    if(peopleScore >= 0.8) {
      isPeople = true;
    } else {
      isPeople = false;
    }

    return isPeople;
  }

  /// Preprocesses the Image object so that it becomes the required TensorImage
  TensorImage _preProcessInput(img.Image image) {
    // Create the TensorImage and load the image data to it
    final TensorImage inputTensor = TensorImage(_model.inputType);
    inputTensor.loadImage(image);

    // Crop the image to a square shape
    final int minLength = min(inputTensor.height, inputTensor.width);
    final cropOp = ResizeWithCropOrPadOp(minLength, minLength);

    // Resize the image operation to fit the shape requirements of the model
    final int shapeLength = _model.inputShape[1];
    final ResizeOp resizeOp =
        ResizeOp(shapeLength, shapeLength, ResizeMethod.BILINEAR);

    // Normalize the value of the data. Argument 127.5 is selected because of your
    // trained model’s parameters. You want to convert image’s pixel 0-255 value to -1...1 range
    final NormalizeOp normalizeOp = NormalizeOp(127.5, 127.5);

    // Create the image processor with the defined operation and preprocess the image.
    final ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(cropOp)
        .add(resizeOp)
        .add(normalizeOp)
        .build();

    imageProcessor.process(inputTensor);

    // Return the preprocessed image.
    return inputTensor;
  }

  double _postProcessOutput(TensorBuffer outputBuffer) {
    // Parse and process the output
    final SequentialProcessor<TensorBuffer> probabilityProcessor = TensorProcessorBuilder().build();

    probabilityProcessor.process(outputBuffer);

    // Map output values to your labels
    // final TensorLabel labelledResult = TensorLabel.fromList(_labels, outputBuffer);

    if(kDebugMode) {
      print('getDoubleValue ${outputBuffer.getDoubleValue(0)}');
    }

    return outputBuffer.getDoubleValue(0);

  }
}
