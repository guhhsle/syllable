import 'package:flutter/material.dart';
import 'functions/reading.dart';
import 'template/prefs.dart';
import 'template/app.dart';
import 'widgets/home.dart';
import 'data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  jumpTo(Pref.position.value);
  runApp(const App(title: 'Syllable', child: Home()));
}
