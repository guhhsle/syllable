import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'template/prefs.dart';
import 'template/app.dart';
import 'book/library.dart';
import 'widgets/home.dart';
import 'data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();

  if (Pref.cache.value == '') {
    Pref.cache.set((await getApplicationCacheDirectory()).path);
  }
  await Library().init();
  runApp(const App(title: 'Syllable', child: Home()));
}
