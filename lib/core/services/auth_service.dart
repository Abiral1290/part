import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/auth_state.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/location_state.dart';
import 'package:sbcb_driver_flutter/view/credentials/login.dart';
import 'package:sbcb_driver_flutter/view/home/home.dart';

class AuthService extends StatelessWidget {
  const AuthService({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, state, child) {
        print("in checkauth");

        ///  print(state.credentials.token);
        return !state.isAuthenticated
            ? LoginPage()
            : Consumer<LocationState>(
                builder: (context, locationState, child) {
                  return HomePage(
                    locationState: locationState,
                  );
                },
              );
      },
    );
  }
}
