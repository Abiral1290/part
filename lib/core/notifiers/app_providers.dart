import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/auth_state.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/location_state.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/map_state.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/transaction_state.dart';

List<SingleChildWidget> getproviders() {
  return [
    ChangeNotifierProvider(
      lazy: false,
      create: (context) => AuthState(),
    ),
    ChangeNotifierProvider(
      lazy: false,
      create: (context) => LocationState(),
    ),
    ChangeNotifierProvider(
      lazy: false,
      create: (context) => MapState(),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => TransactionState(),
    )
  ];
}
