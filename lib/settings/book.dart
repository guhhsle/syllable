import 'package:flutter/material.dart';
import '../functions/add_book.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

class BookLayer extends Layer {
  @override
  void construct() {
    action = Tile('Open file', Icons.book_rounded, '', () {
      Navigator.of(context).pop();
      addBook();
    });
    list = [
      Tile.fromPref(Pref.preload, onPrefInput: (i) {
        Pref.preload.set(int.parse(i).clamp(0, double.infinity).toInt());
      }),
      Tile.fromListPref(Pref.breakpoints),
    ];
  }
}
