import 'package:flutter/material.dart';
import 'package:weibo_flow/base/base_view_model.dart';
import 'package:weibo_flow/base/dialog.dart';
import 'package:weibo_flow/constants.dart';

import '../generated/l10n.dart';

/// a container that will response to status of [BaseRequestViewModel]
/// like [BaseRequestViewModel.errorCode] and [BaseRequestViewModel.isLoading]
/// should use inside [Consumer.builder] as child
class ResponseStatusContainer extends StatelessWidget {

  final BaseRequestViewModel baseRequestViewModel;
  final Widget child;

  final Function()? onPressedRetry;
  final Function()? onPressedReLogin;

  const ResponseStatusContainer({
    Key? key,
    required this.baseRequestViewModel,
    required this.child,
    this.onPressedRetry,
    this.onPressedReLogin
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // display error dialog
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (baseRequestViewModel.errorCode != ErrorCodes.errorNon) {
        switch(baseRequestViewModel.errorCode) {
          case ErrorCodes.errorUnknown:
          case ErrorCodes.errorNetwork:
            _displayNormalError(context, false);
            break;

          case ErrorCodes.errorTokenInvalid:
            _displayTokenIssue(context);
            break;
        }
      }
    });

    return child;
  }

  /// display normal or unknown error dialog
  void _displayNormalError(BuildContext context, bool cancelable) {
    showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: cancelable,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (dialogContext) => WillPopScope(
            onWillPop: () async => cancelable,
            child: ThemedDialogContent(
                title: S.of(context).dialogErrorTitle,
                message: S.of(context).dialogErrorNormal,
                actions: [
                  ThemedDialogActions(
                      onPressed: (){
                        onPressedRetry?.call();
                        Navigator.pop(dialogContext);
                      },
                      text: S.of(context).retry
                  ),
                ]
            ),
        )
    );
  }

  /// display token invalid or expired error dialog
  void _displayTokenIssue(BuildContext context) {
    showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (dialogContext) => WillPopScope(
            onWillPop: () async => false,
            child: ThemedDialogContent(
                title: S.of(context).dialogErrorTitle,
                message: S.of(context).dialogErrorTokenExpired,
                actions: [
                  ThemedDialogActions(
                    onPressed: (){
                      Navigator.pop(dialogContext);
                      onPressedReLogin?.call();
                    },
                    text: S.of(context).dialogButtonReLogin,
                  ),
                ]
            ),
        )
    );
  }

}