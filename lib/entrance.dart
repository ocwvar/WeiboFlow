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
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => EntranceViewModel(),
        child: Consumer<EntranceViewModel>(
          builder: (context, viewModel, child) {
            return WelcomePage(entranceViewModel: viewModel);
          },
        ),
      )
    );
  }
}