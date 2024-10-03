import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

Layer cursorSet(Layer l) {
  String syllables = '';
  for (String point in Pref.syllables.value) {
    syllables = syllables + point;
  }

  l.action = Tile.fromPref(Pref.intensity, onPrefInput: (i) {
    Pref.intensity.set(int.parse(i).clamp(0, double.infinity));
  });
  l.list = [
    Tile.fromPref(Pref.exponential),
    Tile.fromPref(Pref.cursorShift),
    Tile('Syllables', Icons.crop_16_9_rounded, initSyllables, () async {
      final input = await getInput(syllables, 'Syllables');
      List<String> next = [];
      for (int i = 0; i < input.length; i++) {
        next.add(input[i]);
      }
      Pref.syllables.set(next);
    }),
  ];
  return l;
}
