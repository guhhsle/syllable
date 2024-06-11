import 'package:flutter/material.dart';
import 'data.dart';
import 'functions/reading.dart';
import 'template/app.dart';
import 'template/prefs.dart';
import 'widgets/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPrefs();
  jumpTo(pf['position']);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return App(
      title: 'Syllable',
      child: const Home(),
    );
  }
}
