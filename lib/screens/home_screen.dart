import 'package:flutter/material.dart';
import 'package:spotbuy/Utils/constants.dart';

import 'components/body.dart';
import '../Utils/size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    determinePosition();
    return  Scaffold(
      body:  Body(),
    );
  }
}
