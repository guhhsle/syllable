import 'package:flutter/material.dart';
import 'images_button.dart';
import 'position.dart';
import 'frame.dart';
import 'text.dart';
import '../template/functions.dart';
import '../template/settings.dart';
import '../book/library.dart';
import '../book/cursor.dart';
import '../book/clear.dart';
import '../book/book.dart';
import '../data.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Book get current => Library().current;

  @override
  Widget build(BuildContext context) {
    double distance = 0;
    return Frame(
      title: BookPosition(),
      actions: [
        ImagesButton(),
        IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => goToPage(const PageSettings()),
        ),
      ],
      child: GestureDetector(
        onPanEnd: (d) {
          current.needsClearing = true;
          current.clearIfNeeded();
        },
        onPanUpdate: (d) async {
          if (Pref.exponential.value) {
            distance += d.delta.distanceSquared * Pref.intensity.value;
          } else {
            distance += d.delta.distance * Pref.intensity.value;
          }
          while (distance > 1000) {
            await current.incrementCursorDot();
            distance -= 1000;
          }
        },
        child: BookText(),
      ),
    );
  }
}
