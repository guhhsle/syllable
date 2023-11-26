import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../functions/add_book.dart';

Layer reading() => Layer(
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
          'pf//cursorShift',
          (c) => nextPref(
            'cursorShift',
            ['Syllable', '2 Syllables', '1', '2', '5'],
            refresh: true,
          ),
        ),
        Setting(
          'Exponential intensity',
          Icons.stacked_line_chart_rounded,
          'pf//exponential',
          (c) => revPref(
            'exponential',
            refresh: true,
          ),
        ),
        Setting(
          'Intensity',
          Icons.gesture_rounded,
          'pf//intensity',
          (c) => showSheet(
            param: 0,
            scroll: true,
            hidePrev: c,
            func: (i) => Layer(
              action: Setting(
                'Intensity',
                Icons.gesture_rounded,
                'pf//intensity',
                (c) {},
              ),
              list: [
                for (int i = 1; i < 31; i++)
                  Setting(
                    '',
                    Icons.gesture_rounded,
                    '$i',
                    (c) => setPref('intensity', i),
                  ),
              ],
            ),
          ),
        ),
        Setting(
          'Autoclear',
          Icons.gesture_rounded,
          'pf//autoclear',
          (c) => revPref('autoclear'),
        ),
        Setting(
          'Clear threshold',
          Icons.clear_all_rounded,
          'pf//clearThreshold',
          (c) => showSheet(
            param: 0,
            scroll: true,
            hidePrev: c,
            func: (i) => Layer(
              action: Setting(
                'Clear threshold',
                Icons.clear_all_rounded,
                'pf//clearThreshold',
                (c) {},
              ),
              list: [
                for (int i = 100; i < 2100; i += 100)
                  Setting(
                    '',
                    Icons.clear_all_rounded,
                    '$i',
                    (c) => setPref('clearThreshold', i),
                  ),
              ],
            ),
          ),
        ),
        Setting(
          'Preload',
          Icons.clear_all_rounded,
          'pf//preload',
          (c) => showSheet(
            param: 0,
            scroll: true,
            hidePrev: c,
            func: (i) => Layer(
              action: Setting(
                'Preload',
                Icons.clear_all_rounded,
                'pf//preload',
                (c) {},
              ),
              list: [
                for (int i = 1000; i < 8500; i += 500)
                  Setting(
                    '',
                    Icons.clear_all_rounded,
                    '$i',
                    (c) => setPref('preload', i),
                  ),
              ],
            ),
          ),
        ),
        Setting(
          'Breakpoints',
          Icons.crop_16_9_rounded,
          '',
          (c) => showSheet(
            param: 0,
            scroll: true,
            hidePrev: c,
            func: (i) => Layer(
              action: Setting(
                'pf//breakpoints',
                Icons.crop_16_9_rounded,
                ' ',
                (c) {},
              ),
              list: [
                for (String s in defaultBreakpoints)
                  Setting(
                    s,
                    pf['breakpoints'].contains(s) ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    '',
                    (c) {
                      if (pf['breakpoints'].contains(s)) {
                        setPref('breakpoints', pf['breakpoints']..remove(s));
                      } else {
                        setPref('breakpoints', pf['breakpoints']..add(s));
                      }
                    },
                    secondary: (c) {
                      if (pf['breakpoints'].contains(s)) {
                        setPref('breakpoints', pf['breakpoints']..remove(s));
                      } else {
                        setPref('breakpoints', pf['breakpoints']..add(s));
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
