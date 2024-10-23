import 'package:flutter/material.dart';
import '../template/data.dart';
import '../data.dart';

extension VisualFormatting on String {
  bool get endsSentence => Pref.breakpoints.value.contains(this);
  bool get splitsWord => contains(RegExp(r'(\s+)|(?=[.,;!?]) -—'));
  bool get isSyllable => Pref.syllables.value.contains(this);
}

class Book extends ChangeNotifier {
  static final instance = Book.internal();
  factory Book() => instance;
  Book.internal();

  int length = 0;
  bool clearing = false;
  final position = ValueNotifier(0);

  List<int> dots = [0, 0, 0, 0];
  String _loadedText = '';
  int loadedTextLength = 0;
  void set loadedText(String text) {
    _loadedText = text;
    loadedTextLength = text.length;
  }

  String get loadedText => _loadedText;

  Future nextSyllable() async {
    if (dots[2] >= dots[3]) await nextSentence();
    clearing = true;
    dots[1] = dots[2];
    dots[2] += 2;

    if (Pref.cursorShift.value.contains('Syllable')) {
      while (!loadedText[dots[2]].isSyllable && dots[2] <= dots[3]) {
        dots[2]++;
      }
    }
    if (Pref.cursorShift.value == '2 Syllables') {
      dots[2] += 2;
      while (!loadedText[dots[2]].isSyllable && dots[2] <= dots[3]) {
        dots[2]++;
      }
    } else if (Pref.cursorShift.value == '1') {
      dots[2]--;
    } else if (Pref.cursorShift.value == '5') {
      dots[2] += 3;
    }
    if (dots[2] > dots[3]) dots[2] = dots[3];
    notifyListeners();
    clearing = false;
  }

  Future nextSentence() async {
    int offset = 16;
    while (dots[3] + offset + 1 < loadedTextLength) {
      if (loadedText[dots[3] + offset].endsSentence) break;
      offset++;
    }
    await animateOffset(3, offset);
    dots[0] = dots[1] = dots[2] += 2;
  }

  Future clear() async {
    clearing = true;
    final ts = textKey.currentContext?.findRenderObject() as RenderBox;
    double charWidth = ts.size.width / 9;
    double devWidth = MediaQuery.of(navigatorKey.currentContext!).size.width;
    devWidth -= 16; //16 Padding
    int row = devWidth ~/ charWidth;
    int newPosition = position.value;

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
      position.value += i;
      loadMore();
      if (Pref.animation.value > 0) {
        notifyListeners();
        await Future.delayed(Duration(milliseconds: Pref.animation.value));
      }
      newPosition += i;
    }
    position.value = newPosition;
    Pref.position.set(position.value);
    notifyListeners();
    clearing = false;
  }

  Future animateOffset(int j, int inc) async {
    if (Pref.animation.value > 0) {
      const int div = 10;
      int step = (inc / div).floor();
      for (int i = 0; i < div; i++) {
        dots[j] += step;
        if (dots[2] < dots[3]) {
          notifyListeners();
          await Future.delayed(
            Duration(milliseconds: Pref.animation.value),
          );
        }
      }
      dots[j] += inc % div;
    } else {
      dots[j] += inc;
    }
  }

  void resetLoadedText() {
    int? nextEnd = position.value + Pref.preload.value;
    if (nextEnd > length) nextEnd = null;
    loadedText = Pref.book.value.substring(position.value, nextEnd);
  }

  void loadMore() {
    int currentEnd = position.value + loadedTextLength;
    int? nextEnd = position.value + Pref.preload.value;
    if (nextEnd <= currentEnd) return;
    if (nextEnd > length) nextEnd = null;
    loadedText += Pref.book.value.substring(currentEnd, nextEnd);
  }

  void jumpTo(int i) {
    position.value = i;
    int end = i + Pref.preload.value;
    length = Pref.book.value.length;
    if (end > length) end = length;
    loadedText = Pref.book.value.substring(i, end);
    Pref.position.set(i);
    dots = [0, 0, 0, 0];
    notifyListeners();
  }
}
