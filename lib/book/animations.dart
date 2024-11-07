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
    dots = [0, 0, 0, 0];
    await moveCursor();
    dots[0] = dots[1] = 0;
    notify();
  }

  Future animateDots(List<int> from, List<int> to) async {
    dots = from.toList();
    if (Pref.cursorAnimation.value > 0) {
      while (true) {
        if (to[1] > dots[1]) dots[1]++;
        if (to[2] > dots[2]) dots[2]++;
        for (int i = 0; i < Pref.cursorOuter.value; i++) {
          if (to[0] > dots[0] && dots[0] < dots[1]) dots[0]++;
          if (to[3] > dots[3]) dots[3]++;
        }
        notify();
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
