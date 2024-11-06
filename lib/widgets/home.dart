import 'package:flutter/material.dart';
import 'images_button.dart';
import 'position.dart';
import 'frame.dart';
import 'text.dart';
import '../template/functions.dart';
import '../template/settings.dart';
import '../book/cursor.dart';
import '../book/clear.dart';
import '../data.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
          current.value.needsClearing = true;
          current.value.checkForClearing();
        },
        onPanUpdate: (d) async {
          if (current.value.animating) return;
          if (Pref.exponential.value) {
            distance += d.delta.distanceSquared * Pref.intensity.value;
          } else {
            distance += d.delta.distance * Pref.intensity.value;
          }
          while (distance > 1000) {
            await current.value.moveCursor();
            distance -= 1000;
          }
        },
        child: BookText(),
      ),
    );
  }
}
