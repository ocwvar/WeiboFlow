import 'package:flutter/services.dart';
import 'package:weibo_flow/base/keys.dart';

class NativeBridge {
  final MethodChannel _platform = MethodChannel(Keys.channel);

  Future<void> initSDK() async {
    final void result = await _platform.invokeMethod(Keys.methodInitSDK);
    return result;
  }

  Future<String> authSDK() async {
    final String result = await _platform.invokeMethod(Keys.methodAuthSDK);
    return result;
  }

}