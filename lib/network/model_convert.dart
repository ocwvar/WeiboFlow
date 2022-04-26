import 'dart:collection';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:weibo_flow/base/keys.dart';
import 'package:weibo_flow/data_singleton.dart';
import 'package:weibo_flow/model/picture.dart';
import 'package:weibo_flow/model/user.dart';
import 'package:weibo_flow/model/weibo_text.dart';

import '../base/pair.dart';
import '../model/content.dart';

/// convert json string to correct model object
class ModelConvert {

  /// convert json of [Keys.contentOfFriends] response content into
  /// Weibo content list and SinceId
  static Pair<String, List<Content>> toFriendContentList(String jsonString) {
    final Map<String, dynamic> jsonObject = json.decoder.convert(jsonString);
    final List<dynamic> contents = jsonObject["statuses"];

    final List<Content> result = [];
    for (LinkedHashMap<String, dynamic> item in contents) {
      result.add(toContent(item));
    }

    return Pair(
        (jsonObject["since_id"] as int).toString(),
        result
    );
  }

  /// convert to single [Content] object
  static Content toContent(LinkedHashMap<String, dynamic> item) {
    /// convert date string: Sun Apr 24 14:07:36 +0800 2022
    /// to 2022-04-24 14:07:36
    /// since DateFormat not supporting "Z (TimeZone)", we need to
    /// ignore this here for now. But it should be always +0800 anyway...
    String _convertDataString(String raw) {
      final String temp = raw.replaceAll(RegExp("\\+[0-9]{4} "), "");
      final DateTime dateTime = DateFormat("EEE MMM dd HH:mm:ss yyyy").parse(temp);
      final String prefix;
      if (DateTime.now().millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch < 20 * 1000) {
        prefix = Keys.prefixDateJustNow;
      } else {
        prefix = "";
      }
      return prefix + DateFormat("yyyy-MM-dd @HH:mm:ss").format(dateTime);
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
        weiboTextContent: toWeiboText(item["text"]),
        createTime: _convertDataString(item["created_at"]),
        pictures: toPictures(item["pic_urls"]),
        retweetedContent: _getRetweetContent()
    );
  }

  /// convert text into list of [WeiboText]
  /// which included text and also emoji
  static List<WeiboText> toWeiboText(String text) {

    /// replace "//@" -> " ➞ @"
    String _replaceRetweetedChar(String text) {
      return text.replaceAll("//@", " ➞ @");
    }

    final List<WeiboText> result = [];
    for(int index = 0, lastValidEnd = 0, lastValidStart = 0, lastCropIndex = 0; index < text.length ; index++) {
      // first loop to find first '['
      if (text[index] == '[') {
        for(int end = index + 1; end < text.length; end++) {
          // second loop to find next ']'
          if (text[end] == ']') {
            // substring to get text: [xxx]
            final String found = text.substring(index, end + 1);
            final String? assetsPath = DataSingleton.self.indexWeiboEmojiAssetsPath(found);
            if (assetsPath != null) {
              // is a valid tag
              lastValidEnd = end + 1;
              lastValidStart = index;
              result.add(WeiboText.emoji(data: assetsPath));
            }
            break;
          }
        }

        // crop plain text
        final WeiboText? croppedPlainText;
        if (lastCropIndex < lastValidStart) {
          croppedPlainText = WeiboText.text(data: _replaceRetweetedChar(text.substring(lastCropIndex, lastValidStart)));
        } else {
          croppedPlainText = null;
        }

        // add plain text into list in correct order
        if (croppedPlainText != null) {
          if (result.isEmpty) {
            result.add(croppedPlainText);
          } else if (index + 1 == text.length) {
            result.add(croppedPlainText);
          } else {
            result.insert(result.length - 1, croppedPlainText);
          }
        }

        lastCropIndex = lastValidEnd;
      }

      // for last part of text
      if (index + 1 >= text.length) {
        final String lastPartPlainText = _replaceRetweetedChar(text.substring(lastCropIndex, index + 1));
        result.add(WeiboText.text(data: lastPartPlainText));
      }
    }

    return result;
  }

  /// convert to list of [Picture]
  static List<Picture> toPictures(List<dynamic> pictureList) {
    final List<Picture> result = [];
    for (LinkedHashMap<String, dynamic> item in pictureList) {
      // "orj480" means x480 image, that will bigger than "thumbnail"
      final String orj480 =  (item["thumbnail_pic"] as String).replaceAll(RegExp("thumbnail"), "orj480");
      result.add(Picture(orj480));
    }
    return result;
  }

  /// convert to single [User] object
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

  /// convert to weibo-emoji data mapping list
  /// return Map<Name, AssetsFilePath>
  static Map<String, String>toEmojiMapping(String jsonString) {
    final List<dynamic> jsonArray = json.decoder.convert(jsonString);
    final Map<String, String> result = {};
    for(LinkedHashMap<String, dynamic> item in jsonArray) {
      result[item["text"]] = "assets/weibo_emoji/" + item["file_name"];
    }
    return result;
  }

}