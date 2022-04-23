import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weibo_flow/pages/welcome/view.dart';

import 'entrance_view_model.dart';

void main() {
  runApp(const AppEntrance());
}

class AppEntrance extends StatelessWidget {
  const AppEntrance({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeViewModel(),
      child: Consumer<ThemeViewModel>(
        builder: (context, viewModel, child) {
          viewModel.setThemeFromColorOf(baseColor: Colors.lightBlueAccent, update: false);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: viewModel.themeMode,
            theme: viewModel.lightTheme,
            darkTheme: viewModel.darkTheme,
            home: WelcomePage(themeViewModel: viewModel,),
          );
        },
      ),
    );
  }
}