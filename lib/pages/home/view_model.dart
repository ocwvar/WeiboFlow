import 'package:weibo_flow/base/base_view_model.dart';
import 'package:weibo_flow/model/content.dart';
import 'package:weibo_flow/model/enum/fetch_type.dart';

import '../../base/pair.dart';

class HomeViewModel extends BaseRequestViewModel {

  /// list of [Content]
  List<Content> get contentList => _contentList;
  final List<Content> _contentList = [];

  /// since_id for request new content
  String _lastSinceId = "0";

  /// max_id for request old content
  String _lastMaxId = "0";

  @override
  void onRetryCalled(String tag) {

  }

  /// fetch old content
  void loadOldContent() {
    if (_lastSinceId == "0") {
      _requestContent(FetchType.init);
      return;
    }

    _requestContent(FetchType.older);
  }

  /// fetch new content
  void loadNewContent() {
    if (_lastSinceId == "0") {
      _requestContent(FetchType.init);
      return;
    }

    _requestContent(FetchType.newer);
  }

  /// request content
  /// param [fetchType] for request type
  void _requestContent(FetchType fetchType) {
    // skip if we are loading
    if (super.isLoading) return;

    // init all request param here
    final String sinceId;
    final String maxId;

    switch(fetchType) {
      case FetchType.init:
      case FetchType.newer:
        sinceId = _lastSinceId;
        maxId = "0";
        break;
      case FetchType.older:
        sinceId = "0";
        maxId = _lastMaxId;
        break;
    }

    // request content
    super.newRequest<Pair<String, List<Content>>>(
            (repository) => repository.getContentListOfFriends(
                sinceId: sinceId,
                maxId: maxId
            ),
            (result) {
              switch (fetchType) {
                // for new or init
                case FetchType.init:
                case FetchType.newer:
                  if (fetchType == FetchType.init) {
                    // should set max id for init purpose
                    // so that we can fetch old content base on that
                    _lastMaxId = result.second.last.id;
                  }
                  _lastSinceId = result.first;
                  _contentList.insertAll(0, result.second);
                  break;

                case FetchType.older:
                  _lastMaxId = result.second.last.id;
                  // if we are requesting old content with maxId
                  // here will return the old content list but
                  // with the same [maxId] in first item in that list
                  // so we should remove that from result list
                  result.second.removeAt(0);

                  // add all old content to list bottom
                  _contentList.addAll(result.second);
                  break;
              }
        }
    );
  }

}