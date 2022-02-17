import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sbcb_driver_flutter/core/model/driver.dart';
import 'package:sbcb_driver_flutter/utils/api_urls.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';
import 'package:sbcb_driver_flutter/utils/preferences.dart';
import 'package:sbcb_driver_flutter/utils/utilities.dart';
import 'package:sbcb_driver_flutter/core/services/global_config.dart'
    as globals;

class AuthState extends ChangeNotifier {
  Driver _driver;
  bool _isLoggedIn;

  Driver get driver => _driver;
  bool get isAuthenticated => _isLoggedIn;

  AuthState() {
    _init();
  }

  _init() {
    _checkAuth();
  }

  _checkAuth() async {
    _isLoggedIn = false;
    var data = await Preference.getUser();
    if (data != null) {
      _driver = Driver.fromJson(json.decode(data));
      _isLoggedIn = true;
      print(_driver.phone);
      Constants.token = _driver.apiToken;
      globals.clientId = _driver.id;
    }

    notifyListeners();
  }

  /// The [mobileID] is the Android or iOS version
  Future<dynamic> signIn(String phoneNum) async {
    var body = {
      "phone": phoneNum,
    };

    final respose = await http.post(Uri.parse(ApiURLs.loginUrl), body: body);
    if (Utilities.handleStatus(respose.statusCode)) {
      var obj = json.decode(respose.body);
      if (!obj['error']) {
        _isLoggedIn = true;

        _driver = Driver.fromJson(obj['data']);
        Preference.storeUser(json.encode(obj['data']));
        Constants.token = _driver.apiToken;
        // print(_credentials.token);
        // updateUser(_credentials.user);
      } else {
        print(obj);
        return obj['message'];
      }
    } else {
      print(respose);
      return 'Unknown error';
    }
    notifyListeners();
    return _driver;
  }

  Future signOut() async {
    Preference.clear();
    _isLoggedIn = false;
    _driver = null;
    notifyListeners();
  }
}
