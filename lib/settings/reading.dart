import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../functions/add_book.dart';
import '../layer.dart';

Layer reading(dynamic d) {
  String init = '';
  for (String point in pf['breakpoints']) {
    init = init + point;
  }
  return Layer(
    action: Setting(
      'Open file',
      Icons.book_rounded,
      '',
      (c) async {
        Navigator.of(c).pop();
        await addBook();
      },
    ),
    list: [
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
        'Exponential intensity',
        Icons.stacked_line_chart_rounded,
        '${pf['exponential']}',
        (c) => revPref(
          'exponential',
          refresh: true,
        ),
      ),
      Setting(
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
      Setting(
        'Autoclear',
        Icons.gesture_rounded,
        '${pf['autoclear']}',
        (c) => revPref('autoclear'),
      ),
      Setting(
        'Clear threshold',
        Icons.clear_all_rounded,
        '${pf['clearThreshold']}',
        (c) async {
          int? input = int.tryParse(await getInput('${pf['clearThreshold']}'));
          if (input == null || input < 0) {
            showSnack('Invalid', false);
          } else {
            setPref('clearThreshold', input);
          }
        },
      ),
      Setting(
        'Preload',
        Icons.clear_all_rounded,
        '${pf['preload']}',
        (c) async {
          int? input = int.tryParse(await getInput('${pf['preload']}'));
          if (input == null || input < 0) {
            showSnack('Invalid', false);
          } else {
            setPref('preload', input);
          }
        },
      ),
      Setting(
        'Breakpoints',
        Icons.crop_16_9_rounded,
        init,
        (c) async {
          String input = await getInput(init);
          List<String> next = [];
          for (int i = 0; i < input.length; i++) {
            next.add(input[i]);
          }
          setPref('breakpoints', next);
        },
      ),
    ],
  );
}
