import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ThemedPage extends StatelessWidget {

  final Widget child;
  PreferredSize? appBar;

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
      extendBodyBehindAppBar: true,
      backgroundColor: _getBackgroundColor(context),
      appBar: appBar,
      body: Stack(
        children: [
          SvgPicture.asset(
            "assets/bg/main_bg.svg",
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            fit: BoxFit.contain,
          ),
          child
        ],
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Theme.of(context).colorScheme.background;
    } else {
      return Theme.of(context).colorScheme.secondaryContainer;
    }
  }

}