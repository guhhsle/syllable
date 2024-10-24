import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
//import 'package:syncfusion_flutter_pdf/pdf.dart';
//import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'book.dart';
import '../template/functions.dart';
import '../data.dart';

extension Generate on Book {
  Future generate() async {
    String book = '';
    late final PlatformFile result;

    try {
      result = (await FilePicker.platform.pickFiles())!.files.single;

      if (result.name.endsWith('.pdf')) {
        showSnack('Convert PDF to text', true);
        /*
      File file = File.fromUri(Uri.file(result.path!));
      final ByteData byteData = ByteData.view(await file.readAsBytesSync().buffer);

      List<int> data = await byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      PdfDocument document = PdfDocument(inputBytes: data);
      book = PdfTextExtractor(document).extractText();

      showSnack('Done', true);

		*/
      } else if (result.name.endsWith('.epub')) {
//EPUB
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
    Pref.book.set(book);
    jumpTo(0);
  }
}
