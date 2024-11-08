import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'dart:convert';
import 'dart:io';
import 'remember.dart';
import 'library.dart';
import 'images.dart';
import 'book.dart';
import '../template/functions.dart';
import '../functions.dart';

extension Generate on Book {
  Future generate() async {
    late final PlatformFile result;
    fullText = '';

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
          final inputStream = InputFileStream(result.path!);
          final archive = ZipDecoder().decodeBuffer(inputStream);
          final files = archive.files.toList();
          List<String> texts = [], images = [];

          final spines = archive.files.where((f) => f.name.endsWith('.opf'));
          files.sort((a, b) => a.name.compareTo(b.name));
          for (final spine in spines) {
            try {
              final text = utf8.decode(spine.content);
              print(text);
              files.sort((a, b) {
                int indexA = text.indexOf(cleanFileName(a.name));
                int indexB = text.indexOf(cleanFileName(b.name));
                if (indexA < 0) indexA = 999999999;
                if (indexB < 0) indexB = 999999999;
                print(a.name);
                print(indexA);
                return indexA.compareTo(indexB);
              });
              break;
            } catch (e) {
              showSnack('$e', false, debug: true);
            }
          }
          for (final file in files) {
            try {
              final nodes = parse(file.content).body!.nodes;
              for (final node in nodes) {
                node.appendTo(texts: texts, images: images);
              }
            } catch (e) {
              //NOT IN X/HTML FORMAT
            }
          }
          for (final nodeText in texts) {
            String addedText = nodeText.trim();
            if (addedText.length > 0) addedText += '\n\n';
            fullText += addedText;
          }
          final usedImageFiles = files.where((f) {
            for (final image in images) {
              if (f.name.contains(image)) return true;
            }
            return false;
          }).toList();
          cacheArchivedImages(usedImageFiles);
        } catch (e) {
          debugPrint('$e');
        }
      } else {
//TEXT
        try {
//APP
          fullText = utf8.decode(await File(result.path!).readAsBytes());
        } catch (e) {
//WEB
          try {
            fullText = utf8.decode(result.bytes!);
          } catch (e) {
            showSnack('$e', false);
          }
        }
      }
    } catch (e) {
      showSnack('$e', false);
    }
    fullText = fullText.trim();
    await rememberNew();
    open();
    showSnack('All done', true);
  }
}

extension AppendNodeContent on Node {
  void appendTo({
    required List<String> texts,
    required List<String> images,
  }) {
    if (nodes.isEmpty) {
      String formatted = parse(text).documentElement!.text;
      if (formatted.trim().length < 2) formatted = text ?? '';
      texts.add(formatted);
    } else {
      for (final node in nodes) {
        node.appendTo(texts: texts, images: images);
      }
    }
    if (attributes['src'] != null) {
      final imageName = fileName(attributes['src'] ?? '');
      for (final extension in supported) {
        if (imageName.endsWith(extension)) {
          //print('IMAGE: $attributes');
          texts.add('[[[$imageName]]]');
          images.add(imageName);
          return;
        }
      }
    }
  }
}

const supported = [
  'jpg',
  'jpeg',
  'png',
  'gif',
  'bmp',
  'webp',
  'tiff',
  'tif',
  'heic',
];
