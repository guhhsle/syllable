import 'dart:async';
import 'package:flutter/material.dart';
import '../data.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/prefs.dart';

Future<Layer> cursor(dynamic non) async {
  String initSyllables = '';
  for (String point in pf['syllables']) {
    initSyllables = initSyllables + point;
  }

  return Layer(
    action: Setting(
      'Intensity',
      Icons.gesture_rounded,
      '${pf['intensity']}',
      (c) async {
        int? input = int.tryParse(await getInput('${pf['intensity']}'));
        if (input == null || input < 0) {
          showSnack('Invalid', false);
        } else {
          setPref('intensity', input);
        }
      },
    ),
    list: [
      Setting(
        'Exponential intensity',
        Icons.stacked_line_chart_rounded,
        '${pf['exponential']}',
        (c) => revPref(
          'exponential',
          refresh: true,
        ),
      ),
      Setting(
        'Cursor shift',
        Icons.space_bar_rounded,
        pf['cursorShift'],
        (c) => nextPref(
          'cursorShift',
          ['Syllable', '2 Syllables', '1', '2', '5'],
          refresh: true,
        ),
      ),
      Setting(
        'Syllables',
        Icons.crop_16_9_rounded,
        initSyllables,
        (c) async {
          String input = await getInput(initSyllables);
          List<String> next = [];
          for (int i = 0; i < input.length; i++) {
            next.add(input[i]);
          }
          setPref('syllables', next);
        },
      ),
    ],
  );
}
