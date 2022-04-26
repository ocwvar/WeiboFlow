
/// a model of weibo-text
/// it maybe a PlainText or weibo-emoji phase
/// if [isText] == True, [data] is plain text
/// if [isEmoji] == True, [data] is url of emoji
class WeiboText {
  final bool isText;
  final bool isEmoji;

  final String data;

  WeiboText({
    required this.isText,
    required this.isEmoji,
    required this.data
  });

  WeiboText.text({
    this.isText = true,
    this.isEmoji = false,
    required this.data
  });

  WeiboText.emoji({
    this.isText = false,
    this.isEmoji = true,
    required this.data
  });

}