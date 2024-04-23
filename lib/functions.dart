import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'data.dart';
import 'functions/prefs.dart';
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

final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(ThemeData());
void refreshAll() {
  themeNotifier.value = theme(color(true), color(false));
}

final ValueNotifier<bool> refreshLay = ValueNotifier(true);

String t(dynamic d) {
  String s = '$d';
  return l[s] ?? s;
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
