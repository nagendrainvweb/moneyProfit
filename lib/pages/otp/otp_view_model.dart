import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app_regex/appRegex.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/api_error_exception.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OtpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();
  final _snackService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  final otpController = TextEditingController();

  bool _isOtpError = false;
  // send otp page variables
  int _timer = 0;
  bool _isLoading = true;
  String _random = "0";
  String _enteredOtp = "";
  String _mobile = "";

  bool get isOtpError => _isOtpError;
  int get timer => _timer;
  bool get isLoading => _isLoading;
  String get mobile => _mobile;
  String get random => _random;
  String get enteredOtp => _enteredOtp;

  void initData(String mobile) {
    this._mobile = mobile;
  }

  otpSubmitPressed() {
    if (otpController.text == _random) {
      _isOtpError = false;
      notifyListeners();
      _navigationService.back(result: true);
    } else {
      _isOtpError = true;
      notifyListeners();
    }
  }

  void setOtp(String value) {}

  sendOtp() async {
    _isLoading = true;
    notifyListeners();
    try {
      _random = (Random().nextInt(900000) + 100000).toString();
      myPrint(_random);
      await Future.delayed(Duration(seconds: 4));
      _isLoading = false;
      _timer = 13;
      notifyListeners();
      setTimer();
      // final response = await _apiService.sendOtp(_mobile, _random);
      // if (response.status == Constants.SUCCESS) {
      //   _isLoading = false;
      //   _timer = 13;
      //   notifyListeners();
      //   setTimer();
      // } else {
      //   _snackService.showSnackbar(
      //       message: response.message,
      //       mainButtonTitle: "RETRY",
      //       onMainButtonTapped: () {
      //         sendOtp();
      //       });
      // }
    } on ApiErrorException catch (e) {
      _isLoading = false;
      notifyListeners();
      final value = await _dialogService.showCustomDialog(
          variant: DialogType.error, title: "Error", description: e.toString());
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      final value = await _dialogService.showCustomDialog(
          variant: DialogType.error, title: "Error", description: e.toString());
    }
  }

  setTimer() {
    if (_timer != 0) {
      Future.delayed(Duration(seconds: 1), () {
        _timer--;
        notifyListeners();
        setTimer();
      });
    }
  }

  void goBack() {
    _navigationService.back(result: false);
  }
}
