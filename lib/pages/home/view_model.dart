import 'package:weibo_flow/base/base_view_model.dart';
import 'package:weibo_flow/model/content.dart';

import '../../base/pair.dart';
import '../../network/weibo_repository.dart';

class HomeViewModel extends BaseViewModel {

  /// list of [Content]
  List<Content> get contentList => _contentList;
  final List<Content> _contentList = [];

  /// repository
  final WeiboRepository _repository = WeiboRepository();

  /// flag of request error
  bool _wasError = false;

  /// request since id
  String _lastSinceId = "0";

  /// flag of loading status
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  /// was last request has error
  bool wasError() {
    if (_wasError) {
      _wasError = false;
      return true;
    }

    return false;
  }

  /// request new content
  void requestMoreNewContent() {
    if (_isLoading) return;

    _isLoading = true;
    _repository.getContentListOfFriends(_lastSinceId)
        .then((Pair<String, List<Content>> result) {
          _lastSinceId = result.first;
          _contentList.insertAll(0, result.second);
          _wasError = false;
          _isLoading = false;
          notifyListeners();
        })
        .onError((_, __) {
          _wasError = true;
          _isLoading = false;
          notifyListeners();
        });
  }

}