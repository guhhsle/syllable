import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'dart:convert';
import 'dart:io';
import 'remember.dart';
import 'images.dart';
import 'book.dart';
import '../template/functions.dart';

extension Generate on Book {
  Future generate() async {
    String content = '';
    late final PlatformFile result;

    try {
      result = (await FilePicker.platform.pickFiles())!.files.single;
      showSnack('Generating...', true);
      await Future.delayed(const Duration(milliseconds: 100));
      title = result.name;

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
          List<ArchiveFile> htmls = [], images = [];
          for (final file in archive.files) {
            if (file.name.endsWith('.opf')) spine = file;
            if (!file.isFile) continue;
            if (file.name.endsWith('.html')) htmls.add(file);
            if (file.name.endsWith('.htm')) htmls.add(file);
            if (file.name.endsWith('.jpg')) images.add(file);
            if (file.name.endsWith('.jpeg')) images.add(file);
          }
          try {
            final spineText = utf8.decode(spine!.content);
            htmls.sort((a, b) {
              final indexA = spineText.indexOf(a.name);
              final indexB = spineText.indexOf(b.name);
              return indexA.compareTo(indexB);
            });
          } catch (e) {
            htmls.sort((a, b) => a.name.compareTo(b.name));
          }
          cacheArchivedImages(images);
          for (final html in htmls) {
            try {
              final nodes = parse(html.content).body!.nodes;
              final list = [''];
              for (final node in nodes) {
                node.appendTo(list);
              }
              for (final nodeContent in list) {
                content += nodeContent;
              }
              content += '\n\n';
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
          content = utf8.decode(await File(result.path!).readAsBytes());
        } catch (e) {
//WEB
          try {
            content = utf8.decode(result.bytes!);
          } catch (e) {
            showSnack('$e', false);
          }
        }
      }
    } catch (e) {
      showSnack('$e', false);
    }
    fullText = content;
    rememberNew();
    open();
    showSnack('All done', true);
  }
}

extension AppendNodeContent on Node {
  void appendTo(List<String> list) {
    if (attributes['src'] != null) {
      //print('SLIKAAA');
      //print(attributes);
      final imageName = fileName(attributes['src'] ?? '');
      list.add('[[[$imageName]]]');
    }
    if (nodes.isEmpty) {
      list.add(text ?? '');
    } else {
      for (final node in nodes) {
        node.appendTo(list);
      }
    }
  }
}
