import 'package:flutter/material.dart';

class ThemedPage extends StatelessWidget {

  final Widget child;
  AppBar? appBar;

  ThemedPage({
    Key? key,
    required this.child,
    required this.appBar
  }) : super(key: key);

  ThemedPage.withoutAppBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: appBar,
      body: child,
    );
  }

}