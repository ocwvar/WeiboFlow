import 'package:weibo_flow/model/picture.dart';
import 'package:weibo_flow/model/user.dart';

class Content {
  final String id;
  final User fromUser;
  final String textContent;
  final String createTime;
  final List<Picture> pictures;
  final Content? retweetedContent;

  Content({
    required this.id,
    required this.fromUser,
    required this.textContent,
    required this.createTime,
    required this.pictures,
    required this.retweetedContent
  });
}