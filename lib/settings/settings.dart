import 'package:flutter/material.dart';
import 'package:syllable/settings/cursor.dart';
import '../template/layer.dart';
import '../template/theme.dart';
import '../widgets/body.dart';
import 'book.dart';
import 'interface.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key}) : super(key: key);

  @override
  PageSettingsState createState() => PageSettingsState();
}

class PageSettingsState extends State<PageSettings> {
  Map<String, Future<Layer> Function(dynamic)> map = {
    'Interface': interface,
    'Cursor': cursor,
    'Book': book,
    'Primary': themeMap,
    'Background': themeMap,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Body(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: map.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(map.keys.elementAt(index)),
            onTap: () => showSheet(
              func: map.values.elementAt(index),
              param: index == 2,
              scroll: index > 0,
            ),
          ),
        ),
      ),
    );
  }
}
