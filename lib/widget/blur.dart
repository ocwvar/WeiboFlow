import 'dart:ui';

import 'package:flutter/material.dart';

/// a widget provided blur background effect
/// also with padding, rounded corner and color background
class BlurBox extends StatelessWidget {

  final bool needAnimated;
  final double cornerRoundedValue;
  final EdgeInsets padding;
  final double blurValue;
  final Color? backgroundColor;

  final Widget child;

  const BlurBox({
    Key? key,
    this.needAnimated = false,
    this.padding = EdgeInsets.zero,
    this.blurValue = 8,
    this.backgroundColor,
    this.cornerRoundedValue = 12,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (needAnimated) {
      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: blurValue),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
        builder: (a, double value, b) {
          return _getContentChild(context, value);
        },
      );
    } else {
      return _getContentChild(context, blurValue);
    }
  }

  Widget _getContentChild(BuildContext context, double blurValue) {
    Color? _defaultColor;
    if (backgroundColor == null) {
      _defaultColor = Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5);
    }

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.all(Radius.circular(cornerRoundedValue)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: blurValue, sigmaX: blurValue),
        child: ColoredBox(
          color: backgroundColor ?? _defaultColor ?? Colors.transparent,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}