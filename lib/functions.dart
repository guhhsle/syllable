import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';
import 'sheet_model.dart';
import 'sheet_scroll.dart';
import 'theme.dart';

Future<String> getInput(String? init, {String? hintText}) async {
  if (navigatorKey.currentContext == null) return '';
  Completer<String> completer = Completer();
  TextEditingController controller = TextEditingController(text: init);
  BuildContext context = navigatorKey.currentContext!;
  showModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (c) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: TextField(
          cursorColor: Colors.white,
          decoration: InputDecoration(
            labelText: hintText,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            labelStyle: const TextStyle(color: Colors.white),
          ),
          autofocus: true,
          controller: controller,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
          onSubmitted: (text) {
            Navigator.of(c).pop();
            completer.complete(text);
          },
        ),
      );
    },
  );
  return completer.future;
}

Layer themeMap(bool p) {
  Layer layer = Layer(
      action: Setting(
        p ? 'pf//primary' : 'pf//background',
        p ? Icons.colorize_rounded : Icons.tonality_rounded,
        '',
        (c) => fetchColor(p),
      ),
      list: []);
  for (int i = 0; i < colors.length; i++) {
    String name = colors.keys.toList()[i];
    layer.list.add(
      Setting(
        name,
        iconsTheme[name]!,
        '',
        (c) => setPref(
          p ? 'primary' : 'background',
          name,
          refresh: true,
        ),
        iconColor: colors.values.elementAt(i),
      ),
    );
  }
  return layer;
}

void fetchColor(bool p) {
  Clipboard.getData(Clipboard.kTextPlain).then((value) {
    if (value == null || value.text == null || int.tryParse('0xFF${value.text!.replaceAll('#', '')}') == null) {
      showSnack('Clipboard HEX', false);
    } else {
      setPref(
        p ? 'primary' : 'background',
        value.text,
        refresh: true,
      );
    }
  });
}

void revPref(
  String pref, {
  bool refresh = false,
}) =>
    setPref(
      pref,
      !pf[pref],
      refresh: refresh,
    );
final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(ThemeData());
void refreshAll() {
  themeNotifier.value = theme(color(true), color(false));
}

void nextPref(
  String pref,
  List<String> list, {
  bool refresh = false,
}) {
  setPref(
    pref,
    list[(list.indexOf(pf[pref]) + 1) % list.length],
    refresh: refresh,
  );
}

final ValueNotifier<bool> refreshLay = ValueNotifier(true);

String t(dynamic d) {
  String s = '$d';
  if (s.startsWith('pf//')) {
    return t(pf[s.replaceAll('pf//', '')]);
  }
  return l[s] ?? s;
}

void setPref(
  String pString,
  var value, {
  bool refresh = false,
}) {
  pf[pString] = value;
  if (value is int) {
    prefs.setInt(pString, value);
  } else if (value is bool) {
    prefs.setBool(pString, value);
  } else if (value is String) {
    prefs.setString(pString, value);
  } else if (value is List<String>) {
    prefs.setStringList(pString, value);
  } else if (value is double) {
    prefs.setDouble(pString, value);
  }
  if (refresh) refreshAll();
}

void showSnack(String text, bool good) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      backgroundColor: good ? Colors.green.shade200 : Colors.red.shade200,
      content: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ),
  );
}

Color color(bool primary) {
  if (primary) {
    return colors[pf['primary']] ?? Color(int.tryParse('0xFF${pf['primary']}') ?? 0xFF170a1c);
  } else {
    return colors[pf['background']] ?? Color(int.tryParse('0xFF${pf['background']}') ?? 0xFFf6f7eb);
  }
}

Color lighterColor(Color p, Color q) {
  if (p.computeLuminance() > q.computeLuminance()) return p;
  return q;
}

Future<void> initPrefs() async {
  prefs = await SharedPreferences.getInstance();

  for (var i = 0; i < pf.length; i++) {
    String key = pf.keys.elementAt(i);
    if (pf[key] is String) {
      if (prefs.getString(key) == null) {
        prefs.setString(key, pf[key]);
      } else {
        pf[key] = prefs.getString(key)!;
      }
    } else if (pf[key] is int) {
      if (prefs.getInt(key) == null) {
        prefs.setInt(key, pf[key]);
      } else {
        pf[key] = prefs.getInt(key)!;
      }
    } else if (key == 'firstBoot') {
      if (prefs.getBool('firstBoot') == null) {
        prefs.setBool('firstBoot', false);
      } else {
        pf['firstBoot'] = false;
      }
    } else if (pf[key] is bool) {
      if (prefs.getBool(key) == null) {
        prefs.setBool(key, pf[key]);
      } else {
        pf[key] = prefs.getBool(key)!;
      }
    } else if (pf[key] is List<String>) {
      if (prefs.getStringList(key) == null) {
        prefs.setStringList(key, pf[key]);
      } else {
        pf[key] = prefs.getStringList(key)!;
      }
    }
  }
}

void showSheet({
  required Layer Function(dynamic) func,
  required dynamic param,
  bool scroll = false,
  BuildContext? hidePrev,
}) {
  if (hidePrev != null) {
    Navigator.of(hidePrev).pop();
  }
  showModalBottomSheet(
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      if (scroll) {
        return SheetScrollModel(func: func, param: param);
      }
      return SheetModel(func: func, param: param);
    },
  );
}
