import 'package:flutter/material.dart';
import '../data.dart';
import '../functions/reading.dart';
import '../template/functions.dart';
import '../template/settings.dart';
import 'frame.dart';

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
            onTap: () async {
              int to = int.tryParse(await getInput('$pos')) ?? 0;
              jumpTo(to);
            },
            child: Text(
              ' ${addZero ? '0' : ''}$percent ',
              key: textKey,
              style: TextStyle(
                fontSize: pf['fontSize'].toDouble(),
                fontWeight: FontWeight.values[pf['fontBold'] ? 8 : 0],
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
              if (pf['autoclear']) {
                d = snap.toList();
                await clearThreshold(true);
                dots.value = d.toList();
              }
            },
            onPanUpdate: (d) async {
              if (!clearing) {
                if (pf['exponential']) {
                  distance += d.delta.distanceSquared * pf['intensity'];
                } else {
                  distance += d.delta.distance * pf['intensity'];
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
                  textAlign:
                      TextAlign.values.byName(pf['fontAlign'].toLowerCase()),
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.values[pf['fontBold'] ? 8 : 0],
                      color: cs.primary,
                      fontSize: pf['fontSize'].toDouble(),
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
