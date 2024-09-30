import 'package:flutter/material.dart';
import 'data.dart';
import 'functions/reading.dart';
import 'template/app.dart';
import 'template/prefs.dart';
import 'widgets/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  jumpTo(Pref.position.value);
  runApp(const App(title: 'Syllable', child: Home()));
}
