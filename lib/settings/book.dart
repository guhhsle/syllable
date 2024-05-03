import 'package:flutter/material.dart';
import '../functions/add_book.dart';
import '../data.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/prefs.dart';

Future<Layer> book(dynamic d) async {
  String initBreakpoints = '';
  for (String point in pf['breakpoints']) {
    initBreakpoints = initBreakpoints + point;
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
        initBreakpoints,
        (c) async {
          String input = await getInput(initBreakpoints);
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
