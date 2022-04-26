import 'package:cached_network_image/cached_network_image.dart';
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
            child: CachedNetworkImage(
              imageUrl: text.data,
              height: 15,
              width: 15,
            ),
          )
        );
      }
    }

    return result;
  }

}