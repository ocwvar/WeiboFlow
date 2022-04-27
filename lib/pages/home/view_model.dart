import 'package:weibo_flow/base/base_view_model.dart';
import 'package:weibo_flow/model/content.dart';

import '../../base/pair.dart';

class HomeViewModel extends BaseRequestViewModel {

  /// list of [Content]
  List<Content> get contentList => _contentList;
  final List<Content> _contentList = [];

  /// request since id
  String _lastSinceId = "0";

  /// request new content
  void requestMoreNewContent() {
    if (super.isLoading) return;

    // request content
    super.newRequest<Pair<String, List<Content>>>(
            (repository) => repository.getContentListOfFriends(_lastSinceId),
            (result) {
              _lastSinceId = result.first;
              _contentList.insertAll(0, result.second);
            }
    );
  }

}