import 'package:flutter/material.dart';
import 'functions/other.dart';
import 'widgets/sheet_model.dart';
import 'widgets/sheet_scroll.dart';
import '../data.dart';

class Setting {
  final String title, trailing;
  IconData icon;
  final Color? iconColor;
  void Function(BuildContext) onTap;
  final void Function(BuildContext)? secondary;
  void Function(BuildContext)? onHold;

  Setting(
    this.title,
    this.icon,
    this.trailing,
    this.onTap, {
    this.secondary,
    this.onHold,
    this.iconColor,
  });
  ListTile toTile(BuildContext context) {
    Widget? lead, trail;
    if (secondary == null) {
      lead = Icon(icon, color: iconColor);
      trail = Text(t(trailing));
    } else {
      trail = InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Icon(icon, color: iconColor),
        onTap: () {
          secondary!(context);
          refreshLayer();
        },
      );
    }

    return ListTile(
      leading: lead,
      title: Text(t(title)),
      trailing: trail,
      onTap: () {
        onTap(context);
        refreshLayer();
      },
      onLongPress: onHold == null
          ? null
          : () {
              onHold!(context);
              refreshLayer();
            },
    );
  }
}

void refreshLayer() {
  refreshLay.value = !refreshLay.value;
}

class Layer {
  final Setting action;
  final List<Setting> list;
  List<Widget> Function(BuildContext)? trailing;

  Layer({
    required this.action,
    required this.list,
    this.trailing,
  });
}

void showSheet({
  required Layer Function(dynamic) func,
  dynamic param,
  bool scroll = false,
  BuildContext? hidePrev,
}) {
  if (hidePrev != null) {
    Navigator.of(hidePrev).pop();
  }
  showModalBottomSheet(
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      if (scroll) {
        return SheetScrollModel(func: func, param: param);
      }
      return SheetModel(func: func, param: param);
    },
  );
}
