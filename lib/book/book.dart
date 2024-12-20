import 'package:flutter/material.dart';
import 'animations.dart';
import 'library.dart';
import 'images.dart';
import 'clear.dart';
import '../functions.dart';
import '../data.dart';

const initText = '> Library\n> Import';

class Book with ChangeNotifier {
  String title;
  int lineOffset = 0, charOffset = 0, animDuration = 0;
  int position = 0, length = initText.length, columns = 0, cursorDot = 0;
  var shadowDots = [0, 0, 0, 0], realDots = [0, 0, 0, 0], charHeight = 0.0;
  var _loadedText = initText, loadedTextLength = 0, _fullText = initText;
  var clearing = false, jumping = false, needsClearing = false;
  var displayedImages = <String>[];

  String get loadedText => _loadedText;
  void set loadedText(String text) {
    _loadedText = text;
    loadedTextLength = _loadedText.length;
    scanDisplayedImages();
  }

  Book(this.title) {
    addListener(manifestDotsIfNeeded);
    addListener(clearIfNeeded);
  }

  String get fullText => _fullText;
  void set fullText(String text) {
    _fullText = text;
    length = _fullText.length;
  }

  void notify() => notifyListeners();

  String get percentage {
    bool addZero = position / length < 0.1;
    String percent = (position * 100 / length).toStringAsFixed(2);
    return ' ${addZero ? '0' : ''}$percent % ';
  }

  String get formatTitle => cleanFileName(title);

  void open() {
    Pref.book.set(title);
    jumpTo(position);
    Library().loadCurrent();
    notify();
  }

  bool get valid {
    for (int i = 1; i < 4; i++) {
      if (realDots[i] >= loadedTextLength - 1) return false;
      if (realDots[i] < realDots[i - 1]) return false;
    }
    return true;
  }

  String get path => '${Library.path}/$title';
}
