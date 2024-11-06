import 'package:flutter/material.dart';
import 'images.dart';
import 'book.dart';
import '../template/prefs.dart';
import '../data.dart';

extension Remember on Book {
  static const prefPrefix = 'Book-';

  void loadRemembered() {
    fullText = Preferences.prefs.getString('$prefPrefix$title')!;
    final index = Pref.books.value.indexOf(title);
    position = int.tryParse(Pref.positions.value[index]) ?? 0;
  }

  void rememberFullText() {
    Preferences.prefs.setString('$prefPrefix$title', fullText);
  }

  Future<void> forget({bool completely = true}) async {
    Preferences.prefs.remove('$prefPrefix$title');
    final index = Pref.books.value.indexOf(title);
    final books = Pref.books.value.toList()..removeAt(index);
    final positions = Pref.positions.value.toList()..removeAt(index);
    Pref.books.set(books);
    Pref.positions.set(positions);
    if (completely) await forgetImages();
  }

  void rememberNew() {
    if (!Pref.books.value.contains(title)) {
      Pref.books.set([...Pref.books.value, title]);
      Pref.positions.set([...Pref.positions.value, '$position']);
    }
    rememberPostion();
    rememberFullText();
  }

  Future<void> rename(String name) async {
    await forget(completely: false);
    if (title == Pref.book.value) {
      Pref.book.set(name);
    }
    await renameImages(name);
    title = name;
    rememberNew();
  }

  void rememberPostion() {
    try {
      final index = Pref.books.value.indexOf(title);
      final positions = Pref.positions.value.toList();
      positions[index] = '$position';
      Pref.positions.set(positions);
    } catch (e) {
      debugPrint('$e');
    }
  }
}
