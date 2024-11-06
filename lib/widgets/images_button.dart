import 'package:flutter/material.dart';
import '../layers/images.dart';
import '../data.dart';

class ImagesButton extends StatelessWidget {
  const ImagesButton({super.key});

  @override
  Widget build(BuildContext context) {
    final layer = ImagesLayer();
    return ValueListenableBuilder(
      valueListenable: current,
      builder: (context, book, child) => ListenableBuilder(
        listenable: book,
        builder: (context, child) {
          if (layer.isEmpty) {
            return Container();
          } else {
            return IconButton(
              icon: const Icon(Icons.attachment_rounded),
              onPressed: ImagesLayer().show,
            );
          }
        },
      ),
    );
  }
}
