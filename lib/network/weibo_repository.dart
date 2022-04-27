import 'package:dio/dio.dart';
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
      final Response<String> response = await DataSingleton.self.client.get<String>(
          url,
          queryParameters: queryParameters,
      );

      // request error or no response content
      if (response.statusCode != 200 || response.data == null) {
        return WeiboResponse.failure(
            responseType: WeiboResponseType.failure
        );
      }

      // all good
      return WeiboResponse.success(
          jsonString: response.data!
      );
    }catch (e) {
      // any exception during requesting
      return WeiboResponse.failure(
          responseType: WeiboResponseType.tokenInvalid
      );
    }
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
  /// param [page] which page to load, starting from 1
  /// param [count] how many content item in a page, default is 20, range: [0, 100]
  /// return data: [Pair.first] -> since_id  [Pair.second] -> content list
  Future<Result<Pair<String, List<Content>>>> getContentListOfFriends(String lastSinceId, { int count = 40 }) async {
    // send request
    final WeiboResponse response = await _tryToGetJsonResponse(Urls.contentOfFriends, {Keys.keyRequestCount : count.toString()});

    // handle response
    final Result<Pair<String, List<Content>>> result = _getResult(response, (String json){
      return ModelConvert.toFriendContentList(json);
    });

    // return result =)
    return result;
  }
}