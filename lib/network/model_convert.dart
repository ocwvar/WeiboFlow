import 'dart:collection';
import 'dart:convert';

import 'package:weibo_flow/model/picture.dart';
import 'package:weibo_flow/model/user.dart';

import '../model/content.dart';

/// convert json string to correct model object
class ModelConvert {

  static List<Content> toFriendContentList(String jsonString) {
    final Map<String, dynamic> jsonObject = json.decoder.convert(jsonString);
    final List<dynamic> contents = jsonObject["statuses"];

    final List<Content> result = [];
    for (LinkedHashMap<String, dynamic> item in contents) {
      result.add(toContent(item));
    }

    return result;
  }

  static Content toContent(LinkedHashMap<String, dynamic> item) {
    return Content(
        id: item["idstr"],
        fromUser: toUser(item["user"]),
        textContent: item["text"],
        createTime: item["created_at"],
        pictures: toPictures(item["pic_urls"]),
        isRetweetedContent: false,
        retweetedContent: null
    );
  }

  static List<Picture> toPictures(List<dynamic> pictureList) {
    final List<Picture> result = [];
    for (LinkedHashMap<String, dynamic> item in pictureList) {
      result.add(Picture(item["thumbnail_pic"]));
    }
    return result;
  }

  static User toUser(LinkedHashMap<String, dynamic> item) {
    return User(
        id: item["idstr"],
        name: item["name"],
        location: item["location"],
        gender: item["gender"],
        avatarUrl: item["avatar_large"],
        isOnline: item["online_status"] == 1
    );
  }

}