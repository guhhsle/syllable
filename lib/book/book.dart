import 'package:flutter/material.dart';
import 'library.dart';
import 'cursor.dart';
import '../data.dart';

extension VisualFormatting on String {
  bool get isMark => contains(RegExp(r'["""”“„‟' '‚‛`´»«›‹]'));
  //bool get isErasedOnEndl => contains(RegExp(r'[ \t\n\r]'));
  //Prosli RegExp(r'(\s+)|(?=[.,;!?]) -|—'));
  //Mozda i sledece  ; -
  bool get splitsWord =>
      contains(RegExp(r'(\s+)|[-–—_/\\:\n\t\r|•…\[\]{}<>+=' ']'));
  bool get endsSentence =>
      Pref.breakpoints.value.contains(this) || this == '\n';
  bool get isSyllable => Pref.syllables.value.contains(this);
  bool get isNormal => !splitsWord && !endsSentence && !isMark;
}

class Book extends ChangeNotifier {
  final key = GlobalKey();
  static final instance = Book.internal();
  factory Book() => instance;
  Book.internal();

  bool clearing = false, jumping = false;
  int length = 0, position = 0;
  bool needsClearing = false;
  double charHeight = 0;
  int columns = 0;

  var dots = [0, 0, 0, 0];
  String fullText = '', _loadedText = '';
  int loadedTextLength = 0;
  void set loadedText(String text) {
    _loadedText = text;
    loadedTextLength = text.length;
  }

  bool get animating => clearing || jumping;
  String get loadedText => _loadedText;

  int lineOffset = 0, charOffset = 0;
  int animDuration = 0;

  void notify() => instance.notifyListeners();

  bool get valid {
    for (int i = 1; i < 4; i++) {
      if (dots[i] >= loadedTextLength - 1) return false;
      if (dots[i] < dots[i - 1]) return false;
    }
    return true;
  }

  Future jumpTo(int i) async {
    i = i.clamp(0, length - 1);
    position = i;
    int end = i + Pref.preload.value;
    if (end > length) end = length;
    loadedText = fullText.substring(i, end);
    LibraryBook.current.tryToSetPosition(i);
    dots = [0, 0, 0, 0];
    await moveCursor();
    dots[0] = dots[1] = 0;
    notifyListeners();
  }

  Future animateDots(List<int> from, List<int> to) async {
    dots = from.toList();
    if (Pref.cursorAnimation.value > 0) {
      final longerTail = to[0] - from[0] > to[3] - from[3];
      while (true) {
        if (to[0] > dots[0]) dots[0]++;
        if (to[0] > dots[0] && longerTail && dots[0] < dots[1]) dots[0]++;
        if (to[1] > dots[1]) dots[1]++;
        if (to[2] > dots[2]) dots[2]++;
        if (to[3] > dots[3]) dots[3]++;
        notifyListeners();
        await Future.delayed(Duration(
          milliseconds: Pref.cursorAnimation.value,
        ));
        if (to[0] > dots[0]) continue;
        if (to[1] > dots[1]) continue;
        if (to[2] > dots[2]) continue;
        if (to[3] > dots[3]) continue;
        break;
      }
    } else {
      dots = to.toList();
    }
  }
}
