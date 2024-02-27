import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syllable/body.dart';
import 'package:syllable/functions.dart';
import 'package:syllable/theme.dart';

import 'data.dart';
import 'functions/reading.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPrefs();
  jumpTo(pf['position']);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, snap, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Syllable',
          theme: theme(color(true), color(false)),
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: Builder(
              builder: (context) {
                SystemChrome.setSystemUIOverlayStyle(
                  const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                );
                return const Home();
              },
            ),
          ),
        );
      },
    );
  }
}

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
    bool exp = pf['exponential'];
    return ValueListenableBuilder(
      valueListenable: dots,
      builder: (context, snap, child) {
        double distance = 0;
        int pos = position + snap[1];
        bool addZero = pos / bookLen < 0.1;
        String percent = '${(pos * 100 / bookLen).toStringAsFixed(2)} %';
        return Scaffold(
          appBar: AppBar(
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
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () => goToPage(const PageSettings()),
                  icon: const Icon(Icons.menu_rounded),
                ),
              ),
            ],
          ),
          body: Body(
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
                  distance += (exp ? d.delta.distanceSquared : d.delta.distance) * pf['intensity'];
                  while (distance > 1000) {
                    await nextSyllable();
                    distance -= 1000;
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.values[{
                            'Left': 0,
                            'Right': 1,
                            'Center': 2,
                            'Justify': 3,
                            'Start': 4,
                            'End': 5,
                          }[pf['fontAlign']] ??
                          4],
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
                              text: text.substring(i == 0 ? 0 : d[i - 1], i == 4 ? null : d[i]),
                              style: TextStyle(
                                backgroundColor: highlights[i],
                                color: {
                                  0: null,
                                  1: cs.background,
                                  2: cs.background,
                                  3: cs.background,
                                  4: null,
                                }[i],
                              ),
                            ),
                        ],
                      ),
                    ),
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
