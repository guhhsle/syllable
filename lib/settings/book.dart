import 'package:flutter/material.dart';
import '../book/generate.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../book/clear.dart';
import '../book/book.dart';
import '../data.dart';

class BookLayer extends Layer {
  @override
  construct() {
    action = Tile('Open file', Icons.book_rounded, '', () {
      Navigator.of(context).pop();
      Book().generate();
    });
    list = [
      Tile.fromPref(Pref.preload, onPrefInput: (i) {
        Pref.preload.set(int.parse(i).clamp(0, 10000));
        Book().resetLoadedText();
      }),
      Tile.fromListPref(Pref.breakpoints),
    ];
  }
}
