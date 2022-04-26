import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weibo_flow/base/log.dart';

import 'base/keys.dart';

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

  /// request client
  Dio get client => _client;
  late Dio _client;

  /// weibo-emoji mapping
  /// Map<name, file_path>
  Map<String, String> _emojiMapping = {};

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

  /// init dio network request client
  void initRequestClient() {
    _client = Dio(BaseOptions(
      receiveTimeout: 5000,
      sendTimeout: 5000,
      connectTimeout: 5000,
      queryParameters: {
        Keys.keyRequestTokenAccess: sdkModel.accessToken
      }
    ));
  }

  /// init with new source of weibo-emoji
  void initEmojiMappingData(Map<String, String> source) {
    _emojiMapping.clear();
    _emojiMapping.addAll(source);
  }

  String? indexWeiboEmojiAssetsPath(String name) {
    return _emojiMapping[name];
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