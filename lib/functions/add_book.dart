import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:convert';
import 'dart:io';
import 'other.dart';
import 'prefs.dart';
import 'reading.dart';

Future<int> addBook() async {
  String book = '';
  late final PlatformFile result;

  try {
    result = (await FilePicker.platform.pickFiles())!.files.single;
//EPUB
    if (result.name.endsWith('.epub')) {
      try {
        final inputStream = InputFileStream(result.path!);
        final archive = ZipDecoder().decodeBuffer(inputStream);
        List<ArchiveFile> zipList = [];
        for (var file in archive.files) {
          if (file.isFile && file.name.endsWith('.html')) {
            zipList.add(file);
          }
        }
        zipList.sort((a, b) => a.name.compareTo(b.name));
        for (var file in zipList) {
          try {
            final String parsedString = parse(
              parse(file.content).body!.text,
            ).documentElement!.text;
            book += '$parsedString\n\n\n';
          } catch (e) {
            debugPrint('$e');
          }
        }
      } catch (e) {
        debugPrint('$e');
      }
    } else {
//TEXT
      try {
//APP
        book = utf8.decode(await File(result.path!).readAsBytes());
      } catch (e) {
//WEB
        try {
          book = utf8.decode(result.bytes!);
        } catch (e) {
          showSnack('$e', false);
        }
      }
    }
  } catch (e) {
    showSnack('$e', false);
  }
  setPref('book', book);
  jumpTo(0);
  return 0;
}
