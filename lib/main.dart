import 'package:flutter/material.dart';
import 'template/prefs.dart';
import 'template/app.dart';
import 'widgets/home.dart';
import 'book/book.dart';
import 'data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  Book(Pref.book.value).open();
  runApp(const App(title: 'Syllable', child: Home()));
}
