import 'package:weibo_flow/base/base_view_model.dart';
import 'package:weibo_flow/model/content.dart';

import '../../network/weibo_repository.dart';

class HomeViewModel extends BaseViewModel {

  /// list of [Content]
  List<Content> get contentList => _contentList;
  final List<Content> _contentList = [];

  /// repository
  final WeiboRepository _repository = WeiboRepository();

  /// flag of request error
  bool _wasError = false;

  /// current request page number
  int _pageNumber = 1;

  /// was last request has error
  bool wasError() {
    if (_wasError) {
      _wasError = false;
      return true;
    }

    return false;
  }

  /// request new content
  void requestNextPage() {
    _repository.getContentListOfFriends(_pageNumber.toString())
        .then((List<Content> result) {
          _contentList.addAll(result);
          notifyListeners();
        })
        .onError((_, __) {
          _wasError = true;
          notifyListeners();
        });
  }

}