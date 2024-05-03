import 'package:flutter/material.dart';

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

final GlobalKey textKey = GlobalKey();
int bookLen = 0;
const List<String> defaultBreakpoints = ['(', ')', '-', '.', ',', '!', '?', ':', ';'];
const List<String> defaultSyllables = ['a', 'A', 'e', 'E', 'i', 'I', 'o', 'O', 'u', 'U', ''];

bool clearing = false;
int position = pf['preload'];
