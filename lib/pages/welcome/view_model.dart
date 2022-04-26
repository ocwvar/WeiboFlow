import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:weibo_flow/base/keys.dart';
import 'package:weibo_flow/data_singleton.dart';

import '../../base/base_view_model.dart';
import '../../base/log.dart';
import '../../base/native_bridge.dart';
import '../../network/model_convert.dart';

const String tag = "welcome_vm";
class WelcomeViewModel extends BaseViewModel {

  // the bridge to native level
  final NativeBridge _nativeBridge = NativeBridge();

  bool get initCalled => _initCalled;
  bool _initCalled = false;

  bool get good2Go => _good2Go;
  bool _good2Go = false;

  bool get hasErrorOnInit => _errorOnInit;
  bool _errorOnInit = false;

  bool get hasErrorOnAuth => _errorOnAuth;
  bool _errorOnAuth = false;

  bool get hasErrorOnLoadRes => _errorOnLoadRes;
  bool _errorOnLoadRes = false;


  /// init sdk and also user authorize if there
  /// was no token or token was expired
  void initEveryThing() {
    Logger.self.d(tag, "initEveryThing");
    _initCalled = true;
    _nativeBridge.initSDK().then((_){
      // succeed, then we try to load sdk model from cache
      _onRecoverSdkModel();
    }).onError((_, __){
      _onSdkInitFailed();
    });
  }

  /// on check if we need to request new token from user
  void _onCheckSdkTokens() {
    Logger.self.d(tag, "_onCheckSdkTokens");
    if (!super.isTokenValid()) {
      _nativeBridge.authSDK().then((String jsonString){
        Logger.self.d("welcome_vm", "got new sdk token model json: $jsonString");
        _onSdkAuthSucceed(jsonString);
        _onLoadEmojiMapping();
      }).onError((error, stackTrace){
        _onSdkAuthFailed();
      });
      return;
    }

    // our token still valid, go to next step
    _onLoadEmojiMapping();
  }

  /// on load emoji mapping json
  void _onLoadEmojiMapping() {
    rootBundle.load("assets/weibo_emoji/mapping.json").then((ByteData value) {
      try {
        final String mappingJson = utf8.decoder.convert(value.buffer.asUint8List(0));
        final Map<String, String> result = ModelConvert.toEmojiMapping(mappingJson);
        DataSingleton.self.initEmojiMappingData(result);
        _onEveryThingSucceed();
      } catch (_) {
        _onLoadResFailed();
      }
    }).onError((_, __){
      _onLoadResFailed();
    });
  }

  /// called when [_nativeBridge.authSDK] was success
  void _onSdkAuthSucceed(String jsonString) {
    Logger.self.d(tag, "_onSdkAuthSucceed");
    final Map<String, dynamic> jsonObject = json.decoder.convert(jsonString);
    final SdkStatusModel newModel = SdkStatusModel(
        accessToken: jsonObject[Keys.keyStringTokenAccess],
        refreshToken: jsonObject[Keys.keyStringTokenRefresh],
        redirectUrl: jsonObject[Keys.keyStringRedirectUrl],
        expireTime: double.tryParse(jsonObject[Keys.keyStringExpireTime]) ?? 0,
        generateTime: double.tryParse(jsonObject[Keys.keyStringGenerateTime]) ?? 0,
        uid: jsonObject[Keys.keyStringTokenUid]
    );

    DataSingleton.self.updateSdkModel(newModel);
    super.saveStatusModelToCache(newModel);
  }

  /// on everything was succeed
  void _onEveryThingSucceed() {
    Logger.self.d(tag, "_onEveryThingSucceed");
    DataSingleton.self.initRequestClient();
    _good2Go = true;
    _errorOnInit = false;
    _errorOnAuth = false;
    notifyListeners();
  }

  /// on recover sdk model from local cache
  void _onRecoverSdkModel() {
    Logger.self.d(tag, "_onRecoverSdkModel");
    super.getLastStatusModelFromCache().then((SdkStatusModel? model){
      if (model != null) {
        DataSingleton.self.updateSdkModel(model);
      }
      _onCheckSdkTokens();
    }).onError((_, __){
      _onCheckSdkTokens();
    });
  }

  /// on sdk auth failed
  void _onSdkAuthFailed() {
    Logger.self.e(tag, "_onSdkAuthFailed");
    _good2Go = false;
    _errorOnInit = false;
    _errorOnAuth = true;
    notifyListeners();
  }

  /// on sdk init was failed
  /// we should not do anything else again
  void _onSdkInitFailed() {
    Logger.self.e(tag, "_onSdkInitFailed");
    _good2Go = false;
    _errorOnInit = true;
    notifyListeners();
  }

  /// on resource init was failed
  /// we should not do anything else again
  void _onLoadResFailed() {
    Logger.self.e(tag, "_onLoadResFailed");
    _good2Go = false;
    _errorOnLoadRes = true;
    notifyListeners();
  }

}