import 'package:flutter/material.dart';
import 'package:syllable/functions.dart';
import 'animations.dart';
import 'library.dart';
import 'images.dart';
import '../data.dart';

const initText = '> Library\n> Import';

class Book with ChangeNotifier {
  String title;
  int position = 0, length = initText.length, columns = 0;
  int lineOffset = 0, charOffset = 0, animDuration = 0;
  var clearing = false, jumping = false, needsClearing = false;
  var _loadedText = initText + 'l', loadedTextLength = 0, _fullText = initText;
  var charHeight = 0.0, dots = [0, 0, 0, 0];
  var displayedImages = <String>[];

  String get loadedText => _loadedText;
  void set loadedText(String text) {
    _loadedText = text;
    loadedTextLength = _loadedText.length;
    scanDisplayedImages();
  }

  Book(this.title);

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

  bool get animating => clearing || jumping;
  bool get valid {
    for (int i = 1; i < 4; i++) {
      if (dots[i] >= loadedTextLength - 1) return false;
      if (dots[i] < dots[i - 1]) return false;
    }
    return true;
  }

  String get path => '${Library.path}/$title';
}
