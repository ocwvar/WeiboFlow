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
              children: [
                SvgPicture.asset(
                  "assets/bg/main_bg.svg",
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  fit: BoxFit.contain,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.alternate_email_sharp,
                          color: Theme.of(context).colorScheme.primary,
                          size: 200.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    BlurBox(
                        padding: const EdgeInsets.all(12),
                        blurValue: 3,
                        //backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.6),
                        cornerRoundedValue: 12,
                        child: Text(
                          _getDisplayStatusText(viewModel),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                    )
                  ],
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