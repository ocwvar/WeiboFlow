import 'package:flutter/material.dart';
import 'package:weibo_flow/entrance_view_model.dart';
import 'package:weibo_flow/widget/page.dart';

class HomePage extends StatefulWidget {

  final ThemeViewModel themeViewModel;

  const HomePage({Key? key, required this.themeViewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ThemedPage.withoutAppBar(
        child: Text("")
    );
  }

}