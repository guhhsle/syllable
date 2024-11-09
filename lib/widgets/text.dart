import 'package:flutter/material.dart';
import '../book/library.dart';
import '../book/visual.dart';
import '../book/book.dart';
import '../data.dart';

class BookText extends StatelessWidget {
  const BookText({super.key});

  Book get current => Library().current;
  String get text => current.loadedText;
  List<int> get dots => current.dots;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semi = TextStyle(
      backgroundColor: cs.primary.withOpacity(Pref.phraseOpacity.value / 100),
      color: Pref.phraseOpacity.value < 50 ? cs.primary : cs.surface,
    );
    final full = TextStyle(backgroundColor: cs.primary, color: cs.surface);
    final non = TextStyle(color: cs.primary);

    final font = TextStyle(
      fontWeight: FontWeight.values[Pref.fontBold.value ? 8 : 0],
      fontSize: Pref.fontSize.value.toDouble(),
      fontFamily: Pref.font.value,
    );

    final textAlign = TextAlign.values.byName(
      Pref.fontAlign.value.toLowerCase(),
    );

    return Stack(
      children: [
        ListenableBuilder(
          listenable: Library(),
          builder: (context, child) => AnimatedPositioned(
            duration: Duration(milliseconds: current.animDuration),
            //easeInOutCubic
            curve: Curves.ease,
            top: current.lineOffsetToVisual,
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                overflow: TextOverflow.fade,
                textAlign: textAlign,
                text: TextSpan(
                  style: font,
                  children: [
                    TextSpan(text: text.substring(0, dots[0]), style: non),
                    TextSpan(
                        text: text.substring(dots[0], dots[1]), style: semi),
                    TextSpan(
                        text: text.substring(dots[1], dots[2]), style: full),
                    TextSpan(
                        text: text.substring(dots[2], dots[3]), style: semi),
                    TextSpan(text: text.substring(dots[3]), style: non),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 10,
          color: cs.surface,
        ),
      ],
    );
  }
}
