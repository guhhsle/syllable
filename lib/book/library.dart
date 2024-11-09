import 'dart:io';
import 'package:flutter/material.dart';
import 'remember.dart';
import 'book.dart';
import '../functions.dart';
import '../data.dart';

final helloBook = Book('Hello');

class Library with ChangeNotifier {
  static final instance = Library.internal();
  static String get path => '${Pref.cache.value}/Books';
  static Directory get directory => Directory(path);

  late Book current;
  List<Book> books = [];

  factory Library() => instance;
  Library.internal();

  Future<void> init() async {
    current = helloBook;
    await fetchBooks();
    loadCurrent();
    current.open();
  }

  void notify() => notifyListeners();

  void loadCurrent() {
    try {
      current = findTitle(Pref.book.value)!;
    } catch (e) {
      debugPrint('Cant find: ${Pref.book.title}');
      current = helloBook;
    }
    notify();
  }

  Future<void> fetchBooks() async {
    List<String> freshTitles = [];
    try {
      for (final item in directory.listSync()) {
        if (!(item is Directory)) continue;
        final title = fileName(item.path);
        freshTitles.add(title);
        await addBook(Book(title)).load();
      }
    } catch (e) {
      debugPrint('Cant load library: $e');
    }
    for (int i = 0; i < books.length; i++) {
      if (!freshTitles.contains(books[i].title)) {
        removeBook(books[i]);
        i--;
      }
    }
    books.sort((a, b) => a.title.compareTo(b.title));
    loadCurrent();
  }

  Book addBook(Book book) {
    Book? copy = findTitle(book.title);
    if (copy != null) return copy;
    debugPrint('Added ${book.title}');
    books.add(book);
    return book..addListener(notify);
  }

  Book? replaceBook(Book newBook) {
    Book? oldBook = findTitle(newBook.title);
    if (oldBook != null) removeBook(oldBook);
    addBook(newBook);
    return oldBook;
  }

  Book? removeBook(Book book) {
    books.remove(book);
    book.removeListener(notify);
    debugPrint('Removed ${book.title}');
    return book;
  }

  Book? findTitle(String title) {
    int i = books.indexWhere((book) => book.title == title);
    if (i == -1) return null;
    return books[i];
  }

  void forgetAll() async {
    if (!(await directory.exists())) return;
    await directory.delete(recursive: true);
    books = [];
    await fetchBooks();
  }
}
