import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syllable/functions.dart';

import 'package:html/parser.dart';
import '../data.dart';

String text = '';
ValueNotifier<List<int>> dots = ValueNotifier([0, 0, 0, 0]);
List<String> syllables = ['a', 'A', 'e', 'E', 'i', 'I', 'o', 'O', 'u', 'U', ''];

List<int> d = [0, 0, 0, 0];

Future nextSyllable() async {
  d = dots.value.toList();
  clearing = true;
  if (d[0] > pf['clearThreshold']) {
    await clearThreshold(false);
  }
  if (text.length - d[3] < pf['preload']) {
    int currentEnd = position + text.length;
    int? nextEnd = currentEnd + pf['preload'] as int;
    if (nextEnd > pf['book'].length) nextEnd = null;
    text += pf['book'].substring(currentEnd, nextEnd);
  }
  await moveCursor();
  if (d[2] >= d[3]) await expandBehind();
  dots.value = d.toList();
  clearing = false;
}

Future<void> moveCursor() async {
  d[1] = d[2];
  d[2] += 2;
  String shift = pf['cursorShift'];
  if (shift.contains('Syllable')) {
    while (!syllables.contains(text[d[2]])) {
      if (d[2] >= d[3]) await expandBehind();
      d[2]++;
    }
  }
  if (shift == '2 Syllables') {
    d[2] += 2;
    while (!syllables.contains(text[d[2]])) {
      if (d[2] >= d[3]) await expandBehind();
      d[2]++;
    }
  } else if (shift == '1') {
    d[2]--;
  } else if (shift == '5') {
    d[2] += 3;
  }
}

Future<void> expandBehind() async {
  int offset = 16;
  setPref('position', position + d[1]);
  final int load = pf['preload'] ~/ 5;
  while (offset < load && !pf['breakpoints'].contains(text[d[3] + offset])) {
    offset++;
  }
  offset++;
  await animateOffset(3, offset);
  d[0] = d[1] = d[2];
  await moveCursor();
}

Future animateOffset(int j, int inc) async {
  if (pf['animations']) {
    const int div = 10;
    int step = (inc / div).floor();
    for (int i = 0; i < div; i++) {
      d[j] += step;
      if (d[2] < d[3]) {
        dots.value = d.toList();
        await Future.delayed(const Duration(milliseconds: 2));
      }
    }
    d[j] += inc % div;
  } else {
    d[j] += inc;
  }
}

final List lineBreaks = [' ', '\n', '—', '-'];

Future clearThreshold(bool auto) async {
  clearing = true;
  RenderBox ts = textKey.currentContext?.findRenderObject() as RenderBox;
  double charWidth = ts.size.width / 9;
  double devWidth = MediaQuery.of(navigatorKey.currentContext!).size.width;
  int row = devWidth ~/ charWidth;

  while (d[0] > row) {
    int i = 0;
    while (i < row - 1 && text[i] != '\n') {
      i++;
    }
    while (i > 0 && !lineBreaks.contains(text[i])) {
      i--;
    }
    i++;
    text = text.substring(i);
    for (int j = 0; j < d.length; j++) {
      d[j] -= i;
    }
    if (pf['animations']) {
      dots.value = d.toList();
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }
  position = pf['book'].indexOf(text.substring(0, d[3]));
  dots.value = d.toList();
  clearing = false;
}

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
        for (var file in archive.files) {
          if (file.isFile) {
            if (file.name.endsWith('.html')) {
              final String parsedString = parse(
                parse(file.content).body!.text,
              ).documentElement!.text;
              book += '$parsedString\n\n\n';
            }
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

void jumpTo(int i) {
  position = i;
  int end = i + pf['preload'] as int;
  bookLen = pf['book'].length;
  if (end > bookLen) end = bookLen;
  text = pf['book'].substring(i, end);
  setPref('position', i);

  dots.value = [0, 0, 0, 0];
}
