import 'package:flutter/material.dart';
import 'settings/interface.dart';
import 'template/prefs.dart';
import 'template/theme.dart';
import 'template/tile.dart';
import '../settings/cursor.dart';
import '../settings/book.dart';

const locales = [
  ...['Serbian', 'English', 'Spanish', 'German', 'French', 'Italian'],
  ...['Polish', 'Portuguese', 'Russian', 'Slovenian', 'Japanese']
];
const tops = ['Primary', 'Black', 'Transparent'];
const initBreakpoints = ['(', ')', '-', '.', ',', '!', '?', ':', ';'];
//removed '' from syllables, needs testing
const initSyllables = ['a', 'A', 'e', 'E', 'i', 'I', 'o', 'O', 'u', 'U'];
const aligns = ['Left', 'Right', 'Center', 'Justify', 'Start', 'End'];
const shifts = ['Syllable', '2 Syllables', '1', '2', '5'];

enum Pref<T> {
  font('Font', 'JetBrainsMono', Icons.format_italic_rounded, ui: true),
  locale('Language', 'English', Icons.language_rounded, ui: true, all: locales),
  appbar('Top', 'Black', Icons.gradient_rounded, all: tops, ui: true),
  background('Background', 'F0F8FF', Icons.tonality_rounded, ui: true),
  primary('Primary', '000000', Icons.colorize_rounded, ui: true),
  backgroundDark('Dark background', '0F0A0A', Icons.tonality_rounded, ui: true),
  primaryDark('Dark primary', 'FEDBD0', Icons.colorize_rounded, ui: true),
  debug('Developer', false, Icons.developer_mode_rounded),
  //READING
  animations('Animations', true, Icons.animation_rounded),
  preload('Preload', 2000, Icons.clear_all_rounded),
  breakpoints('Sentence breaks', initBreakpoints, Icons.crop_16_9_rounded),
  intensity('Intensity', 20, Icons.gesture_rounded),
  exponential('Exponential intensity', false, Icons.stacked_line_chart_rounded),
  cursorShift('Cursor shift', 'Syllable', Icons.space_bar_rounded, all: shifts),
  syllables('Syllables', initSyllables, Icons.crop_16_9_rounded),
  fontSize('Font size', 16, Icons.format_size_rounded, ui: true),
  fontBold('Bold', true, Icons.format_bold_rounded, ui: true),
  fontAlign('Text align', 'Start', Icons.format_align_justify,
      ui: true, all: aligns),
  position(null, 0, null),
  book('Book', '>Settings >Book >Open', Icons.book_rounded),
  ;

  final T initial;
  final List<T>? all;
  final String? title;
  final IconData? icon;
  final bool ui; //Changing it leads to UI rebuild

  const Pref(this.title, this.initial, this.icon, {this.all, this.ui = false});

  T get value => Preferences.get(this);

  Future set(T val) => Preferences.set(this, val);

  Future rev() => Preferences.rev(this);

  Future next() => Preferences.next(this);

  void nextByLayer({String suffix = ''}) {
    NextByLayer(this, suffix: suffix).show();
  }

  @override
  String toString() => name;
}

List<Tile> get settings {
  return [
    Tile('Interface', Icons.toggle_on, '', InterfaceLayer().show),
    Tile('Cursor', Icons.toggle_on, '', CursorLayer().show),
    Tile('Book', Icons.book_rounded, '', BookLayer().show),
    Tile('Primary', Icons.colorize_rounded, '', ThemeLayer(true).show),
    Tile('Background', Icons.tonality_rounded, '', ThemeLayer(false).show),
  ];
}

final GlobalKey textKey = GlobalKey();
