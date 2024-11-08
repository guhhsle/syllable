import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../book/animations.dart';
import '../book/library.dart';
import '../book/book.dart';
import '../data.dart';

class BookPosition extends StatelessWidget {
  const BookPosition({super.key});

  Book get current => Library().current;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Library(),
      builder: (context, child) => InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () async => current.jumpTo(int.parse(await getInput(
          current.position,
          'Jump to position',
        ))),
        child: Text(
          current.percentage,
          key: textKey,
          style: TextStyle(
            fontSize: Pref.fontSize.value.toDouble(),
            fontWeight: FontWeight.values[Pref.fontBold.value ? 8 : 0],
          ),
        ),
      ),
    );
  }
}
