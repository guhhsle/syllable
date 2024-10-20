import 'package:flutter/material.dart';
import '../template/data.dart';
import '../data.dart';

extension VisualFormatting on String {
  bool get endsSentece => Pref.breakpoints.value.contains(this);
  bool get splitsWord => contains(RegExp(r'(\s+)|(?=[.,;!?]) -—'));
}

class Book extends ChangeNotifier {
  static final instance = Book.internal();
  factory Book() => instance;
  Book.internal();

  int length = 0;
  bool clearing = false;
  int position = Pref.preload.value;

  List<int> dots = [0, 0, 0, 0];
  String _loadedText = '';
  int loadedTextLength = 0;
  void set loadedText(String text) {
    _loadedText = text;
    loadedTextLength = text.length;
  }

  String get loadedText => _loadedText;

  Future nextSyllable() async {
    clearing = true;
    if (loadedTextLength - dots[3] < Pref.preload.value) {
      int currentEnd = position + loadedTextLength;
      int? nextEnd = currentEnd + Pref.preload.value;
      if (nextEnd > length) nextEnd = null;
      loadedText += Pref.book.value.substring(currentEnd, nextEnd);
    }
    await moveCursor();
    if (dots[2] >= dots[3]) await expandBehind();
    notifyListeners();
    clearing = false;
  }

  Future<void> moveCursor() async {
    dots[1] = dots[2];
    dots[2] += 2;
    String shift = Pref.cursorShift.value;
    if (shift.contains('Syllable')) {
      while (!Pref.syllables.value.contains(loadedText[dots[2]])) {
        if (dots[2] >= dots[3]) await expandBehind();
        dots[2]++;
      }
    }
    if (shift == '2 Syllables') {
      dots[2] += 2;
      while (!Pref.syllables.value.contains(loadedText[dots[2]])) {
        if (dots[2] >= dots[3]) await expandBehind();
        dots[2]++;
      }
    } else if (shift == '1') {
      dots[2]--;
    } else if (shift == '5') {
      dots[2] += 3;
    }
  }

  Future<void> expandBehind() async {
    int offset = 16;
    Pref.position.set(position + dots[1]);
    final int load = Pref.preload.value ~/ 5;
    while (offset < load && !loadedText[dots[3] + offset].endsSentece) {
      offset++;
    }
    offset++;
    await animateOffset(3, offset);
    dots[0] = dots[1] = dots[2];
    await moveCursor();
  }

  Future animateOffset(int j, int inc) async {
    if (Pref.animations.value) {
      const int div = 10;
      int step = (inc / div).floor();
      for (int i = 0; i < div; i++) {
        dots[j] += step;
        if (dots[2] < dots[3]) {
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 2));
        }
      }
      dots[j] += inc % div;
    } else {
      dots[j] += inc;
    }
  }

  Future clearThreshold() async {
    clearing = true;
    RenderBox ts = textKey.currentContext?.findRenderObject() as RenderBox;
    double charWidth = ts.size.width / 9;
    double devWidth = MediaQuery.of(navigatorKey.currentContext!).size.width;
    devWidth -= 16; //16 Padding
    int row = devWidth ~/ charWidth;

    while (dots[0] > row * 2) {
      int i = 0;
      while (i < row && loadedText[i] != '\n') {
        i++;
      }
      while (i > 0 && !loadedText[i].splitsWord) {
        i--;
      }
      i++;
      loadedText = loadedText.substring(i);
      for (int j = 0; j < dots.length; j++) {
        dots[j] -= i;
      }
      if (Pref.animations.value) {
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 20));
      }
    }
    position = Pref.book.value.indexOf(loadedText.substring(0, dots[3]));
    notifyListeners();
    clearing = false;
  }

  void jumpTo(int i) {
    position = i;
    int end = i + Pref.preload.value;
    length = Pref.book.value.length;
    if (end > length) end = length;
    loadedText = Pref.book.value.substring(i, end);
    Pref.position.set(i);
    dots = [0, 0, 0, 0];
    notifyListeners();
  }
}
