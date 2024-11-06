import 'package:flutter/material.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../book/images.dart';
import '../book/book.dart';
import '../data.dart';

class ImagesLayer extends Layer {
  Book get book => current.value;
  @override
  construct() {
    action = Tile(
      'Shown attachments',
      Icons.attachment_rounded,
      book.displayedImages.length,
    );
    list = book.displayedImages.map((path) {
      return Tile(path, Icons.attachment_rounded, '', () async {
        final file = await book.getCachedImage(path);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (c) => Image.file(file),
        );
      });
    });
  }

  bool get isEmpty => book.displayedImages.isEmpty;
}