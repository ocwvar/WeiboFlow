import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weibo_flow/widget/blur.dart';

class BlurAppBarFactory {

  PreferredSize get(String title, BuildContext context, {bool hasBackButton = false, List<Widget>? actions}){
    return PreferredSize(
        preferredSize: Size(
            AppBar().preferredSize.width,
            AppBar().preferredSize.height
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: BlurBox(
            blurValue: 13,
            cornerRoundedValue: 0,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            child: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                title: Text(title),
                actions: actions,
                leading: _createBackButton(context, hasBackButton),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent
                ),
            ),
          ),
        )
    );
  }

  Widget? _createBackButton(BuildContext context, bool hasBackButton) {
    if (!hasBackButton) return null;

    return IconButton(
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.arrow_back)
    );
  }

}