import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../book/remember.dart';
import '../book/generate.dart';
import '../template/tile.dart';
import '../book/library.dart';
import '../book/book.dart';
import '../data.dart';

class LibraryLayer extends Layer {
  static final library = Library();

  @override
  construct() {
    action = Tile('Import', Icons.add_rounded, '', () {
      Book('New').generate();
    });
    trailing = [
      IconButton(
        icon: Icon(Icons.delete_forever_rounded),
        onPressed: () => showSnack(
          'Tap to empty library',
          false,
          onTap: library.forgetAll,
        ),
      ),
    ];
    list = library.books.map((book) {
      return Tile.complex(
        book.formatTitle,
        Icons.book_rounded,
        book.title == Pref.book.value ? '***' : '',
        BookLayer(book).show,
      );
    });
  }
}

class BookLayer extends Layer {
  Book book;
  BookLayer(this.book);
  @override
  construct() {
    action = Tile('Open', Icons.keyboard_return_rounded, '', book.open);
    list = [
      Tile(book.title, Icons.edit_rounded, '', () async {
        final newTitle = await getInput(book.title, 'Title');
        book.rename(newTitle);
      }),
      Tile(book.percentage, Icons.percent_rounded, 'At ${book.position}'),
      Tile('Delete', Icons.delete_forever_rounded, '', () {
        Navigator.of(context).pop();
        book.forget();
      }),
    ];
  }
}
