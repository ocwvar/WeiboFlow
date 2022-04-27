import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weibo_flow/constants.dart';
import 'package:weibo_flow/data_singleton.dart';

import '../model/wrap_response.dart';
import '../network/weibo_repository.dart';
import 'log.dart';

const String tag = "token_check";
abstract class BaseRequestViewModel extends ChangeNotifier {

  /// flag of loading status
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  /// error codes
  int get errorCode => _errorCode;
  int _errorCode = ErrorCodes.errorNon;

  /// repository
  WeiboRepository get repository => _repository;
  final WeiboRepository _repository = WeiboRepository();

  /// begin new request to weibo-backend
  /// param [requestBlock] will return a [Future] task to request
  /// param [responseBlock] will be called with result [T] if succeed
  ///
  /// will update [isLoading] when request begin and notify listeners
  /// will update [errorCode] and notify listeners if any happened during requesting
  void newRequest<T>(
      Future<Result<T>> Function(WeiboRepository repository) requestBlock,
      Function(T result) responseBlock
      ) {
    // begin loading status
    _isLoading = true;
    notifyListeners();

    // begin request
    requestBlock(_repository).then((Result<T> result) {
      _isLoading = false;

      // try to get result
      final T? data = _getResultDataIfSucceed(result);
      if (data != null) {
        responseBlock(data);
      }

      notifyListeners();
    }).onError((_, __){
      _isLoading = false;
      _errorCode = ErrorCodes.errorUnknown;
      notifyListeners();
    });
  }

  /// check if cached token [DataSingleton.self.sdkModel.accessToken] still valid
  bool isCachedTokenValid() {
    // check if we have data in singleton
    if (DataSingleton.self.wasTokenExpired) {
      Logger.self.e(tag, "was expired");
      return false;
    }

    // if currentTime >= generateTime + expireTime
    // means token expired
    final SdkStatusModel lastModel = DataSingleton.self.sdkModel;
    if (DateTime.now().millisecondsSinceEpoch >= lastModel.expireTime + lastModel.generateTime) {
      DataSingleton.self.markTokenExpired();
      Logger.self.e(tag, "expire time passed");
      return false;
    }

    Logger.self.d(tag, "token still valid");
    return true;
  }

  /// save [SdkStatusModel] into local cache
  void saveStatusModelToCache(SdkStatusModel model) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Keys.keyStringTokenAccess, model.accessToken);
    prefs.setString(Keys.keyStringTokenRefresh, model.refreshToken);
    prefs.setString(Keys.keyStringTokenUid, model.uid);
    prefs.setString(Keys.keyStringRedirectUrl, model.redirectUrl);
    prefs.setDouble(Keys.keyStringExpireTime, model.expireTime);
    prefs.setDouble(Keys.keyStringGenerateTime, model.generateTime);
  }

  /// get [SdkStatusModel] from local cache
  /// return [SdkStatusModel] or [Null] if data not found or not completed
  Future<SdkStatusModel?> getLastStatusModelFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString(Keys.keyStringTokenAccess);
    final String? refreshToken = prefs.getString(Keys.keyStringTokenRefresh);
    final String? uid = prefs.getString(Keys.keyStringTokenUid);
    final String? redirectUrl = prefs.getString(Keys.keyStringRedirectUrl);
    final double? expireTime = prefs.getDouble(Keys.keyStringExpireTime);
    final double? generateTime = prefs.getDouble(Keys.keyStringGenerateTime);
    if (accessToken == null || refreshToken == null || uid == null || redirectUrl == null || expireTime == null || generateTime == null) {
      Logger.self.e(tag, "cache data is not complete, returning NULL");
      return null;
    }

    Logger.self.d(tag, "valid cache founded");
    return SdkStatusModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        redirectUrl: redirectUrl,
        expireTime: expireTime,
        generateTime: generateTime,
        uid: uid
    );
  }

  /// return [T] if its a succeed result
  /// or it will return [Null] and setup error status
  T? _getResultDataIfSucceed<T>(Result<T> result) {
    if (result.result != null) {
      // has data, means okay
      return result.result;
    }

    _errorCode = result.errorCode ?? ErrorCodes.errorUnknown;
    return null;
  }

}