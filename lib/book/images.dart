import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:archive/archive_io.dart';
import 'dart:io';
import 'book.dart';
import '../template/functions.dart';

extension ImageCache on Book {
  Future<void> cacheArchivedImages(List<ArchiveFile> images) async {
    if (kIsWeb) return;

    final cache = await getApplicationCacheDirectory();
    final cachePath = cache.path + '/' + title;
    debugPrint(cachePath);
    for (final image in images) {
      final name = fileName(image.name);
      debugPrint(name);
      final output = OutputFileStream(cachePath + '/' + name);
      image.writeContent(output);
    }
  }

  Future<File> getCachedImage(String name) async {
    final cache = await getApplicationCacheDirectory();
    final cachePath = cache.path + '/' + title;
    return File(cachePath + '/' + name);
  }

  void scanDisplayedImages() {
    if (kIsWeb) return;
    final regex = RegExp(r'\[\[\[(.+?)\]\]\]');
    final matches = regex.allMatches(loadedText);
    displayedImages = matches.map((match) {
      return match.group(1)!;
    }).toList();
  }

  Future<void> forgetImages() async {
    try {
      final cache = await getApplicationCacheDirectory();
      final cachePath = cache.path + '/' + title;
      await Directory(cachePath).delete(recursive: true);
    } catch (e) {
      showSnack('$e', false, debug: true);
    }
  }

  Future<void> renameImages(String newName) async {
    try {
      final cache = await getApplicationCacheDirectory();
      await Directory(cache.path + '/$title').rename(cache.path + '/$newName');
    } catch (e) {
      showSnack('$e', false, debug: true);
    }
  }
}

String fileName(String unformattedPath) {
  final parts = unformattedPath.split('/');
  final name = parts.isNotEmpty ? parts.last : '';
  return name.trim();
}
