import 'package:flutter/material.dart';

class ThemedPage extends StatelessWidget {

  final Widget child;

  const ThemedPage({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: child,
    );
  }
}