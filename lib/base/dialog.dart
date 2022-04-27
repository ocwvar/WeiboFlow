import 'package:flutter/material.dart';
import 'package:weibo_flow/widget/blur.dart';

class ThemedDialogActions extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const ThemedDialogActions({
    Key? key,
    required this.text,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.button?.copyWith(
            color: Theme.of(context).colorScheme.primary
        ),
      ),
    );
  }
}

class ThemedDialogContent extends StatelessWidget {

  final String title;
  final String message;
  final List<Widget> actions;

  const ThemedDialogContent({
    Key? key,
    required this.title,
    required this.message,
    required this.actions
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.7,
          child: BlurBox(
              blurValue: 10,
              backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        // dialog title
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: _titleTextStyle(context),),
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1,),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    // dialog message content
                    child: Text(message, style: Theme.of(context).textTheme.bodyMedium,),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    // action buttons
                    children: actions,
                  )
                ],
              )
          ),
        )
      ],
    );
  }

  TextStyle? _titleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge
        ?.copyWith(color: Theme.of(context).colorScheme.background);
  }
}