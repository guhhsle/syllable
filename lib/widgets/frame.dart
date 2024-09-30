import 'package:flutter/material.dart';

class Frame extends StatelessWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget? child;
  final bool automaticallyImplyLeading;

  const Frame({
    super.key,
    this.automaticallyImplyLeading = true,
    this.title = const SizedBox(),
    this.actions = const [],
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: [...actions, const SizedBox(width: 8)],
      ),
      body: SizedBox(
        height: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32),
            topLeft: Radius.circular(16),
          ),
          child: Card(
            color: Theme.of(context).colorScheme.surface,
            margin: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(),
            child: ClipRRect(child: child),
          ),
        ),
      ),
    );
  }
}
