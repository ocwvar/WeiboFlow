import 'package:dio/dio.dart';
import 'package:weibo_flow/model/content.dart';
import 'package:weibo_flow/network/model_convert.dart';
import 'package:weibo_flow/network/urls.dart';

import '../base/keys.dart';
import '../base/pair.dart';
import '../data_singleton.dart';

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
  /// return data: [Pair.first] -> since_id  [Pair.second] -> content list
  Future<Pair<String, List<Content>>> getContentListOfFriends(String lastSinceId, { int count = 20 }) async {
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