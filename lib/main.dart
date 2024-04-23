import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syllable/theme.dart';
import 'data.dart';
import 'functions/other.dart';
import 'functions/prefs.dart';
import 'functions/reading.dart';
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
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, snap, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Syllable',
          theme: theme(color(true), color(false)),
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: Builder(
              builder: (context) {
                SystemChrome.setSystemUIOverlayStyle(
                  const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                );
                return const Home();
              },
            ),
          ),
        );
      },
    );
  }
}
