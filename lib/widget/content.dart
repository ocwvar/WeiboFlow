import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weibo_flow/generated/l10n.dart';
import 'package:weibo_flow/model/content.dart';

const double cardCornerRadius = 15.0;
const double mainCardElevation = 10.0;
const double cardInnerPadding = 10.0;

class WeiboContent extends StatelessWidget {

  final Content content;

  const WeiboContent({
    Key? key,
    required this.content
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
      child: Card(
        elevation: mainCardElevation,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardCornerRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(cardInnerPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // main user row
              Row(
                children: [
                  // user avatar
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        imageUrl: content.fromUser.avatarUrl,
                        placeholder: (context, string) => const Icon(Icons.account_circle_sharp),
                        placeholderFadeInDuration: const Duration(seconds: 1),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10,),

                  // user info panel
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(content.fromUser.name, style: _styleOfUserTitle(context),),
                      Text(content.fromUser.location, style: Theme.of(context).textTheme.caption)
                    ],
                  ),

                  const Spacer(),

                  IconButton(
                      onPressed: (){
                      },
                      icon: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      )
                  )
                ],
              ),
              const SizedBox(height: 10,),

              // content
              Text(content.textContent),

              // images
              _displayImages(),

              // retweet
              _displayRetweetContent(),

              // time string
              const SizedBox(height: 8,),
              SizedBox(
                width: double.infinity,
                child: Text(
                  content.createTime,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.caption,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// [TextStyle] of user title
  TextStyle? _styleOfUserTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium
        ?.copyWith(color: Theme.of(context).colorScheme.primary);
  }

  /// retweeted weibo content
  /// if we don't have, it will be just a [SizedBox.shrink]
  Widget _displayRetweetContent() {
    if (content.retweetedContent == null) {
      return const SizedBox.shrink();
    }

    return SubWeiboContent(content: content.retweetedContent!,);
  }

  /// display list of images
  /// return [SizedBox.shrink] if haven't image
  Widget _displayImages() {
    if (content.pictures.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 150,
      child: ListView.separated(
          padding: const EdgeInsets.only(top: 10),
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SizedBox(
              height: 150,
              width: 150,
              child: CachedNetworkImage(
                imageUrl: content.pictures[index].thumbnail,
                fit: BoxFit.cover,
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 2,),
          itemCount: content.pictures.length
      ),
    );
  }

}

class SubWeiboContent extends StatelessWidget {

  final Content content;

  const SubWeiboContent({
    Key? key,
    required this.content
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardCornerRadius),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(cardInnerPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // retweet text
                Row(
                  children: [
                    const Icon(
                      Icons.replay_circle_filled,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      S.of(context).contentRetweetText,
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
                const SizedBox(height: 10,),

                Text(content.fromUser.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),),
                Text(content.fromUser.location, style: Theme.of(context).textTheme.caption),
                const SizedBox(height: 10,),

                // content
                Text(content.textContent),

                // display images list
                _displayImages(),

                // time string
                const SizedBox(height: 8,),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    content.createTime,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.caption,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// display list of images
  /// return [SizedBox.shrink] if haven't image
  Widget _displayImages() {
    if (content.pictures.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 150,
      child: ListView.separated(
          padding: const EdgeInsets.only(top: 10),
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SizedBox(
              height: 150,
              width: 150,
              child: CachedNetworkImage(
                imageUrl: content.pictures[index].thumbnail,
                fit: BoxFit.cover,
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 2,),
          itemCount: content.pictures.length
      ),
    );
  }

}