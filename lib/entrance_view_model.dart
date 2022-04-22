import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weibo_flow/base/keys.dart';
import 'package:weibo_flow/base/native_bridge.dart';

class EntranceViewModel extends ChangeNotifier {
  
  // the bridge to native level
  final NativeBridge _nativeBridge = NativeBridge();
  
  // status model that have all sdk info
  SdkStatusModel? _status;
  SdkStatusModel? get status => _status;

  // flag of result [initSDK]
  // if this is true, means we should just call [_authSDK]
  bool _wasInitSucceed = false;

  /// init weibo sdk
  /// if success, will call [_authSDK] or will update [_status] with error
  /// because once init succeed, will never have callback again
  void initSDK() {
    if (_wasInitSucceed) {
      _authSDK();
      return;
    }

    _nativeBridge.initSDK()
        .then((_) {
          _wasInitSucceed = true;
          _authSDK();
        })
        .onError((error, stackTrace){
          _hasError("failed to init SDK");
        });
  }

  /// auth weibo sdk with user login
  /// will update [_status] with status
  void _authSDK() {
    _nativeBridge.authSDK()
        .then((value) => _handleAuthJson(value))
        .onError((PlatformException error, stackTrace){
          _hasError(error.message ?? "unknown error in _authSDK");
        });
  }

  /// called when [_authSDK] was success
  /// will update [_status] with tokens string
  void _handleAuthJson(String jsonString) {
    final Map<String, dynamic> jsonObject = json.decoder.convert(jsonString);
    _status = SdkStatusModel(
        isGood2Go: true,
        hasError: false,
        accessToken: jsonObject[Keys.keyStringTokenAccess] ?? "",
        refreshToken: jsonObject[Keys.keyStringTokenRefresh] ?? "",
        uid: jsonObject[Keys.keyStringTokenUid] ?? "",
    );
    notifyListeners();
  }

  /// any error happened will call this
  /// will update [status] with error message
  void _hasError(String reason) {
    _status = SdkStatusModel(isGood2Go: false, hasError: true, errorMessage: reason);
    notifyListeners();
  }
}

class SdkStatusModel {
  final bool isGood2Go;
  final bool hasError;
  final String errorMessage;

  final String accessToken;
  final String refreshToken;
  final String uid;

  SdkStatusModel({
      required this.isGood2Go,
      required this.hasError,
      this.errorMessage = "",
      this.accessToken = "",
      this.refreshToken = "",
      this.uid = ""
  });
}