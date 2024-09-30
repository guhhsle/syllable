import 'package:flutter/material.dart';
import '../functions/add_book.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

Layer bookSet(dynamic d) {
  String breakpoints = '';
  for (String point in Pref.breakpoints.value) {
    breakpoints = breakpoints + point;
  }
  return Layer(
    action: Tile('Open file', Icons.book_rounded, '', onTap: (c) async {
      Navigator.of(c).pop();
      await addBook();
    }),
    list: [
      Tile.fromPref(Pref.autoclear),
      Tile.fromPref(Pref.clearTreshold, onPrefInput: (i) {
        Pref.clearTreshold.set(int.parse(i).clamp(0, double.infinity));
      }),
      Tile.fromPref(Pref.preload, onPrefInput: (i) {
        Pref.preload.set(int.parse(i).clamp(0, double.infinity));
      }),
      Tile('Breakpoints', Pref.breakpoints.icon, breakpoints, onTap: (c) async {
        String input = await getInput(initBreakpoints, 'Breakpoints');
        List<String> next = [];
        for (int i = 0; i < input.length; i++) {
          next.add(input[i]);
        }
        Pref.breakpoints.set(next);
      })
    ],
  );
}
