import 'package:dio/dio.dart';
import 'package:weibo_flow/base/log.dart';
import 'package:weibo_flow/model/content.dart';
import 'package:weibo_flow/model/enum/weibo_response_type.dart';
import 'package:weibo_flow/network/model_convert.dart';

import '../constants.dart';
import '../base/pair.dart';
import '../data_singleton.dart';
import '../model/wrap_response.dart';

class WeiboRepository {

  /// try to get json response from weibo backend
  /// handled all exception in this function and return [WeiboResponse] as result
  Future<WeiboResponse> _tryToGetJsonResponse(String url, Map<String, String> queryParameters) async {
    try {
      // add access token
      queryParameters[Keys.keyRequestTokenAccess] = DataSingleton.self.sdkModel.accessToken;

      // begin request
      final Response<String> response = await DataSingleton.self.client.get<String>(
          url,
          queryParameters: queryParameters,
      );

      // request error or no response content
      if (response.statusCode != 200 || response.data == null) {
        throw Exception("statusCode is not 200 or response.data is NULL");
      }

      // all good
      return WeiboResponse.success(
          jsonString: response.data!
      );
    } catch (e) {
      // any exception during requesting
      Logger.self.e("REQUEST_ERROR", e.toString());
      if (e is DioError) {
        Logger.self.e("REQUEST_ERROR_DETAIL", e.response?.data);
      }
      final WeiboResponseType failureType = _getErrorResponseType(e);
      return WeiboResponse.failure(responseType: failureType);
    }
  }

  /// will check error_code if [e] is [DioError] and response a valid type
  /// or just return [WeiboResponseType.failure]
  WeiboResponseType _getErrorResponseType(Object e){
    if (e is DioError) {
      final dynamic errorText = e.response?.data;
      if (errorText != null && errorText is String) {
        final Pair<int, String> error = ModelConvert.toWeiboErrorResponse(errorText);

        // error code mapping here:
        switch (error.first) {
          case 21332: // access token invalid
          case 21327: // access token expired
            DataSingleton.self.markTokenExpired();
            return WeiboResponseType.tokenInvalid;
        }

      }
    }

    return WeiboResponseType.failure;
  }

  /// will return [Result] with error code if its a error response
  /// or will call function: [convert] to get [Result] with data and return it
  Result<T> _getResult<T>(WeiboResponse response, T Function(String json) convert) {
    switch(response.responseType) {
      case WeiboResponseType.success:
        return Result.success(result: convert(response.jsonString));

      case WeiboResponseType.failure:
        return Result.error(errorCode: ErrorCodes.errorNetwork);

      case WeiboResponseType.tokenInvalid:
        return Result.error(errorCode: ErrorCodes.errorTokenInvalid);
    }
  }

  /// get [List] of [Content]
  /// param [lastSinceId] will load content of weibo which is newer than this.
  /// param [count] how many content item in a page, default is 20, range: [0, 100]
  /// return data: [Pair.first] -> since_id  [Pair.second] -> content list
  Future<Result<Pair<String, List<Content>>>> getContentListOfFriends(
      {
        String sinceId = "0",
        int count = 40,
        String maxId = "0"
      }) async {
    // send request
    final WeiboResponse response = await _tryToGetJsonResponse(
        Urls.contentOfFriends,
        {
          Keys.keySinceId : sinceId,
          Keys.keyRequestCount : count.toString(),
          Keys.keyRequestMaxId : maxId,
        }
    );

    // handle response
    final Result<Pair<String, List<Content>>> result = _getResult(response, (String json){
      return ModelConvert.toFriendContentList(json);
    });

    // return result =)
    return result;
  }
}