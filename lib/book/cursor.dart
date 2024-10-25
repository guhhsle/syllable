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
    skipCursorStartToChar();

    if (dots[2] > dots[3]) dots[2] = dots[3];
    if (!valid) dots = backup.toList();
    jumping = false;
    notify();
  }

  void skipCursorStartToChar() {
    while (!loadedText[dots[1]].isNormal) {
      if (dots[1] >= dots[2] - 1) {
        if (dots[2] >= dots[3]) break;
        dots[2]++;
      }
      dots[1]++;
    }
  }

  void skipSentenceStartToChar() {
    while (!loadedText[dots[0]].isNormal) {
      if (dots[0] >= dots[3]) break;
      dots[0]++;
    }
    dots[2] = dots[1] = dots[0];
  }

  void moveCursorEndBySyllable() {
    dots[2] += 2;
    while (!loadedText[dots[2]].isSyllable) {
      if (!loadedText[dots[2]].isNormal) break;
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
    while (loadedText[dots[2]].isNormal) {
      if (dots[2] > dots[3]) break;
      dots[2]++;
    }
  }

  void moveCursorEndBy1() => dots[2] += 1;
  void moveCursorEndBy2() => dots[2] += 2;
  void moveCursorEndBy5() => dots[2] += 5;

  Future nextSentence() async {
    int offset = 16; //Minimal sentence length
    int oldSentenceEnd = dots[3];
    while (dots[3] + offset + 1 < loadedTextLength) {
      if (loadedText[dots[3] + offset].endsSentence) break;
      offset++;
    }
    await animateDotOffset(3, offset);

    dots[0] = dots[1] = dots[2] = oldSentenceEnd;
    skipSentenceStartToChar();
  }
}
