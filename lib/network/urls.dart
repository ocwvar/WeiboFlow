class Urls {
  static const String domain = "https://api.weibo.com";
  static const String urlRefreshToken = domain + "/oauth2/access_token?client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET&grant_type=refresh_token&redirect_uri=YOUR_REGISTERED_REDIRECT_URI&refresh_token=";
  static const String contentOfFriends = domain + "/2/statuses/friends_timeline.json";
}