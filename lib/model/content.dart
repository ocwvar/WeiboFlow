import 'package:weibo_flow/model/picture.dart';
import 'package:weibo_flow/model/user.dart';
import 'package:weibo_flow/model/weibo_text.dart';

class Content {
  final String id;
  final User fromUser;
  final List<WeiboText> weiboTextContent;
  final String createTime;
  final List<Picture> pictures;
  final Content? retweetedContent;

  Content({
    required this.id,
    required this.fromUser,
    required this.weiboTextContent,
    required this.createTime,
    required this.pictures,
    required this.retweetedContent
  });
}