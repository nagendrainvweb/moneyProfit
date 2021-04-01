import 'package:moneypros/prefrence_util/PreferencesHelper.dart';
import 'package:moneypros/utils/Constants.dart';

class Prefs {
  static Future setLogin(bool value) =>
      PreferencesHelper.setBool(Constants.IS_LOGIN, value);

  static Future<bool> get login =>
      PreferencesHelper.getBool(Constants.IS_LOGIN);

  static Future setSubscription(bool value) =>
      PreferencesHelper.setBool(Constants.SUBSCRIPTION, value);

  static Future<bool> get subscription =>
      PreferencesHelper.getBool(Constants.SUBSCRIPTION);

  static Future setLoginSkip(bool value) =>
      PreferencesHelper.setBool(Constants.SKIP_LOGIN, value);

  static Future<bool> get loginSkip =>
      PreferencesHelper.getBool(Constants.SKIP_LOGIN);

  static Future setIntroDone(bool value) =>
      PreferencesHelper.setBool(Constants.INTRO_DONE, value);

  static Future<bool> get introDone =>
      PreferencesHelper.getBool(Constants.INTRO_DONE);

  static Future setFirstName(String value) =>
      PreferencesHelper.setString(Constants.NAME, value);

  static Future<String> get firstName =>
      PreferencesHelper.getString(Constants.NAME);

  static Future setMiddleName(String value) =>
      PreferencesHelper.setString(Constants.MIDDLE_NAME, value);

  static Future<String> get middleName =>
      PreferencesHelper.getString(Constants.MIDDLE_NAME);

  static Future setUserId(String value) =>
      PreferencesHelper.setString(Constants.USERID, value);

  static Future<String> get userId =>
      PreferencesHelper.getString(Constants.USERID);

  static Future setMobileNumber(String value) =>
      PreferencesHelper.setString(Constants.MOBILE_NO, value);

  static Future<String> get mobileNumber =>
      PreferencesHelper.getString(Constants.MOBILE_NO);

  static Future setEmailId(String value) =>
      PreferencesHelper.setString(Constants.EMAIl, value);

  static Future<String> get emailId =>
      PreferencesHelper.getString(Constants.EMAIl);

  static Future setLastName(String value) =>
      PreferencesHelper.setString(Constants.LAST_NAME, value);

  static Future<String> get lastName =>
      PreferencesHelper.getString(Constants.LAST_NAME);

  static Future setToken(String value) =>
      PreferencesHelper.setString(Constants.TOKEN, value);

  static Future<String> get token =>
      PreferencesHelper.getString(Constants.TOKEN);

  static Future setFcmToken(String value) =>
      PreferencesHelper.setString(Constants.FCM_TOKEN, value);

  static Future<String> get fcmToken =>
      PreferencesHelper.getString(Constants.FCM_TOKEN);

  static Future setStateList(String value) =>
      PreferencesHelper.setString(Constants.STATE_LIST, value);

  static Future<String> get stateList =>
      PreferencesHelper.getString(Constants.STATE_LIST);

  static Future setCityList(String value) =>
      PreferencesHelper.setString(Constants.CITY_LIST, value);

  static Future<String> get cityList =>
      PreferencesHelper.getString(Constants.CITY_LIST);

  static Future setProfilePic(String value) =>
      PreferencesHelper.setString(Constants.PROFILE_PIC, value);

  static Future<String> get profilePic =>
      PreferencesHelper.getString(Constants.PROFILE_PIC);

  static Future setSubscriptionDate(String value) =>
      PreferencesHelper.setString(Constants.PROFILE_PIC, value);

  static Future<String> get subscriptionDate =>
      PreferencesHelper.getString(Constants.PROFILE_PIC);

  static Future setSubscriptionExpiryDate(String value) =>
      PreferencesHelper.setString(Constants.PROFILE_PIC, value);

  static Future<String> get subscriptionExpiryDate =>
      PreferencesHelper.getString(Constants.PROFILE_PIC);

  static Future setCrifData(String value) =>
      PreferencesHelper.setString(Constants.CRIF_DATA, value);

  static Future<String> get crifData =>
      PreferencesHelper.getString(Constants.CRIF_DATA);

  static Future clear() async {
    Prefs.setLogin(false);
    Prefs.setLoginSkip(false);
    Prefs.setSubscription(false);
    Prefs.setFirstName("");
    Prefs.setMiddleName("");
    Prefs.setLastName("");
    Prefs.setMobileNumber("");
    Prefs.setEmailId("");
    Prefs.setToken("");
    Prefs.setFcmToken("");
    Prefs.setCrifData("");
    Prefs.setSubscriptionDate("");
    Prefs.setSubscriptionExpiryDate("");
  }
}
