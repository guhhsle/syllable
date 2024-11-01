import 'package:flutter/material.dart';
import 'book.dart';
import '../template/functions.dart';
import '../template/prefs.dart';
import '../data.dart';

class Library {
  List<LibraryBook> get books {
    List<LibraryBook> list = [];
    for (var title in Pref.books.value) {
      try {
        final book = LibraryBook(title);
        list.add(book..load());
      } catch (e) {
        showSnack("Can't open $title", false);
        print('asd');
        debugPrint('$e');
      }
    }
    list.sort((a, b) => a.title.compareTo(b.title));
    return list;
  }

  void empty() {
    for (var book in books) {
      book.delete();
    }
    Pref.books.set([]);
    Pref.positions.set([]);
    Pref.book.set('');
  }
}

class LibraryBook {
  String content = '', title;
  int position = 0, length = 0;

  static const prefix = 'Book-';

  LibraryBook(this.title);

  void load() {
    content = Preferences.prefs.getString('$prefix$title')!;
    length = content.length;
    loadPosition();
  }

  void loadPosition() {
    final index = Pref.books.value.indexOf(title);
    position = int.tryParse(Pref.positions.value[index]) ?? 0;
  }

  void save() {
    tryToSetPosition(position);
    Preferences.prefs.setString('$prefix$title', content);
  }

  void delete() {
    Preferences.prefs.remove('$prefix$title');
    final index = Pref.books.value.indexOf(title);
    final books = Pref.books.value.toList()..removeAt(index);
    final positions = Pref.positions.value.toList()..removeAt(index);
    Pref.books.set(books);
    Pref.positions.set(positions);
  }

  void create() {
    if (!Pref.books.value.contains(title)) {
      Pref.books.set([...Pref.books.value, title]);
      Pref.positions.set([...Pref.positions.value, '$position']);
    }
    save();
  }

  void tryToLoadAndOpen() {
    try {
      load();
      open();
    } catch (e) {
      debugPrint('$e');
      title = 'Hello';
      setContent('>Library >Import');
      open();
    }
  }

  void open() {
    Pref.book.set(title);
    Book().fullText = content;
    Book().length = length;
    Book().jumpTo(position);
  }

  void setContent(String content) {
    this.content = content;
    length = content.length;
  }

  void rename(String name) {
    delete();
    if (title == Pref.book.value) {
      Pref.book.set(name);
    }
    title = name;
    create();
  }

  String get percentage {
    loadPosition();
    return '${(position * 100 / length).toStringAsFixed(2)} %';
  }

  String get formatTitle {
    if (title.contains('.')) return title.split('.').first;
    return title;
  }

  void tryToSetPosition(int pos) {
    try {
      final index = Pref.books.value.indexOf(title);
      final positions = Pref.positions.value.toList();
      positions[index] = '$pos';
      Pref.positions.set(positions);
    } catch (e) {
      debugPrint('$e');
    }
  }

  static LibraryBook get current => LibraryBook(Pref.book.value);
}
