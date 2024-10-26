import 'package:flutter/material.dart';
import 'book.dart';
import '../template/data.dart';

extension Visual on Book {
  void loadVisualInfo() {
    final ts = key.currentContext?.findRenderObject() as RenderBox;
    double charWidth = ts.size.width / 9;
    charHeight = ts.size.height;
    double devWidth = MediaQuery.of(
      navigatorKey.currentContext!,
    ).size.width;
    devWidth -= 16; //16 Padding
    columns = devWidth ~/ charWidth;
  }

  double get lineOffsetToVisual => -lineOffset * charHeight / 1;
}
