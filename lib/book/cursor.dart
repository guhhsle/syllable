import '../data.dart';
import 'book.dart';

extension Cursor on Book {
  Map<String, void Function()> get cursorMoves {
    return {
      '2 Syllables': moveCursorEndBy2Syllables,
      'Syllable': moveCursorEndBySyllable,
      'Word': moveCursorEndByWord,
      '1': moveCursorEndBy1,
      '2': moveCursorEndBy2,
      '5': moveCursorEndBy5,
    };
  }

  Future moveCursor() async {
    final backup = dots.toList();
    if (!valid) return;
    jumping = true;
    if (dots[2] >= dots[3]) await nextSentence();
    dots[1] = dots[2];

    cursorMoves[Pref.cursorShift.value]!.call();
    skipCursorStartOnSpace();

    if (dots[2] > dots[3]) dots[2] = dots[3];
    if (!valid) dots = backup.toList();
    jumping = false;
    notify();
  }

  void skipCursorStartOnSpace() {
    while (loadedText[dots[1]].splitsWord) {
      if (dots[1] >= dots[2] - 1) {
        if (dots[2] >= dots[3]) break;
        dots[2]++;
      }
      dots[1]++;
    }
  }

  void moveCursorEndBySyllable() {
    dots[2] += 2;
    while (!loadedText[dots[2]].isSyllable) {
      if (loadedText[dots[2]].splitsWord) break;
      if (dots[2] > dots[3]) break;
      dots[2]++;
    }
  }

  void moveCursorEndBy2Syllables() {
    moveCursorEndBySyllable();
    moveCursorEndBySyllable();
  }

  void moveCursorEndByWord() {
    dots[2] += 2;
    while (!loadedText[dots[2]].splitsWord) {
      if (dots[2] > dots[3]) break;
      dots[2]++;
    }
  }

  void moveCursorEndBy1() => dots[2] += 1;
  void moveCursorEndBy2() => dots[2] += 2;
  void moveCursorEndBy5() => dots[2] += 5;

  Future nextSentence() async {
    int offset = 16; //Minimal sentence length
    while (dots[3] + offset + 1 < loadedTextLength) {
      if (loadedText[dots[3] + offset].endsSentence) break;
      offset++;
    }
    await animateOffset(3, offset);
    dots[0] = dots[1] = dots[2] += 2;
  }
}
