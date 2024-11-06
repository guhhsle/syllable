import 'package:flutter/material.dart';
import 'remember.dart';
import 'book.dart';
import '../template/functions.dart';
import '../data.dart';

class Library {
  List<Book> get books {
    List<Book> list = [];
    for (var title in Pref.books.value) {
      try {
        final book = Book(title);
        list.add(book..loadRemembered());
      } catch (e) {
        showSnack("Can't open $title", false);
        print('asd');
        debugPrint('$e');
      }
    }
    list.sort((a, b) => a.title.compareTo(b.title));
    return list;
  }

  void forgetAll() {
    for (var book in books) {
      book.forget();
    }
    Pref.books.set([]);
    Pref.positions.set([]);
    Pref.book.set('');
  }
}
