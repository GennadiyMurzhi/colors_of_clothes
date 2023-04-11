bool isSelectedPixel(int index, int? selectedPixelIndex) {
  if (selectedPixelIndex == null) {
    return false;
  } else {
    return index == selectedPixelIndex;
  }
}
