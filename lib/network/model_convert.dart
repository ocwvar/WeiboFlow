import 'dart:collection';
import 'dart:convert';

import 'package:intl/intl.dart';
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
    /// convert date string: Sun Apr 24 14:07:36 +0800 2022
    /// to 2022-04-24 14:07:36
    /// since DateFormat not supporting "Z (TimeZone)", we need to
    /// ignore this here for now. But it should be always +0800 anyway...
    String _convertDataString(String raw) {
      final String temp = raw.replaceAll(RegExp("\\+[0-9]{4} "), "");
      final DateTime dateTime = DateFormat("EEE MMM dd HH:mm:ss yyyy").parse(temp);
      return DateFormat("yyyy-MM-dd @HH:mm:ss").format(dateTime);
    }

    /// get retweet content if it have
    Content? _getRetweetContent() {
      if (!item.containsKey("retweeted_status")) {
        return null;
      }

      return toContent(item["retweeted_status"]);
    }

    return Content(
        id: item["idstr"],
        fromUser: toUser(item["user"]),
        textContent: item["text"],
        createTime: _convertDataString(item["created_at"]),
        pictures: toPictures(item["pic_urls"]),
        retweetedContent: _getRetweetContent()
    );
  }

  static List<Picture> toPictures(List<dynamic> pictureList) {
    final List<Picture> result = [];
    for (LinkedHashMap<String, dynamic> item in pictureList) {
      final String orj480 =  (item["thumbnail_pic"] as String).replaceAll(RegExp("thumbnail"), "orj480");
      result.add(Picture(orj480));
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