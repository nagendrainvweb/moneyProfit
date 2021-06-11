import 'package:flutter/material.dart';
import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_regex/appRegex.dart';
import 'package:moneypros/model/login_data.dart';
import 'package:moneypros/pages/home/home_page.dart';
import 'package:moneypros/pages/subscription/subscription_page.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends BaseViewModel with AppHelper {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();
  final _snackBarServices = locator<SnackbarService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final numberController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _validForm = false;

  UserRepo _userRepo;

  bool get hidePassword => _hidePassword;
  bool get hideConfirmPassword => _hideConfirmPassword;
  bool get validForm => _validForm;
  bool get hideConfrimPassword => _hideConfirmPassword;

  void registerClicked() {}

  onChanged(String value) {
    _validForm = checkform();
    notifyListeners();
  }

  checkform() {
    final validEmail =
        RegExp(AppRegex.email_regex).hasMatch(emailController.text.trim());
    final validPassword =
        RegExp(AppRegex.passwordRegex).hasMatch(passwordController.text.trim());
    final validFirstName =
        RegExp(AppRegex.name_regex).hasMatch(firstNameController.text.trim());
    final validLastName =
        RegExp(AppRegex.name_regex).hasMatch(lastNameController.text.trim());

    final validNumber =
        RegExp(AppRegex.mobile_regex).hasMatch(numberController.text.trim());
    final validConfirmPassword =
        (passwordController.text == confirmPasswordController.text.trim());

    if (!validFirstName) {
      showFormError(msg:"Please Enter valid First Name");
      return false;
    }
    if (!validLastName) {
      showFormError(msg:"Please Enter valid Last Name");
      return false;
    }
    if (!validEmail) {
      showFormError(msg:"Please Enter valid Email Id");
      return false;
    }
    if (!validNumber) {
      showFormError(msg:"Please Enter valid Number");
      return false;
    }
    if (!validPassword) {
      showFormError(msg:"Please Enter valid Password");
      return false;
    }
    if (!validConfirmPassword) {
      showFormError(msg:"Please Enter valid Confirm Password");
      return false;
    }


    return (validEmail &&
        validPassword &&
        validFirstName &&
        validLastName &&
        validNumber &&
        validConfirmPassword);
  }

  void showHidePassword() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }

  void showConfirmHidePassword() {
    _hideConfirmPassword = !_hideConfirmPassword;
    notifyListeners();
  }

  void showFormError({String msg}) {
    _snackBarServices.showSnackbar(message: msg??"Please fill valid details");
  }

  void registerUser(BuildContext context) async {
    // register user by calling api
    showProgressDialogService("Please wait...");
    try {
      final resposne = await _apiService.registerUser(
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          numberController.text,
          passwordController.text);
      hideProgressDialogService();
      if (resposne.status == Constants.SUCCESS) {
        _setData(resposne.data, context);
      } else {
        _snackBarServices.showSnackbar(message: resposne.message);
      }
    } catch (e) {
      hideProgressDialogService();
      _snackBarServices.showSnackbar(message: e.toString());
    }
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
    _userRepo.setSubscrptionData(data.subscription);
    _userRepo.setTransactionData(data.transaction);
    Prefs.setLogin(true);
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
    myPrint("data inserted value $value");
    if (value != -1) {
      myPrint("data inserted sucessfully");
    }
    await repo.init();
    _navigationService.clearTillFirstAndShowView(SubscriptionPage());
  }

  Future<bool> verifyUser() async {
    showProgressDialogService("Please wait...");
    try {
      final mobile = numberController.text;
      final email = emailController.text;

      final response =
          await _apiService.validateRegistrationForm(email, mobile);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        return true;
      } else {
        _snackBarServices.showSnackbar(message: response.message);
        return false;
      }
    } catch (e) {
      myPrint(e.toString());
      hideProgressDialogService();
      _snackBarServices.showSnackbar(message: SOMETHING_WRONG_TEXT);
      return false;
    }
  }

  void initData(UserRepo userRepo) {
    _userRepo = userRepo;
  }
}
