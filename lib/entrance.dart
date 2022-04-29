import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weibo_flow/constants.dart';
import 'package:weibo_flow/pages/home/view.dart';
import 'package:weibo_flow/pages/welcome/view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weibo_flow/theme_view_model.dart';

import 'generated/l10n.dart';

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
          if (!viewModel.isSettingSynced) {
            viewModel.syncLastCachedConfig();
            return const SizedBox.shrink();
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            themeMode: viewModel.themeMode,
            theme: viewModel.lightTheme,
            darkTheme: viewModel.darkTheme,
            initialRoute: PageUrl.welcome,
            routes: {
              PageUrl.welcome: (context) => WelcomePage(themeViewModel: viewModel,),
              PageUrl.home: (context) => HomePage(themeViewModel: viewModel,),
            },
          );
        },
      ),
    );
  }
}