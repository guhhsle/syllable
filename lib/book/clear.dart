import 'package:flutter/material.dart';
import 'book.dart';
import '../template/data.dart';
import '../data.dart';

extension Clear on Book {
  Future clear() async {
    final ts = textKey.currentContext?.findRenderObject() as RenderBox;
    double charWidth = ts.size.width / 9;
    double devWidth = MediaQuery.of(
      navigatorKey.currentContext!,
    ).size.width;
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
      notify();
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

  void resetLoadedText() {
    int? nextEnd = position + Pref.preload.value;
    if (nextEnd > length) nextEnd = null;
    loadedText = Pref.book.value.substring(position, nextEnd);
    notify();
  }

  void loadMore() {
    int currentEnd = position + loadedTextLength;
    int? nextEnd = position + Pref.preload.value;
    if (nextEnd <= currentEnd) return;
    if (nextEnd > length) nextEnd = null;
    loadedText += Pref.book.value.substring(currentEnd, nextEnd);
  }
}
