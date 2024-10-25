import 'package:flutter/material.dart';
import 'position.dart';
import 'frame.dart';
import 'text.dart';
import '../template/functions.dart';
import '../template/settings.dart';
import '../book/cursor.dart';
import '../book/clear.dart';
import '../book/book.dart';
import '../data.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double distance = 0;
    return Frame(
      title: BookPosition(),
      actions: [
        IconButton(
          onPressed: () => goToPage(const PageSettings()),
          icon: const Icon(Icons.menu_rounded),
        ),
      ],
      child: GestureDetector(
        onPanEnd: (d) => Book().clearRows(),
        onPanUpdate: (d) async {
          if (Book().animating) return;
          if (Pref.exponential.value) {
            distance += d.delta.distanceSquared * Pref.intensity.value;
          } else {
            distance += d.delta.distance * Pref.intensity.value;
          }
          while (distance > 1000) {
            await Book().moveCursor();
            distance -= 1000;
          }
        },
        child: BookText(),
      ),
    );
  }
}
