import 'package:flutter/material.dart';
import 'package:syllable/settings/reading.dart';

import '../body.dart';
import 'settings/interface.dart';
import 'layer.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key}) : super(key: key);

  @override
  PageSettingsState createState() => PageSettingsState();
}

class PageSettingsState extends State<PageSettings> {
  Map<String, Layer Function(dynamic)> map = {
    'Interface': interface,
    'Reading': reading,
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
            leading: Icon(
              map.values.elementAt(index)(true).action.icon,
            ),
            onTap: () => showSheet(
              func: map.values.elementAt(index),
              param: index == 2,
              scroll: index > 1,
            ),
          ),
        ),
      ),
    );
  }
}
