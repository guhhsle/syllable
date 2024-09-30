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
    return ValueListenableBuilder(
      valueListenable: dots,
      builder: (context, snap, child) {
        double distance = 0;
        int pos = position + snap[1];
        bool addZero = pos / bookLen < 0.1;
        String percent = '${(pos * 100 / bookLen).toStringAsFixed(2)} %';
        return Frame(
          title: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () async => jumpTo(int.parse(await getInput(
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
            onPanEnd: (details) async {
              if (!Pref.autoclear.value) return;
              d = snap.toList();
              await clearThreshold(true);
              dots.value = d.toList();
            },
            onPanUpdate: (d) async {
              if (!clearing) {
                if (Pref.exponential.value) {
                  distance += d.delta.distanceSquared * Pref.intensity.value;
                } else {
                  distance += d.delta.distance * Pref.intensity.value;
                }
                while (distance > 1000) {
                  await nextSyllable();
                  distance -= 1000;
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              width: double.infinity,
              height: double.infinity,
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
                          text: text.substring(
                              i == 0 ? 0 : d[i - 1], i == 4 ? null : d[i]),
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
