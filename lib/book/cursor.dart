import 'package:flutter/material.dart';
import 'visual.dart';
import 'book.dart';
import '../data.dart';

extension Cursor on Book {
  Map<String, void Function()> get moveCursorEnd {
    return {
      '2 Syllables': moveCursorEndBy2Syllables,
      'Syllable': moveCursorEndBySyllable,
      'Word': moveCursorEndByWord,
      '1': moveCursorEndBy1,
      '2': moveCursorEndBy2,
      '5': moveCursorEndBy5,
    };
  }

  Future<bool> incrementCursorDot() async {
    cursorDot = cursorDot.clamp(realDots[1], realDots[2]) + 1;
    if (cursorDot >= realDots[2]) return moveCursor();
    if (!Pref.normalised.value) return moveCursor();
    return false;
  }

  Future<bool> moveCursor({List<List<int>>? checkpoints}) async {
    if (!valid && (checkpoints?.length ?? 6000) > 5000) return false;
    checkpoints ??= [];
    checkpoints.add(realDots.toList());
    try {
      if (realDots[2] >= realDots[3]) await nextSentence();
      checkpoints.add(realDots.toList());
      realDots[1] = realDots[2];

      skipCursorStartToChar();
      moveCursorEnd[Pref.cursorShift.value]!.call();

      if (realDots[2] > realDots[3]) realDots[2] = realDots[3];
      checkpoints.add(realDots.toList());
      if (!valid || !loadedText[realDots[1]].isNormal) {
        debugPrint('Special situation: $realDots');
        checkpoints.add(realDots.toList());
        if (checkpoints.length <= 5000 && realDots[3] < loadedTextLength) {
          if (await moveCursor(checkpoints: checkpoints)) return true;
        }
      }
      for (var checkpoint in checkpoints.reversed) {
        if (valid) break;
        realDots = checkpoint.toList();
      }
      if (!valid) {
        realDots = checkpoints[0];
        return false;
      }
      notify();
      return true;
    } catch (e) {
      debugPrint('Fatal error on moving cursor: $e');
      for (var checkpoint in checkpoints.reversed) {
        if (valid) break;
        realDots = checkpoint.toList();
      }
      return false;
    }
  }

  void skipCursorStartToChar() {
    while (!loadedText[realDots[1]].isNormal) {
      if (realDots[1] >= realDots[2] - 1) {
        if (realDots[2] >= realDots[3]) break;
        realDots[2]++;
      }
      realDots[1]++;
    }
  }

  void skipSentenceStartToChar() {
    while (!loadedText[realDots[0]].isNormal) {
      if (realDots[0] >= realDots[3]) break;
      realDots[0]++;
    }
    realDots[2] = realDots[1] = realDots[0];
  }

  void moveCursorEndBySyllable() {
    realDots[2] += 2;
    while (!loadedText[realDots[2]].isSyllable) {
      if (!loadedText[realDots[2]].isNormal) break;
      if (realDots[2] > realDots[3]) break;
      realDots[2]++;
    }
  }

  void moveCursorEndBy2Syllables() {
    moveCursorEndBySyllable();
    moveCursorEndBySyllable();
  }

  void moveCursorEndByWord() {
    realDots[2] += 2;
    while (loadedText[realDots[2]].isNormal) {
      if (realDots[2] > realDots[3]) break;
      realDots[2]++;
    }
  }

  void moveCursorEndBy1() => realDots[2] += 1;
  void moveCursorEndBy2() => realDots[2] += 2;
  void moveCursorEndBy5() => realDots[2] += 5;

  Future nextSentence() async {
    realDots[0] = realDots[1] = realDots[2] = realDots[3];
    realDots[3] += 16;
    while (realDots[3] + 1 < loadedTextLength) {
      if (loadedText[realDots[3]].endsPhrase) break;
      realDots[3]++;
    }
    skipSentenceStartToChar();
  }
}
