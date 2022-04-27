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

  const ResponseStatusContainer({
    Key? key,
    required this.baseRequestViewModel,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // display error dialog
    if (baseRequestViewModel.errorCode != ErrorCodes.errorNon) {
      switch(baseRequestViewModel.errorCode) {
        case ErrorCodes.errorUnknown:
        case ErrorCodes.errorNetwork:
          _displayNormalError(context);
          break;

        case ErrorCodes.errorTokenInvalid:
          _displayTokenIssue(context);
          break;
      }
    }

    return Stack(
      children: [
        child,
        _displayLoadingStatus(),
      ],
    );
  }

  /// callback on user clicked "Retry" button on dialog
  void _onPressedRetryButton() {

  }

  /// callback on user clicked Login again button on dialog
  void _onPressedReLoginButton() {

  }

  /// display loading indicator when [baseRequestViewModel.isLoading] == true
  /// or return empty widget [SizedBox.expand]
  Widget _displayLoadingStatus() {
    if (baseRequestViewModel.isLoading) {
      return const LinearProgressIndicator();
    }
    return const SizedBox.shrink();
  }

  /// display normal or unknown error dialog
  void _displayNormalError(BuildContext context) {
    showDialog(
        context: context,
        useSafeArea: false,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (dialogContext) => ThemedDialogContent(
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
                      _onPressedReLoginButton();
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