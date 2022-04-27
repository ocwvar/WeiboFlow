
import '../constants.dart';
import 'enum/weibo_response_type.dart';

/// a model for wrapping weibo backend response
class WeiboResponse {
  final WeiboResponseType responseType;
  final String jsonString;

  WeiboResponse({required this.responseType, required this.jsonString});

  WeiboResponse.success({
    this.responseType = WeiboResponseType.success,
    required this.jsonString
  });

  WeiboResponse.failure({
    required this.responseType,
    this.jsonString = ""
  });
}

class Result<T> {
  final int? errorCode;
  final T? result;

  Result({
    required this.errorCode,
    required this.result
  });

  Result.success({
    this.errorCode = ErrorCodes.errorNon,
    required this.result
  });

  Result.error({
    required this.errorCode,
    this.result
  });

}