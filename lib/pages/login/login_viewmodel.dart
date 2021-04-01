import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_regex/appRegex.dart';
import 'package:moneypros/model/login_data.dart';
import 'package:moneypros/pages/basic_profile/basic_info_page.dart';
import 'package:moneypros/pages/home/home_page.dart';
import 'package:moneypros/pages/register/register_page.dart';
import 'package:moneypros/pages/subscription/subscription_page.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/api_error_exception.dart';
import 'package:moneypros/utils/dialog_helper.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel with AppHelper {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();
  final _snackBarService = locator<SnackbarService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserRepo _userRepo;

  bool _hidePassword = true;
  bool _validForm = false;

  bool get hidePassword => _hidePassword;
  bool get validForm => _validForm;

  void loginClicked(BuildContext context) async {
    showProgressDialogService("Please wait...");
    try {
      final resposne = await _apiService.fetchLogin(
          emailController.text, passwordController.text);
      hideProgressDialogService();
      if (resposne.status == Constants.SUCCESS) {
        _setData(resposne.data, context);
      } else {
        _snackBarService.showSnackbar(message: resposne.message);
      }
    } catch (e) {
      myPrint(e.toString());
      hideProgressDialogService();
      _snackBarService.showSnackbar(message: e.toString());
    }
    //_navigationService.navigateToView(HomePage());
  }

  void showHidePassword() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }

  setEmail(String value) {
    _validForm = checkform();
    notifyListeners();
  }

  setPassword(String value) {
    _validForm = checkform();
    notifyListeners();
  }

  checkform() {
    final validMobile =
        RegExp(AppRegex.mobile_regex).hasMatch(emailController.text);
    final validEmail =
        RegExp(AppRegex.email_regex).hasMatch(emailController.text);

    final validPassword =
        RegExp(AppRegex.passwordRegex).hasMatch(passwordController.text);
    return ((validEmail || validMobile) && validPassword);
  }

  void signupClicked() {
    _navigationService.navigateToView(RegisterPage());
    //_navigationService.navigateToView(SubscriptionPage());
  }

  void skipClicked() async {
    await Prefs.setLoginSkip(true);
    _navigationService.navigateToView(HomePage());
  }

  void _setData(LoginData data, BuildContext context) async {
    Prefs.setUserId(data.userdetails.id);
    Prefs.setFirstName(data.userdetails.firstName);
    Prefs.setMiddleName(data.userdetails.middleName);
    Prefs.setLastName(data.userdetails.lastName);
    Prefs.setMobileNumber(data.userdetails.mobile);
    Prefs.setEmailId(data.userdetails.email);
    Prefs.setToken(data.accesstoken);

    Prefs.setProfilePic(data.userdetails.profileImage);
    Prefs.setLogin(true);

    _userRepo.setSubscrptionData(data.subscription);
    _userRepo.setTransactionData(data.transaction);

    if (data.subscription != null) {
      Prefs.setSubscriptionDate(data.subscription.subscriptionDate);
      Prefs.setSubscriptionExpiryDate(data.subscription.expiryDate);
      final exprydate = data.subscription.expiryDate;
      final expiryDatetime = Utility.parseServerDate(exprydate);
      if (expiryDatetime.isAfter(DateTime.now())) {
        Prefs.setSubscription(true);
      } else {
        Prefs.setSubscription(false);
      }
    }
    final repo = Provider.of<UserRepo>(context, listen: false);
    repo.setUserData(data.userdetails);

    int value = await repo.setUserDataIntoTable(data.userdetails.toJson());
    if (value != -1) {
      myPrint("data inserted sucessfully");
    }
    await repo.init();
    _navigationService.clearTillFirstAndShowView(HomePage(
      position: (repo.subscribe) ? 1 : 0,
    ));
  }

  Future<LoginData> validateNumberOnServer(String number) async {
    try {
      showProgressDialogService("Please wait...");
      final response = await _apiService.verifyUser(number);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      myPrint("Error is " + e.toString());
      hideProgressDialogService();
      _snackBarService.showSnackbar(message: e.toString());
      return null;
    }
  }

  void showSnackBar(String text) {
    _snackBarService.showSnackbar(message: text);
  }

  void resetPassword(Userdetails data, String password) async {
    try {
      showProgressDialogService("Please wait...");
      final response = await _apiService.restPassowrd(data.id, password);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        _snackBarService.showSnackbar(message: response.message);
      } else {
        _snackBarService.showSnackbar(message: response.message);
      }
    } catch (e) {
      myPrint("Error is " + e.toString());
      hideProgressDialogService();
      _snackBarService.showSnackbar(message: e.toString());
    }
  }

  void checkUpdate(BuildContext context) async {
    try {
      final response = await _apiService.checkUpdate();
      if (response.isUpdate == "1") {
        DialogHelper.showUpdateDialog(context, response);
      }
    } on ApiErrorException catch (e) {} on Exception catch (e) {}
  }

  void notificationToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final token = await messaging.getToken();
    myPrint("token is $token");
    await Prefs.setFcmToken(token);

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void initData(UserRepo userRepo) {
    _userRepo = userRepo;
  }
}
