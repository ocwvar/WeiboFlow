import 'package:flutter/material.dart';
import 'package:weibo_flow/base/base_view_model.dart';
import 'package:weibo_flow/base/dialog.dart';
import 'package:weibo_flow/constants.dart';
import 'package:weibo_flow/pages/welcome/view.dart';
import 'package:weibo_flow/theme_view_model.dart';

import '../generated/l10n.dart';

/// a container that will response to status of [BaseRequestViewModel]
/// like [BaseRequestViewModel.errorCode] and [BaseRequestViewModel.isLoading]
/// should use inside [Consumer.builder] as child
class ResponseStatusContainer extends StatelessWidget {

  final ThemeViewModel themeViewModel;
  final BaseRequestViewModel baseRequestViewModel;
  final Widget child;

  const ResponseStatusContainer({
    Key? key,
    required this.themeViewModel,
    required this.baseRequestViewModel,
    required this.child
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

  /// callback on user clicked "Retry" button on dialog
  void _onPressedRetryButton() {
    baseRequestViewModel.onRetryCalled("");
  }

  /// callback on user clicked Login again button on dialog
  void _onPressedReLoginButton(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => WelcomePage(
              themeViewModel: themeViewModel,
            )
        )
    );
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
                        _onPressedRetryButton();
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
                      _onPressedReLoginButton(context);
                      Navigator.pop(dialogContext);
                    },
                    text: S.of(context).dialogButtonReLogin,
                  ),
                ]
            ),
        )
    );
  }

}