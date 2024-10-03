import 'package:flutter/material.dart';
import 'settings/interface.dart';
import 'template/layer.dart';
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
const initSyllables = ['a', 'A', 'e', 'E', 'i', 'I', 'o', 'O', 'u', 'U', ''];
const aligns = ['Left', 'Right', 'Center', 'Justify', 'Start', 'End'];
const shifts = ['Syllable', '2 Syllables', '1', '2', '5'];

enum Pref {
  font('Font', 'JetBrainsMono', Icons.format_italic_rounded, ui: true),
  locale('Language', 'English', Icons.language_rounded, ui: true, all: locales),
  appbar('Top', 'Black', Icons.gradient_rounded, all: tops, ui: true),
  background('Background', 'F0F8FF', Icons.tonality_rounded, ui: true),
  primary('Primary', '000000', Icons.colorize_rounded, ui: true),
  backgroundDark('Dark background', '0F0A0A', Icons.tonality_rounded, ui: true),
  primaryDark('Dark primary', 'FEDBD0', Icons.colorize_rounded, ui: true),
  debug('Developer', false, Icons.developer_mode_rounded),
  //READING
  clearTreshold('Clear threshold', 600, Icons.clear_all_rounded),
  animations('Animations', true, Icons.animation_rounded),
  autoclear('Autoclear', true, Icons.gesture_rounded),
  preload('Preload', 2000, Icons.clear_all_rounded),
  breakpoints('Breakpoints', initBreakpoints, Icons.crop_16_9_rounded),
  intensity('Intensity', 20, Icons.gesture_rounded),
  exponential('Exponential intensity', false, Icons.stacked_line_chart_rounded),
  cursorShift('Cursor shift', 'Syllable', Icons.space_bar_rounded, all: shifts),
  syllables('Syllables', initSyllables, Icons.crop_16_9_rounded),
  fontSize('Font size', 16, Icons.format_size_rounded, ui: true),
  fontBold('Bold', true, Icons.format_bold_rounded, ui: true),
  fontAlign('Text align', 'Start', Icons.format_align_justify,
      ui: true, all: aligns),
  position('Cursor position', 0, Icons.space_bar_rounded),
  book('Book', '>Settings >Book >Open', Icons.book_rounded),
  ;

  final dynamic initial;
  final List? all;
  final String title;
  final IconData icon;
  final bool ui; //Changing it leads to UI rebuild

  const Pref(this.title, this.initial, this.icon, {this.all, this.ui = false});

  dynamic get value => Preferences.get(this);

  Future set(dynamic val) => Preferences.set(this, val);

  Future rev() => Preferences.rev(this);

  Future next() => Preferences.next(this);

  void nextByLayer({String suffix = ''}) =>
      Preferences.nextByLayer(this, suffix: suffix);

  @override
  String toString() => name;
}

List<Tile> get settings {
  return [
    Tile('Interface', Icons.toggle_on, '', () => showSheet(interfaceSet)),
    Tile('Cursor', Icons.toggle_on, '', () => showSheet(cursorSet)),
    Tile('Book', Icons.book_rounded, '', () => showSheet(bookSet)),
    Tile('Primary', Icons.colorize_rounded, '',
        () => showScrollSheet(ThemePref.toLayer, {'primary': true})),
    Tile('Background', Icons.tonality_rounded, '',
        () => showScrollSheet(ThemePref.toLayer, {'primary': false})),
  ];
}

final GlobalKey textKey = GlobalKey();
int bookLen = 0;

bool clearing = false;
int position = Pref.preload.value;
