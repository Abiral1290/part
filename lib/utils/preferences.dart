import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static const _authData = 'authdata';
  // static const _lang = 'lang';
  static const _regNumber = 'reg_number';
  static const _todayEarning = 'earning_today';

  static final _today = DateTime.now().toString().split(' ').first;

  static storeUser(String data) async {
    try {
      var pref = await SharedPreferences.getInstance();
      pref.setString(_authData, data);
    } catch (e) {
      print("failed to store user");
      print(e);
    }
  }

  static Future<String> getUser() async {
    try {
      var pref = await SharedPreferences.getInstance();
      return pref.getString(_authData);
    } catch (e) {
      print("failed to get user");
      print(e);
      return null;
    }
  }

  static getRegisteredNumber() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getString(_regNumber);
  }

  static saveRegisteredNumber(String number) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setString(_regNumber, number);
  }

  static Future<int> getTodaysEarning() async {
    var pref = await SharedPreferences.getInstance();
    var val = pref.getString(_todayEarning);
    if (val == null) return 0;
    var arr = val.split(',');
    if (arr.first == _today) {
      return int.parse(arr.last);
    }
    return 0;
  }

  static saveTodaysEarning(int amt) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setString(_todayEarning, "$_today,$amt");
  }

  // static saveAppLanguage(Lang lang) async {
  //   var pref = await SharedPreferences.getInstance();
  //   return pref.setString(_lang, lang.toString());
  // }

  // static Future<Lang> getAppLanguage() async {
  //   var pref = await SharedPreferences.getInstance();
  //   var res = pref.getString(_lang);
  //   if (res == null) return null;
  //   return res == Lang.ENG.toString() ? Lang.ENG : Lang.NP;
  // }

  static clear() async {
    var pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
