import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weibo_flow/model/content.dart';

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
        elevation: 10,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(10),
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
              SizedBox(width: double.infinity,child: Text(content.createTime, textAlign: TextAlign.right,style: Theme.of(context).textTheme.caption,),)
            ],
          ),
        ),
      ),
    );
  }

  TextStyle? _styleOfUserTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium
        ?.copyWith(color: Theme.of(context).colorScheme.primary);
  }

}