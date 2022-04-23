import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weibo_flow/entrance_view_model.dart';
import 'package:weibo_flow/widget/blur.dart';
import 'package:weibo_flow/widget/page.dart';

/// this is first page that user can see after open up application
/// we should init sdk here, and when all things settled down, we
/// should head to next page to begin our journey
class WelcomePage extends StatefulWidget {
  final EntranceViewModel entranceViewModel;

  const WelcomePage({Key? key, required this.entranceViewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return ThemedPage(
      child: Stack(
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
                    "initializing Weibo ...",
                    style: Theme.of(context).textTheme.titleLarge,
                  )
              )
            ],
          )
        ],
      ),
    );
  }

  void _initSDK() {
    widget.entranceViewModel.initSDK();
  }

  String _getInfo(SdkStatusModel? model) {
    if (model == null) {
      return "Status is null";
    }

    if (model.hasError) {
      return "ERROR: ${model.errorMessage}";
    }
    return "SUCCESS!  token:${model.accessToken}";
  }

}