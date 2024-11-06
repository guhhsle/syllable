import 'package:flutter/material.dart';
import 'book.dart';
import '../template/data.dart';
import '../data.dart';

extension VisualFormatting on String {
  bool get isSyllable => Pref.syllables.value.contains(this);
  bool get isNormal => !splitsWord && !endsSentence && !isMark;
  bool get isMark => contains(RegExp(r'["""”“„‟' '‚‛`´»«›‹]'));
  //bool get isErasedOnEndl => contains(RegExp(r'[ \t\n\r]'));
  //Previous RegExp(r'(\s+)|(?=[.,;!?]) -|—'));
  //Maybe even these:  ; -
  bool get splitsWord {
    return contains(RegExp(r'(\s+)|[-–—_/\\:\n\t\r|•…\[\]{}<>+=' ']'));
  }

  bool get endsSentence {
    return Pref.breakpoints.value.contains(this) || this == '\n';
  }
}

extension Visual on Book {
  void loadVisualInfo() {
    final ts = textKey.currentContext?.findRenderObject() as RenderBox;
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
