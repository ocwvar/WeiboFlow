import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weibo_flow/entrance_view_model.dart';
import 'package:weibo_flow/pages/welcome/view_model.dart';
import 'package:weibo_flow/widget/blur.dart';
import 'package:weibo_flow/widget/page.dart';

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
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // we begin to init everything just after ui built up
      if (!viewModel.initCalled) {
        viewModel.initEveryThing();
        return;
      }

      // if all good to go, we should move to next page
      if (viewModel.good2Go) {
        _enterHomePage();
        return;
      }
    });

    return ThemedPage(
      child: ChangeNotifierProvider(
        create: (context) => viewModel,
        child: Consumer<WelcomeViewModel>(
          builder: (context, viewModel, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  "assets/bg/main_bg.svg",
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  fit: BoxFit.contain,
                ),
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
            );
          },
        ),
      ),
    );
  }

  /// get display status text on current viewModel status
  String _getDisplayStatusText(WelcomeViewModel viewModel) {
    if (viewModel.good2Go) {
      return "Here we go";
    }

    if (viewModel.hasErrorOnAuth) {
      return "User authorization failed";
    }

    if (viewModel.hasErrorOnInit) {
      return "Weibo SDK initialization failed";
    }

    return "Starting up...";
  }

  /// enter home page
  void _enterHomePage() {
    print('');
  }

}