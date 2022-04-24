import 'package:dio/dio.dart';
import 'package:weibo_flow/data_singleton.dart';
import 'package:weibo_flow/model/content.dart';
import 'package:weibo_flow/network/model_convert.dart';
import 'package:weibo_flow/network/urls.dart';

import '../base/keys.dart';

class WeiboRepository {

  /// check if is a successful response
  /// if statusCode is not 200 and response content is Null
  /// will throw an [Exception]
  void _throwIfFailed(Response<dynamic> response) {
    if (response.statusCode != 200 || response.data == null) {
      throw Exception();
    }
  }

  /// get [List] of [Content]
  /// param [page] which page to load, starting from 1
  /// param [count] how many content item in a page, default is 20, range: [0, 100]
  Future<List<Content>> getContentListOfFriends(String page, { int count = 20 }) async {
    final Response<String> response = await DataSingleton.self.client.get<String>(
        Urls.contentOfFriends,
        queryParameters: {
          Keys.keyRequestCount : count.toString()
        }
    );

    _throwIfFailed(response);
    return ModelConvert.toFriendContentList(response.data!);
  }

}