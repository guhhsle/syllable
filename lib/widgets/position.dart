import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../book/book.dart';
import '../data.dart';

class BookPosition extends StatelessWidget {
  const BookPosition({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Book(),
      builder: (context, child) {
        int pos = Book().position;
        bool addZero = pos / Book().length < 0.1;
        String percent = '${(pos * 100 / Book().length).toStringAsFixed(2)} %';
        return InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () async => Book().jumpTo(int.parse(await getInput(
            pos,
            'Jump to position',
          ))),
          child: Text(
            ' ${addZero ? '0' : ''}$percent ',
            key: Book().key,
            style: TextStyle(
              fontSize: Pref.fontSize.value.toDouble(),
              fontWeight: FontWeight.values[Pref.fontBold.value ? 8 : 0],
            ),
          ),
        );
      },
    );
  }
}
