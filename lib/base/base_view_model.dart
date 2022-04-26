import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weibo_flow/base/keys.dart';
import 'package:weibo_flow/data_singleton.dart';

import 'log.dart';

const String tag = "token_check";
class BaseViewModel extends ChangeNotifier {

  bool isTokenValid() {
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

}