import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefkeys {
  static const String USER = 'USER';
  static const String USERTOKEN = 'TOKEN';
  static const String FCMTOKEN = 'FCMTOKEN';
  static const String USERTHEME = 'THEME';
  static const String LANG = 'LANG';

  static const String ISUSERLOGEDIN = 'ISUSERLOGEDIN';
  static const String ISTHEMEDARK = 'ISTHEMEDARK';
}

class SharedPrefManager {
  static Future<bool?> isUserLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(SharedPrefkeys.ISUSERLOGEDIN);
  }

  static Future<bool?> setUserLogin(bool? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPrefkeys.ISUSERLOGEDIN, data!);
  }

  static Future<dynamic> setToken(token) async {
    String data = token.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("tokens", data);
  }

  static Future<dynamic> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("tokens");
  }

  static Future<dynamic> setFCMToken(token) async {
    String data = token.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("fcmtokens", data);
  }

  static Future<dynamic> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("fcmtokens");
  }

  static Future<dynamic> setphone(token) async {
    String data = token.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("phone", data);
  }

  static Future<dynamic> getphone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone");
  }

  static Future<dynamic> setusername(token) async {
    String data = token.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("name", data);
  }

  static Future<dynamic> getusername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("name");
  }
}
