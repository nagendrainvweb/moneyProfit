import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app_regex/appRegex.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();

  final numberController = TextEditingController();
  bool _numberError = false;

  bool get numberError => _numberError;

  void goBack() {
    _navigationService.back();
  }

  void sendOTPClicked() {}

  onNumberChanged(String text) {
    _numberError = !RegExp(AppRegex.mobile_regex).hasMatch(text);
    notifyListeners();
  }
}
