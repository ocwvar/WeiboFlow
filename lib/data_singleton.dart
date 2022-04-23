import 'package:weibo_flow/base/log.dart';

class DataSingleton {
  static final DataSingleton self = DataSingleton._internal();
  DataSingleton._internal();

  factory DataSingleton() {
    return self;
  }

  /// get [SdkStatusModel] which will contain all info
  /// we need to send out a request
  SdkStatusModel get sdkModel => _sdkStatusModel;
  late SdkStatusModel _sdkStatusModel;

  /// was access token expired
  bool get wasTokenExpired => _wasTokenExpired;
  bool _wasTokenExpired = true;

  /// update a new SDK model
  void updateSdkModel(SdkStatusModel newModel) {
    _wasTokenExpired = false;
    _sdkStatusModel = newModel;
    Logger.self.d("updateSdkModel", "\naccessToken:${newModel.accessToken}\nrefreshToken:${newModel.refreshToken}\nexpireTime:${newModel.expireTime}\ngenerateTime:${newModel.generateTime}");
  }

  /// mark as token expired
  void markTokenExpired() {
    _wasTokenExpired = true;
  }

}

class SdkStatusModel {
  final String accessToken;
  final String refreshToken;
  final String redirectUrl;
  final double expireTime;
  final double generateTime;
  final String uid;

  SdkStatusModel({
    required this.accessToken,
    required this.refreshToken,
    required this.redirectUrl,
    required this.expireTime,
    required this.generateTime,
    required this.uid
  });
}