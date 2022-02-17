import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sbcb_driver_flutter/core/services/auth_service.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';

import 'core/notifiers/app_providers.dart';
import 'core/services/global_config.dart';

void main() {
  runApp(SBCBDriverApp());
}

class SBCBDriverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getproviders(),
      child: MaterialApp(
        navigatorKey: navigatorKey, // Setting a global key for navigator

        title: Constants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.indigo[900],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthService(),
      ),
    );
  }
}
