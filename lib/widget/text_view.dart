import 'package:flutter/material.dart';
import 'package:weibo_flow/model/weibo_text.dart';

/// display text with Weibo emoji together
class WeiboTextView extends StatelessWidget {

  final List<WeiboText> textList;

  const WeiboTextView({
    Key? key,
    required this.textList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(
        children: _getTexts(context)
      )
    );
  }

  List<InlineSpan> _getTexts(BuildContext context) {
    final List<InlineSpan> result = [];
    for(WeiboText text in textList) {
      // display text
      if (text.isText) {
        result.add(
            TextSpan(
                text: text.data,
                style: Theme.of(context).textTheme.bodyMedium
            )
        );
        continue;
      }

      // display emoji
      if (text.isEmoji) {
        result.add(
          WidgetSpan(
            child: Image.asset(
              text.data,
              width: 20,
              height: 20,
              filterQuality: FilterQuality.low,
              cacheWidth: 50,
              cacheHeight: 50,
            ),
          )
        );
      }
    }

    return result;
  }

}