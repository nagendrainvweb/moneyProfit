import 'package:flutter/material.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app_regex/appRegex.dart';
import 'package:moneypros/pages/subscription/subscription_page.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends BaseViewModel {
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
        RegExp(AppRegex.email_regex).hasMatch(emailController.text);
    final validPassword =
        RegExp(AppRegex.passwordRegex).hasMatch(passwordController.text);
    final validFirstName =
        RegExp(AppRegex.name_regex).hasMatch(firstNameController.text);
    final validLastName =
        RegExp(AppRegex.name_regex).hasMatch(lastNameController.text);

    final validNumber =
        RegExp(AppRegex.mobile_regex).hasMatch(numberController.text);
    final validConfirmPassword =
        (passwordController.text == confirmPasswordController.text);

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

  void showFormError() {
    _snackBarServices.showSnackbar(message: "Please fill valid details");
  }

  void registerUser() async {
    // register user by calling api
    _navigationService.navigateToView(SubscriptionPage());
  }
}
