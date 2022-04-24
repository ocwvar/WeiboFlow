import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weibo_flow/generated/l10n.dart';
import 'package:weibo_flow/pages/home/view_model.dart';
import 'package:weibo_flow/widget/content.dart';
import 'package:weibo_flow/widget/page.dart';

import '../../theme_view_model.dart';
import '../../widget/app_bar.dart';

class HomePage extends StatefulWidget {

  final ThemeViewModel themeViewModel;

  const HomePage({Key? key, required this.themeViewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final HomeViewModel viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return ThemedPage(
        appBar: BlurAppBarFactory().get(
          S().homeTitle,
          context,
          actions: [
            IconButton(onPressed: (){
              widget.themeViewModel.debugD();
            }, icon: const Icon(Icons.wb_sunny)),
            IconButton(onPressed: (){
              widget.themeViewModel.debugC();
            }, icon: const Icon(Icons.color_lens)),
          ]
        ),
        child: ChangeNotifierProvider(
          create: (context) => viewModel,
          child: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.contentList.isEmpty) {
                viewModel.requestNextPage();
              }
              return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return WeiboContent(content: viewModel.contentList[index]);
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 0,),
                  itemCount: viewModel.contentList.length
              );
            },
          ),
        )
    );
  }

}