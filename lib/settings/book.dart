import 'package:flutter/material.dart';
import '../functions/add_book.dart';
import '../functions/reading.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

class BookLayer extends Layer {
  @override
  construct() {
    action = Tile('Open file', Icons.book_rounded, '', () {
      Navigator.of(context).pop();
      addBook();
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

class LagLayer extends Layer {
  @override
  void construct() {
    scroll = true;
    action = Tile('Newest first');
    list = Book().lags.reversed.map((lag) => Tile('$lag  ms'));
  }
}
