import 'package:flutter/material.dart';
import 'package:syllable/settings/book.dart';
import 'package:syllable/settings/cursor.dart';

import 'settings/interface.dart';
import 'template/layer.dart';
import 'template/theme.dart';

Map pf = {
  'background': 'Ivory',
  'primary': 'Gruv Dark',
  'appbar': 'Primary',
  //READING
  'clearThreshold': 600,
  'autoclear': true,
  'animations': true,
  'preload': 2000,
  'fontSize': 16,
  'fontBold': true,
  'breakpoints': defaultBreakpoints.toList(),
  'syllables': defaultSyllables.toList(),
  //CURSOR
  'intensity': 20,
  'exponential': false,
  'cursorShift': 'Syllable',
  'fontAlign': 'Start',
  //
  'book': '>Settings >Book >Open',
  'position': 0,
};
final List<Setting> settings = [
  Setting('Interface', Icons.toggle_on, '', (c) => showSheet(func: interfaceSet)),
  Setting('Cursor', Icons.toggle_on, '', (c) => showSheet(func: cursorSet)),
  Setting('Book', Icons.book_rounded, '', (c) => showSheet(func: bookSet)),
  Setting('Primary', Icons.colorize_rounded, '', (c) => showSheet(func: themeMap, param: true, scroll: true)),
  Setting('Background', Icons.colorize_rounded, '', (c) => showSheet(func: themeMap, param: false, scroll: true)),
];

final GlobalKey textKey = GlobalKey();
int bookLen = 0;
const List<String> defaultBreakpoints = ['(', ')', '-', '.', ',', '!', '?', ':', ';'];
const List<String> defaultSyllables = ['a', 'A', 'e', 'E', 'i', 'I', 'o', 'O', 'u', 'U', ''];

bool clearing = false;
int position = pf['preload'];
