import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
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
					import 'package:syncfusion_flutter_pdf/pdf.dart';
					import 'package:flutter/services.dart';
					File file = File.fromUri(Uri.file(result.path!));
					final ByteData byteData = ByteData.view(await file.readAsBytesSync().buffer);
					List<int> data = await byteData.buffer.asUint8List(
						byteData.offsetInBytes,
						byteData.lengthInBytes,
					);
					PdfDocument document = PdfDocument(inputBytes: data);
					book = PdfTextExtractor(document).extractText();
				*/
      } else if (result.name.endsWith('.epub')) {
//EPUB
        try {
          ArchiveFile? spine;
          final inputStream = InputFileStream(result.path!);
          final archive = ZipDecoder().decodeBuffer(inputStream);
          final zips = archive.files.where((file) {
            if (file.name.endsWith('.opf')) spine = file;
            if (!file.isFile) return false;
            if (file.name.endsWith('.html')) return true;
            if (file.name.endsWith('.htm')) return true;
            return false;
          }).toList();
          try {
            final spineText = utf8.decode(spine!.content);
            zips.sort((a, b) {
              final indexA = spineText.indexOf(a.name);
              final indexB = spineText.indexOf(b.name);
              return indexA.compareTo(indexB);
            });
          } catch (e) {
            zips.sort((a, b) => a.name.compareTo(b.name));
          }
          if (spine != null) {}
          for (var z in zips) {
            try {
              book += parse(parse(z.content).body!.text).documentElement!.text;
              book += '\n\n\n';
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
