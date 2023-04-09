import 'package:colors_of_clothes/domen/determined_pixels.dart';
import 'package:flutter/painting.dart';

List<Color> determinedPixelToColors(DeterminedPixels pixels) => List.generate(
    pixels.pixelList.length, (index) => pixels.pixelList[index].color);
