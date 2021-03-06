import 'package:flutter/widgets.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app_regex/appRegex.dart';
import 'package:moneypros/pages/home/home_page.dart';
import 'package:moneypros/pages/register/register_page.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _hidePassword = true;
  bool _validForm = false;

  bool get hidePassword => _hidePassword;
  bool get validForm => _validForm;

  void loginClicked() {
    _navigationService.navigateToView(HomePage());
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
    final validEmail =
        RegExp(AppRegex.email_regex).hasMatch(emailController.text);
    final validPassword =
        RegExp(AppRegex.passwordRegex).hasMatch(passwordController.text);

    return (validEmail && validPassword);
  }

  void signupClicked() {
    _navigationService.navigateToView(RegisterPage());
  }

  void skipClicked() {
    _navigationService.navigateToView(HomePage());
  }
}
