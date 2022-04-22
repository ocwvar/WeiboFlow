import 'package:flutter/material.dart';
import 'package:weibo_flow/entrance_view_model.dart';

class WelcomePage extends StatefulWidget {
  final EntranceViewModel entranceViewModel;

  const WelcomePage({Key? key, required this.entranceViewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(_getInfo(widget.entranceViewModel.status)),
          ElevatedButton(onPressed: () => _initSDK(), child: const Text("init")),
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