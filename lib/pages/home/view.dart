import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weibo_flow/entrance_view_model.dart';
import 'package:weibo_flow/pages/home/view_model.dart';
import 'package:weibo_flow/widget/page.dart';

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
    return ThemedPage.withoutAppBar(
        child: ChangeNotifierProvider(
          create: (context) => viewModel,
          child: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.contentList.isEmpty) {
                viewModel.requestNextPage();
              }
              return Text("");
            },
          ),
        )
    );
  }

}