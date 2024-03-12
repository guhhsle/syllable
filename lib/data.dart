import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map pf = {
  'background': 'Ivory',
  'primary': 'Ultramarine',
  'appbar': 'Primary',
  //READING
  'clearThreshold': 600,
  'autoclear': true,
  'animations': true,
  'preload': 2000,
  'fontSize': 16,
  'fontBold': true,
  'breakpoints': defaultBreakpoints.toList(),
  //CURSOR
  'intensity': 20,
  'exponential': false,
  'cursorShift': 'Syllable',
  'fontAlign': 'Start',
  //
  'book': '>Settings >Reading',
  'position': 0,
};

final GlobalKey textKey = GlobalKey();
int bookLen = 0;
const List<String> defaultBreakpoints = ['(', ')', '-', '.', ',', '!', '?', ':', ';'];

final Map<String, Color> colors = {
  'White': Colors.white,
  'Ivory': const Color(0xFFf6f7eb),
  //'Beige': const Color(0xFFf5f5dc),
  'Pink': const Color(0xFFFEDBD0),
  'Gruv Light': const Color(0xFFC8A58A),
  'Light Green': const Color(0xFFcbe2d4),
  'PinkRed': const Color(0xFFee7674),
  'BlueGrey': Colors.blueGrey,
  'Dark BlueGrey': Colors.blueGrey.shade900,
  'Dark Green': const Color(0xFF25291C),
  'Purple Grey': const Color(0xFF282a36),
  'Ultramarine': const Color(0xFF01161E),
  'Dark Pink': const Color(0xFF442C2E),
  'Purple': const Color(0xFF170a1c),
  'Gruv Dark': const Color(0xFF0F0A0A),
  'Anchor': const Color(0xFF11150D),
  'Black': Colors.black,
};

bool clearing = false;
int position = pf['preload'];

Map l = {
  'true': 'Ye',
  'false': 'Nye',
};
final navigatorKey = GlobalKey<NavigatorState>();
const ScrollPhysics scrollPhysics = BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
late final SharedPreferences prefs;
final Map<String, IconData> iconsTheme = {
  'White': Icons.ac_unit_rounded,
  'Ivory': Icons.ac_unit_rounded,
  'Pink': Icons.spa_outlined,
  'Gruv Light': Icons.local_cafe_outlined,
  'Light Green': Icons.nature_outlined,
  'PinkRed': Icons.spa_outlined,
  'BlueGrey': Icons.filter_drama_rounded,
  'Dark BlueGrey': Icons.filter_drama_rounded,
  'Dark Green': Icons.nature_outlined,
  'Purple Grey': Icons.light,
  'Ultramarine': Icons.water_rounded,
  'Dark Pink': Icons.spa_outlined,
  'Purple': Icons.star_purple500_rounded,
  'Gruv Dark': Icons.local_cafe_outlined,
  'Anchor': Icons.anchor_outlined,
  'Black': Icons.nights_stay_outlined,
};
void goToPage(Widget page) {
  if (navigatorKey.currentContext == null) return;
  Navigator.of(navigatorKey.currentContext!).push(
    MaterialPageRoute(builder: (c) => page),
  );
}
