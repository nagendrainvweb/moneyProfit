import 'package:moneypros/prefrence_util/PreferencesHelper.dart';
import 'package:moneypros/utils/constants.dart';

class Prefs {
  static Future setLogin(bool value) =>
      PreferencesHelper.setBool(Constants.IS_LOGIN, value);

  static Future<bool> login() => PreferencesHelper.getBool(Constants.IS_LOGIN);

  static void clear() {}
}
