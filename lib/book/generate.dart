import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as DOM;
import 'package:html/parser.dart';
import 'dart:convert';
import 'dart:io';
import 'remember.dart';
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
        try {
          final inputStream = InputFileStream(result.path!);
          final archive = ZipDecoder().decodeBuffer(inputStream);
          final files = archive.files.toList();
          List<String> paragraphs = [''], images = [];

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
              final body = parse(file.content).body!;
              body.appendTo(paragraphs: paragraphs, images: images);
            } catch (e) {
              //NOT IN X/HTML FORMAT
            }
          }
          for (final paragraph in paragraphs) {
            String addedText = paragraph.trim();
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
        try {
          fullText = utf8.decode(await File(result.path!).readAsBytes());
        } catch (e) {
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

extension StringPadding on String {
  bool get isPaddedLeft {
    int rawLen = length;
    int trimLen = trimLeft().length;
    return rawLen > trimLen;
  }
}

extension AppendNodeContent on DOM.Node {
  void appendTo({
    required List<String> paragraphs,
    required List<String> images,
  }) {
    if (isParagraph(this)) paragraphs.add('');
    if (nodes.isEmpty) {
      String raw = text ?? '';
      String formatted = parse(text).documentElement!.text;
      if (formatted.trim().length < 2) formatted = raw;
      if (raw.isPaddedLeft && !formatted.isPaddedLeft) {
        formatted = ' $formatted';
      }
      paragraphs.last += formatted;
    } else {
      for (final node in nodes) {
        node.appendTo(paragraphs: paragraphs, images: images);
      }
    }
    if (attributes['src'] != null) {
      final imageName = fileName(attributes['src'] ?? '');
      for (final extension in supported) {
        if (imageName.endsWith(extension)) {
          //print('IMAGE: $attributes');
          paragraphs.add('[[[$imageName]]]');
          images.add(imageName);
          return;
        }
      }
    }
  }

  static bool isParagraph(DOM.Node node) {
    try {
      final element = node as DOM.Element;
      return blockElements.contains(element.localName);
    } catch (e) {
      return false;
    }
  }
}

const blockElements = {
  'p',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'div',
  'blockquote',
  'pre',
  'li',
  'address',
  'figcaption',
  'section',
  'article',
  'aside',
  'footer',
  'header'
};

const supported = {
  'jpg',
  'jpeg',
  'png',
  'gif',
  'bmp',
  'webp',
  'tiff',
  'tif',
  'heic',
};
