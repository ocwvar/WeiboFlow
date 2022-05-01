import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weibo_flow/constants.dart';
import 'package:weibo_flow/generated/l10n.dart';
import 'package:weibo_flow/pages/home/view_model.dart';
import 'package:weibo_flow/widget/content.dart';
import 'package:weibo_flow/widget/page.dart';
import 'package:weibo_flow/widget/response_status_container.dart';

import '../../theme_view_model.dart';
import '../../widget/app_bar.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {

  final ThemeViewModel themeViewModel;
  bool isFirstEnter = true;

  HomePage({Key? key, required this.themeViewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final HomeViewModel viewModel = HomeViewModel();
  final double appBarHeight = kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    // on page has been fully created, then we check if we need to
    // request data
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.isFirstEnter) {
        widget.isFirstEnter = false;
        viewModel.loadNewContent();
      }
    });

    return ThemedPage(
        appBar: _getAppBar(context),
        child: ChangeNotifierProvider(
          create: (context) => viewModel,
          child: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              return ResponseStatusContainer(
                  baseRequestViewModel: viewModel,
                  onPressedRetry: () => viewModel.onRetryCalled(""),
                  onPressedReLogin: () {
                    Navigator.of(this.context).pushReplacementNamed(PageUrl.welcome);
                  },
                  child: _getContentList(context, viewModel)
              );
            },
          ),
        )
    );
  }

  void _shouldFetchOldContent(HomeViewModel viewModel, int index) {
    if (index < viewModel.contentList.length - Constant.fetchOldContentThreshold) {
      return;
    }

    // we should begin to load old content
    // if user looking at last [Constant.fetchOldContentThreshold] items
    if (!viewModel.isLoading) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        viewModel.loadOldContent();
      });
    }
  }

  /// get content view
  Widget _getContentList(BuildContext context, HomeViewModel viewModel) {
    return RefreshIndicator(
      edgeOffset: 10.0,
      displacement: appBarHeight + 30,
      onRefresh: () {
        viewModel.loadNewContent();
        return viewModel.waitUntilLoadingFinished();
      },
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            _shouldFetchOldContent(viewModel, index);
            return WeiboContent(content: viewModel.contentList[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 0,),
          itemCount: viewModel.contentList.length
      ),
    );
  }

  /// get app bar
  PreferredSize _getAppBar(BuildContext context) {
    return BlurAppBarFactory().get(
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
    );
  }

}