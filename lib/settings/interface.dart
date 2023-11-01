import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';

Layer interface() => Layer(
      action: Setting(
        'Interface',
        Icons.gradient_rounded,
        '',
        (c) {},
      ),
      list: [
        Setting(
          'Top',
          Icons.gradient_rounded,
          'pf//appbar',
          (c) => nextPref(
            'appbar',
            ['Primary', 'Black', 'Transparent'],
            refresh: true,
          ),
        ),
        Setting(
          'Animations',
          Icons.animation_rounded,
          'pf//animations',
          (c) => revPref('animations'),
        ),
        Setting(
          'Font size',
          Icons.format_size_rounded,
          'pf//fontSize',
          (c) => showSheet(
            param: 0,
            scroll: true,
            hidePrev: c,
            func: (i) => Layer(
              action: Setting(
                'Font size',
                Icons.format_size_rounded,
                'pf//fontSize',
                (c) {},
              ),
              list: [
                for (int i = 1; i < 31; i++)
                  Setting(
                    '',
                    Icons.format_size_rounded,
                    '$i',
                    (c) => setPref('fontSize', i, refresh: true),
                  ),
              ],
            ),
          ),
        ),
        Setting(
          'Bold',
          Icons.format_bold_rounded,
          'pf//fontBold',
          (c) => revPref('fontBold'),
        ),
        Setting(
          'Text align',
          Icons.format_align_justify,
          'pf//fontAlign',
          (c) => nextPref(
            'fontAlign',
            ['Left', 'Right', 'Center', 'Justify', 'Start', 'End'],
            refresh: true,
          ),
        ),
      ],
    );
