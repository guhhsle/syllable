import 'package:flutter/material.dart';
import '../data.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/prefs.dart';

Future<Layer> interfaceSet(dynamic d) async => Layer(
      action: Setting(
        'Top',
        Icons.gradient_rounded,
        pf['appbar'],
        (c) => nextPref(
          'appbar',
          ['Primary', 'Black', 'Transparent'],
          refresh: true,
        ),
      ),
      list: [
        Setting(
          'Animations',
          Icons.animation_rounded,
          '${pf['animations']}',
          (c) => revPref('animations'),
        ),
        Setting(
          'Font size',
          Icons.format_size_rounded,
          '${pf['fontSize']}',
          (c) async {
            int? input = int.tryParse(await getInput('${pf['fontSize']}'));
            setPref('fontSize', input, refresh: true);
          },
        ),
        Setting(
          'Bold',
          Icons.format_bold_rounded,
          '${pf['fontBold']}',
          (c) => revPref('fontBold'),
        ),
        Setting(
          'Text align',
          Icons.format_align_justify,
          pf['fontAlign'],
          (c) => nextPref(
            'fontAlign',
            ['Left', 'Right', 'Center', 'Justify', 'Start', 'End'],
            refresh: true,
          ),
        ),
      ],
    );
