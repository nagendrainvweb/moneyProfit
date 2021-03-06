import 'package:flutter/material.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app_regex/appRegex.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ResetPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();

  final passwordController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _formError = false;

  bool get hidePassword => _hidePassword;
  bool get hideConfirmPassword => _hideConfirmPassword;
  bool get formError => _formError;

  void goBack() {
    _navigationService.back();
  }

  void showHidePassword() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }

  void showConfirmHidePassword() {
    _hideConfirmPassword = !_hideConfirmPassword;
    notifyListeners();
  }

  void submitClicked() {
    final validPassword =
        RegExp(AppRegex.passwordRegex).hasMatch(passwordController.text);
    final validConfirmPassword =
        (passwordController.text == confirmPasswordTextController.text);

    if (validPassword && validConfirmPassword) {
      // call api for change password
      _formError = false;
      notifyListeners();
      goBack();
    } else {
      _formError = true;
      notifyListeners();
    }
  }
}
