import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weibo_flow/constants.dart';
import 'package:weibo_flow/pages/welcome/view_model.dart';
import 'package:weibo_flow/widget/blur.dart';
import 'package:weibo_flow/widget/page.dart';

import '../../generated/l10n.dart';
import '../../theme_view_model.dart';

/// this is first page that user can see after open up application
/// we should init sdk here, and when all things settled down, we
/// should head to next page to begin our journey
class WelcomePage extends StatefulWidget {
  final ThemeViewModel themeViewModel;

  const WelcomePage({Key? key, required this.themeViewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  final WelcomeViewModel viewModel = WelcomeViewModel();

  @override
  Widget build(BuildContext context) {
    return ThemedPage.withoutAppBar(
      child: ChangeNotifierProvider(
        create: (context) => viewModel,
        child: Consumer<WelcomeViewModel>(
          builder: (context, viewModel, child) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              // we begin to init everything just after ui built up
              if (!viewModel.initCalled) {
                viewModel.initEveryThing();
                return;
              }

              if (viewModel.good2Go) {
                Future.delayed(const Duration(seconds: 2)).then((_) => _enterHomePage());
                return;
              }
            });

            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BlurBox(
                    cornerRoundedValue: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30,),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                "assets/imgs/cat.png",
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Text("Weibo@Flow", style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.w300
                        )),
                        const SizedBox(height: 30,),
                        Text(
                          _getDisplayStatusText(viewModel),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 30,),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// get display status text on current viewModel status
  String _getDisplayStatusText(WelcomeViewModel viewModel) {
    if (viewModel.hasErrorOnAuth) {
      return S.of(context).welcomeStatusErrorOnAuth;
    }

    if (viewModel.hasErrorOnInit) {
      return S.of(context).welcomeStatusErrorOnInit;
    }

    return S.of(context).welcomeStatusStarting;
  }

  /// enter home page
  void _enterHomePage() {
    Navigator.of(context).pushReplacementNamed(PageUrl.home);
  }

}