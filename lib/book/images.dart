import 'package:archive/archive_io.dart';
import 'dart:io';
import 'book.dart';
import '../functions.dart';

extension ImageCache on Book {
  Future<void> cacheArchivedImages(List<ArchiveFile> images) async {
    print(images);
    for (final image in images) {
      final name = fileName(image.name);
      final output = OutputFileStream('$path/Images/$name');
      image.writeContent(output);
    }
  }

  Future<File> getCachedImage(String name) async {
    return File('$path/Images/$name');
  }

  void scanDisplayedImages() {
    final regex = RegExp(r'\[\[\[(.+?)\]\]\]');
    final matches = regex.allMatches(loadedText);
    displayedImages = matches.map((match) {
      return match.group(1)!;
    }).toList();
  }
}
