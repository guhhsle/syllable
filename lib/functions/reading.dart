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
  bool needsClearing = false;
  bool clearing = false, jumping = false;
  int columns = 0;

  bool get animating => clearing || jumping;

  var dots = [0, 0, 0, 0];
  var lags = [0];
  String _loadedText = '';
  int loadedTextLength = 0;
  void set loadedText(String text) {
    _loadedText = text;
    loadedTextLength = text.length;
  }

  String get loadedText => _loadedText;

  bool get valid {
    for (int i = 1; i < 4; i++) {
      if (dots[i] >= loadedTextLength - 1) return false;
      if (dots[i] < dots[i - 1]) return false;
    }
    return true;
  }

  Future nextSyllable() async {
    final backup = dots.toList();
    if (!valid) return;
    jumping = true;
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
    if (!valid) dots = backup.toList();
    jumping = false;
    notifyListeners();
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
    final ts = textKey.currentContext?.findRenderObject() as RenderBox;
    double charWidth = ts.size.width / 9;
    double devWidth = MediaQuery.of(navigatorKey.currentContext!).size.width;
    devWidth -= 16; //16 Padding
    columns = devWidth ~/ charWidth;

    needsClearing = true;
    clearRowIfNeeded();
  }

  Future clearRowIfNeeded({DateTime? builtOn}) async {
    if (dots[0] < columns * 2) {
      needsClearing = false;
      clearing = false;
      Pref.position.set(position);
    } else if (!clearing && needsClearing) {
      clearing = true;
      Duration timePassed = Duration.zero;
      if (builtOn != null) timePassed = DateTime.now().difference(builtOn);
      lags.add(timePassed.inMilliseconds);
      if (lags.length > 20) lags.removeAt(0);
      int waitFor = Pref.animation.value - timePassed.inMilliseconds;
      if (waitFor < 0) waitFor = 0;
      await Future.delayed(Duration(milliseconds: waitFor));
      clearRow();
      clearing = false;
      notifyListeners();
    }
  }

  void clearRow() {
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
