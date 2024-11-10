import 'remember.dart';
import 'cursor.dart';
import 'book.dart';
import '../data.dart';

extension BookAnimations on Book {
  Future jumpTo(int i) async {
    i = i.clamp(0, length - 1);
    position = i;
    int end = i + Pref.preload.value;
    if (end > length) end = length;
    loadedText = fullText.substring(i, end);
    rememberPostion();
    realDots = [0, 0, 0, 0];
    shadowDots = [0, 0, 0, 0];
    await moveCursor();
    realDots[0] = realDots[1] = 0;
    shadowDots[0] = shadowDots[1] = 0;
    notify();
  }

  Future<void> manifestDotsIfNeeded() async {
    if (jumping) return;
    jumping = true;
    if (Pref.cursorDelay.value > 0) {
      while (true) {
        if (realDots[1] > shadowDots[1]) shadowDots[1]++;
        if (realDots[2] > shadowDots[2]) shadowDots[2]++;
        for (int i = 0; i < Pref.phraseMultiplier.value; i++) {
          if (realDots[0] > shadowDots[0]) {
            if (shadowDots[0] < shadowDots[1]) shadowDots[0]++;
          }
          if (realDots[3] > shadowDots[3]) shadowDots[3]++;
        }
        notify();
        await Future.delayed(Duration(
          milliseconds: Pref.cursorDelay.value,
        ));
        if (realDots[0] > shadowDots[0]) continue;
        if (realDots[1] > shadowDots[1]) continue;
        if (realDots[2] > shadowDots[2]) continue;
        if (realDots[3] > shadowDots[3]) continue;
        break;
      }
    } else {
      shadowDots = realDots.toList();
    }
    jumping = false;
  }
}
