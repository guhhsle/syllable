import 'package:flutter/material.dart';
import 'package:syllable/template/functions.dart';
import '../template/layer.dart';
import '../book/generate.dart';
import '../template/tile.dart';
import '../book/library.dart';
import '../data.dart';

class LibraryLayer extends Layer {
  static final library = Library();

  @override
  construct() {
    scroll = true;
    library.fetchBooks();
    action = Tile('Import', Icons.add_rounded, '', () async {
      await LibraryBook('New').generate();
      library.fetchBooks();
    });
    trailing = [
      IconButton(
        icon: Icon(Icons.delete_forever_rounded),
        onPressed: () => showSnack(
          'Tap to empty library',
          false,
          onTap: library.empty,
        ),
      ),
    ];
    list = library.books.map((book) {
      return Tile.complex(
        book.formatTitle,
        Icons.book_rounded,
        book.title == Pref.book.value ? '***' : '',
        LibraryBookLayer(book).show,
      );
    });
  }
}

class LibraryBookLayer extends Layer {
  LibraryBook book;
  LibraryBookLayer(this.book);
  @override
  construct() {
    action = Tile('Open', Icons.keyboard_return_rounded, '', () {
      book.setCurrent();
      book.open();
    });
    list = [
      Tile(book.title, Icons.book_rounded),
      Tile(book.percentage, Icons.percent_rounded, 'At ${book.position}'),
      Tile('Delete', Icons.delete_forever_rounded, '', () {
        Navigator.of(context).pop();
        book.delete();
      }),
    ];
  }
}
