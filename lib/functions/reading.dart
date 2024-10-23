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

  int length = 0, position = 0;
  bool clearing = false;

  List<int> dots = [0, 0, 0, 0];
  String _loadedText = '';
  int loadedTextLength = 0;
  void set loadedText(String text) {
    _loadedText = text;
    loadedTextLength = text.length;
  }

  String get loadedText => _loadedText;

  Future nextSyllable() async {
    if (dots[2] >= loadedTextLength - 1) return;
    clearing = true;
    if (dots[2] >= dots[3]) await nextSentence();
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
    int columns = devWidth ~/ charWidth;

    var futures = <Future>[];

    int offset = 0, row = 0;
    while (offset + columns * 2 < dots[0]) {
      int i = 0;
      while (i < columns && loadedText[offset + i] != '\n') {
        i++;
      }
      while (i > 0 && !loadedText[offset + i].splitsWord) {
        i--;
      }
      i++;
      offset += i;
      futures.add(clearRow(row++, columns));
    }
    await Future.wait(futures);
    notifyListeners();
    Pref.position.set(position);
    clearing = false;
  }

  Future clearRow(int row, int columns) async {
    await Future.delayed(Duration(milliseconds: Pref.animation.value * row));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: Pref.animation.value * row));
      int i = 0;
      while (i < columns && loadedText[i] != '\n') {
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
      position += i;
      loadMore();
      notifyListeners();
    });
  }

  Future animateOffset(int j, int inc) async {
    if (Pref.animation.value > 0) {
      const int div = 10;
      int step = (inc / div).floor();
      for (int i = 0; i < div; i++) {
        dots[j] += step;
        if (dots[2] < dots[3]) {
          notifyListeners();
          await Future.delayed(Duration(milliseconds: Pref.animation.value));
        }
      }
      dots[j] += inc % div;
    } else {
      dots[j] += inc;
    }
  }

  void resetLoadedText() {
    int? nextEnd = position + Pref.preload.value;
    if (nextEnd > length) nextEnd = null;
    loadedText = Pref.book.value.substring(position, nextEnd);
    notifyListeners();
  }

  void loadMore() {
    int currentEnd = position + loadedTextLength;
    int? nextEnd = position + Pref.preload.value;
    if (nextEnd <= currentEnd) return;
    if (nextEnd > length) nextEnd = null;
    loadedText += Pref.book.value.substring(currentEnd, nextEnd);
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
