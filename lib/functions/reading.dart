import 'package:flutter/material.dart';
import '../template/data.dart';
import '../data.dart';

String text = '';
ValueNotifier<List<int>> dots = ValueNotifier([0, 0, 0, 0]);

List<int> d = [0, 0, 0, 0];

Future nextSyllable() async {
  d = dots.value.toList();
  clearing = true;
  if (d[0] > Pref.clearTreshold.value) await clearThreshold(false);

  if (text.length - d[3] < Pref.preload.value) {
    int currentEnd = position + text.length;
    int? nextEnd = currentEnd + Pref.preload.value;
    if (nextEnd > Pref.book.value.length) nextEnd = null;
    text += Pref.book.value.substring(currentEnd, nextEnd);
  }
  await moveCursor();
  if (d[2] >= d[3]) await expandBehind();
  dots.value = d.toList();
  clearing = false;
}

Future<void> moveCursor() async {
  d[1] = d[2];
  d[2] += 2;
  String shift = Pref.cursorShift.value;
  if (shift.contains('Syllable')) {
    while (!Pref.syllables.value.contains(text[d[2]])) {
      if (d[2] >= d[3]) await expandBehind();
      d[2]++;
    }
  }
  if (shift == '2 Syllables') {
    d[2] += 2;
    while (!Pref.syllables.value.contains(text[d[2]])) {
      if (d[2] >= d[3]) await expandBehind();
      d[2]++;
    }
  } else if (shift == '1') {
    d[2]--;
  } else if (shift == '5') {
    d[2] += 3;
  }
}

Future<void> expandBehind() async {
  int offset = 16;
  Pref.position.set(position + d[1]);
  final int load = Pref.preload.value ~/ 5;
  while (
      offset < load && !Pref.breakpoints.value.contains(text[d[3] + offset])) {
    offset++;
  }
  offset++;
  await animateOffset(3, offset);
  d[0] = d[1] = d[2];
  await moveCursor();
}

Future animateOffset(int j, int inc) async {
  if (Pref.animations.value) {
    const int div = 10;
    int step = (inc / div).floor();
    for (int i = 0; i < div; i++) {
      d[j] += step;
      if (d[2] < d[3]) {
        dots.value = d.toList();
        await Future.delayed(const Duration(milliseconds: 2));
      }
    }
    d[j] += inc % div;
  } else {
    d[j] += inc;
  }
}

Future clearThreshold(bool auto) async {
  clearing = true;
  RenderBox ts = textKey.currentContext?.findRenderObject() as RenderBox;
  double charWidth = ts.size.width / 9;
  double devWidth =
      MediaQuery.of(navigatorKey.currentContext!).size.width - 16; //16 Padding
  int row = devWidth ~/ charWidth;

  while (d[0] > row * 2) {
    int i = 0;
    while (i < row && text[i] != '\n') {
      i++;
    }
    while (i > 0 && !text[i].contains(RegExp(r'(\s+)|(?=[.,;!?]) -—'))) {
      i--;
    }
    i++;
    text = text.substring(i);
    for (int j = 0; j < d.length; j++) {
      d[j] -= i;
    }
    if (Pref.animations.value) {
      dots.value = d.toList();
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }
  position = Pref.book.value.indexOf(text.substring(0, d[3]));
  dots.value = d.toList();
  clearing = false;
}

void jumpTo(int i) {
  position = i;
  int end = i + Pref.preload.value;
  bookLen = Pref.book.value.length;
  if (end > bookLen) end = bookLen;
  text = Pref.book.value.substring(i, end);
  Pref.position.set(i);
  dots.value = [0, 0, 0, 0];
}
