class Constant {
  static const int fetchOldContentThreshold = 15;
}

class Keys {
  static const String channel = "native_code_weibo_auth_api";
  static const String methodInitSDK = "METHOD_INIT_SDK";
  static const String methodAuthSDK = "METHOD_AUTH_SDK";
  static const String prefixDateJustNow = "1#";
  static const String prefixDateToday = "2#";
  static const String prefixDateYesterday = "3#";
  static const String keyRequestTokenAccess = "access_token";
  static const String keyRequestCount = "count";
  static const String keySinceId = "since_id";
  static const String keyRequestMaxId = "max_id";
  static const String keyStringTokenAccess = "KEY_STRING_TOKEN_ACCESS";
  static const String keyStringTokenRefresh = "KEY_STRING_TOKEN_REFRESH";
  static const String keyStringTokenUid = "KEY_STRING_UID";
  static const String keyStringRedirectUrl = "KEY_STRING_REDIRECT_URL";
  static const String keyStringExpireTime = "KEY_STRING_EXPIRE_TIME";
  static const String keyStringGenerateTime = "KEY_STRING_GENERATE_TIME";
  static const String keyBoolIsCancelByUser = "KEY_BOOL_IS_CANCELED";
  static const String keyIntThemeMode = "KEY_INT_THEME_MODE";
  static const String keyIntThemeBaseColor = "KEY_INT_THEME_BASE_COLOR";
}

class Urls {
  static const String domain = "https://api.weibo.com";
  static const String urlRefreshToken = domain + "/oauth2/access_token?client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET&grant_type=refresh_token&redirect_uri=YOUR_REGISTERED_REDIRECT_URI&refresh_token=";
  static const String contentOfFriends = domain + "/2/statuses/friends_timeline.json";
}

class ErrorCodes {
  static const int errorNon = 0;
  static const int errorTokenInvalid = 300;
  static const int errorNetwork = 301;
  static const int errorUnknown = 200;
}

class PageUrl {
  static const String welcome = "/Welcome";
  static const String home = "/Home";
}