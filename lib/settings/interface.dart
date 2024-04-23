import 'package:flutter/material.dart';
import '../data.dart';
import '../functions/other.dart';
import '../functions/prefs.dart';
import '../layer.dart';

Layer interface(dynamic d) => Layer(
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
Layer themeMap(dynamic p) {
  p is bool;
  Layer layer = Layer(
      action: Setting(
        pf[p ? 'primary' : 'background'],
        p ? Icons.colorize_rounded : Icons.tonality_rounded,
        '',
        (c) => fetchColor(p),
      ),
      list: []);
  for (int i = 0; i < colors.length; i++) {
    String name = colors.keys.toList()[i];
    layer.list.add(
      Setting(
        name,
        iconsTheme[name]!,
        '',
        (c) => setPref(
          p ? 'primary' : 'background',
          name,
          refresh: true,
        ),
        iconColor: colors.values.elementAt(i),
      ),
    );
  }
  return layer;
}
