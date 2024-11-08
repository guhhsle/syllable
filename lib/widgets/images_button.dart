import 'package:flutter/material.dart';
import '../layers/images.dart';
import '../book/library.dart';

class ImagesButton extends StatelessWidget {
  const ImagesButton({super.key});

  @override
  Widget build(BuildContext context) {
    final layer = ImagesLayer();
    return ListenableBuilder(
      listenable: Library(),
      builder: (context, child) {
        if (layer.isEmpty) return Container();
        return IconButton(
          icon: const Icon(Icons.attachment_rounded),
          onPressed: ImagesLayer().show,
        );
      },
    );
  }
}
