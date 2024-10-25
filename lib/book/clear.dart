import 'visual.dart';
import 'book.dart';
import '../data.dart';

extension Clear on Book {
  void stopClearing() {
    needsClearing = false;
    clearing = false;
  }

  void clearRow() {
    int i = 0;
    while (i < columns && loadedText[charOffset + i] != '\n') {
      i++;
    }
    while (i > 0 && !loadedText[charOffset + i].splitsWord) {
      i--;
    }
    i++;
    if (charOffset + i > dots[0]) return stopClearing();
    charOffset += i;
    visualLineOffset -= charHeight;
  }

  Future<void> clearRows() async {
    animDuration = Pref.animation.value;
    needsClearing = clearing = true;
    loadVisualInfo();
    while (needsClearing) {
      clearRow();
    }
    loadMore(charOffset);
    notify();
    await Future.delayed(Duration(milliseconds: animDuration));
    normaliseOffset();
    notify();
  }

  void normaliseOffset() {
    loadedText = loadedText.substring(charOffset);
    visualLineOffset = 0;
    animDuration = 0;
    for (int j = 0; j < dots.length; j++) {
      dots[j] -= charOffset;
    }
    position += charOffset;
    Pref.position.set(position);
    charOffset = 0;
    if (loadedTextLength != Pref.preload.value) resetLoadedText();
  }

  void resetLoadedText() {
    int? nextEnd = position + Pref.preload.value;
    if (nextEnd > length) nextEnd = null;
    loadedText = Pref.book.value.substring(position, nextEnd);
    notify();
  }

  void loadMore(int addition) {
    int currentEnd = position + loadedTextLength;
    int? nextEnd = currentEnd + addition;
    if (nextEnd <= currentEnd) return;
    if (nextEnd > length) nextEnd = null;
    loadedText += Pref.book.value.substring(currentEnd, nextEnd);
  }
}
