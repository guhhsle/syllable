import 'package:flutter/material.dart';
import 'template/prefs.dart';
import 'template/app.dart';
import 'widgets/home.dart';
import 'book/library.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  LibraryBook.current.tryToLoadAndOpen();
  runApp(const App(title: 'Syllable', child: Home()));
}
