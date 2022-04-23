import 'package:flutter/foundation.dart';

class Logger {
  static final Logger self = Logger._internal();
  Logger._internal();

  factory Logger() {
    return self;
  }

  void d(String tag, String msg) {
    if (kDebugMode) {
      print("### DEBUG  $tag  $msg");
    }
  }

  void e(String tag, String msg) {
    if (kDebugMode) {
      print("### ERROR  $tag  $msg");
    }
  }

}