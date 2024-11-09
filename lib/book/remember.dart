import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'library.dart';
import 'book.dart';
import '../data.dart';

extension Remember on Book {
  Future<void> rememberFullText() async {
    if (this == helloBook) return;
    final textFile = File('$path/text');
    if (!(await textFile.exists())) {
      await textFile.create(recursive: true);
    }
    await textFile.writeAsString(fullText);
  }

  Future<void> forget() async {
    await Directory(path).delete(recursive: true);
    Library().fetchBooks();
  }

  Future<void> rememberNew() async {
    if (this == helloBook) return;
    await Directory(path).create(recursive: true);
    await rememberPostion();
    await rememberFullText();
    Library().replaceBook(this);
    await Library().fetchBooks();
  }

  Future<void> rename(String newTitle) async {
    if (this == helloBook) return;
    await Directory(path).rename('${Library.path}/$newTitle');
    if (title == Pref.book.value) Pref.book.set(newTitle);
    title = newTitle;
    Library().fetchBooks();
  }

  Future<void> rememberPostion() async {
    if (this == helloBook) return;
    final metaFile = File(path + '/meta.json');
    Map meta = {};
    if (!(await metaFile.exists())) {
      await metaFile.create(recursive: true);
    } else {
      meta = jsonDecode(await metaFile.readAsString());
    }
    meta['position'] = position;
    await metaFile.writeAsString(jsonEncode(meta));
  }

  Future<void> load() async {
    try {
      await Future.wait([loadMeta(), loadText()]);
    } catch (e) {
      debugPrint('Cant load $title: $e');
    }
  }

  Future<void> loadMeta() async {
    final metaFile = File('$path/meta.json');
    if (!(await metaFile.exists())) return;
    final map = jsonDecode(await metaFile.readAsString());
    position = map['position'] ?? 0;
  }

  Future<void> loadText() async {
    final textFile = File('$path/text');
    if (!(await textFile.exists())) return;
    fullText = await textFile.readAsString();
  }
}
