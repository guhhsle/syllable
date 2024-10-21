import 'package:flutter/material.dart';
import 'frame.dart';
import '../template/functions.dart';
import '../functions/reading.dart';
import '../template/settings.dart';
import '../data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    List<Color?> highlights = [
      null,
      cs.primary.withOpacity(0.6),
      cs.primary,
      cs.primary.withOpacity(0.6),
      null,
    ];
    return ListenableBuilder(
      listenable: Book(),
      builder: (context, child) {
        double distance = 0;
        int pos = Book().position + Book().dots[1];
        bool addZero = pos / Book().length < 0.1;
        String percent = '${(pos * 100 / Book().length).toStringAsFixed(2)} %';
        return Frame(
          title: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () async => Book().jumpTo(int.parse(await getInput(
              pos,
              'Jump to position',
            ))),
            child: Text(
              ' ${addZero ? '0' : ''}$percent ',
              key: textKey,
              style: TextStyle(
                fontSize: Pref.fontSize.value.toDouble(),
                fontWeight: FontWeight.values[Pref.fontBold.value ? 8 : 0],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => goToPage(const PageSettings()),
              icon: const Icon(Icons.menu_rounded),
            ),
          ],
          child: GestureDetector(
            onPanEnd: (details) => Book().clearThreshold(),
            onPanUpdate: (d) async {
              if (Book().clearing) return;
              if (Pref.exponential.value) {
                distance += d.delta.distanceSquared * Pref.intensity.value;
              } else {
                distance += d.delta.distance * Pref.intensity.value;
              }
              while (distance > 1000) {
                await Book().nextSyllable();
                distance -= 1000;
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.values.byName(
                    Pref.fontAlign.value.toLowerCase(),
                  ),
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight:
                          FontWeight.values[Pref.fontBold.value ? 8 : 0],
                      color: cs.primary,
                      fontSize: Pref.fontSize.value.toDouble(),
                      fontFamily: 'JetBrainsMono',
                    ),
                    children: [
                      for (int i = 0; i < 5; i++)
                        TextSpan(
                          text: Book().loadedText.substring(
                              i == 0 ? 0 : Book().dots[i - 1],
                              i == 4 ? null : Book().dots[i]),
                          style: TextStyle(
                            backgroundColor: highlights[i],
                            color: i == 0 || i == 4 ? null : cs.surface,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
