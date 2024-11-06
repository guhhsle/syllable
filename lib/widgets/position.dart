import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../book/animations.dart';
import '../data.dart';

class BookPosition extends StatelessWidget {
  const BookPosition({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: current,
      builder: (context, book, child) => ListenableBuilder(
        listenable: book,
        builder: (context, child) => InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () async => book.jumpTo(int.parse(await getInput(
            book.position,
            'Jump to position',
          ))),
          child: Text(
            book.percentage,
            key: textKey,
            style: TextStyle(
              fontSize: Pref.fontSize.value.toDouble(),
              fontWeight: FontWeight.values[Pref.fontBold.value ? 8 : 0],
            ),
          ),
        ),
      ),
    );
  }
}
