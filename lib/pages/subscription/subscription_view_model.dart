import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/model/subscription_data.dart';
import 'package:moneypros/pages/basic_profile/basic_info_page.dart';
import 'package:moneypros/pages/home/home_page.dart';
import 'package:moneypros/pages/payment/payment_page.dart';
import 'package:moneypros/pages/profile_details/profile_details.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/dialog_helper.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SubscriptionViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  UserRepo _userRepo;

  int _selectedPackage = 0;
  bool _checkBoxValue = false;
  bool _loading = true;
  bool _hasError = false;
  List<SubscriptionData> _subscriptionPlans;

  int get selectedPackage => _selectedPackage;
  bool get checkBoxValue => _checkBoxValue;
  UserRepo get userRepo => _userRepo;
  bool get loading => _loading;
  bool get hasError => _hasError;
  List<SubscriptionData> get subscriptionPlans => _subscriptionPlans;

  void payClicked() {
    _navigationService.navigateToView(BasicInfoPage());
  }

  selectPackage(int i) {
    _selectedPackage = i;
    notifyListeners();
  }

  onCheckBoxChanged(bool value) {
    _checkBoxValue = value;
    notifyListeners();
  }

  void onPayClicked({Function onPaymentDone}) async {
    final subscription = _subscriptionPlans[_selectedPackage];
    final firstName = await Prefs.firstName;
    final lastName = await Prefs.lastName;
    final email = await Prefs.emailId;
    final number = await Prefs.mobileNumber;

    _initiatePayment(email, number, subscription.price,
        firstName + " " + lastName, onPaymentDone);
  }

  _initiatePayment(String email, String number, String amount, String name,
      Function onPaymentDone) async {
    showProgressDialogService("Please wait...");
    try {
      final resposne = await _apiService.initiatePayment(email, number, amount);
      hideProgressDialogService();
      if (resposne.status == Constants.SUCCESS) {
        final data = await _navigationService.navigateToView(PaymentPage(
          paymentUrl: resposne.data.paygPaymentUrl,
          elements: resposne.data.returnElements,
        ));
        if (data != null) {
          myPrint(data);
          final payResponse = jsonDecode(data);
          final payData = payResponse["data"];
          final payReturn = payData["return_elements"];
          final payTxtResponse = payReturn["txn_response"];
          final payStatus = payTxtResponse["status"];
          final payMessage = payTxtResponse["res_message"];
          onPaymentDone(payStatus, payMessage);
        } else {
          final value = await _dialogService.showCustomDialog(
            variant: DialogType.error,
            title: "Error",
            description: resposne.message,
            barrierDismissible: false,
          );
        }
      }
    } catch (e) {
      hideProgressDialogService();
      final value = await _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: "Error",
        description: e.toString(),
        barrierDismissible: false,
      );
    }
  }

  void backClicked() {
    _navigationService.clearTillFirstAndShowView(HomePage());
  }

  void init(UserRepo userRepo) {
    _userRepo = userRepo;
  }

  void fetchSubscriptionPlan() async {
    _loading = true;
    _hasError = false;
    notifyListeners();
    try {
      final resposne = await _apiService.subscriptionList();
      _loading = false;
      if (resposne.status == Constants.SUCCESS) {
        _subscriptionPlans = resposne.data;
        notifyListeners();
      } else {
        _hasError = true;
        notifyListeners();
        final value = await _dialogService.showCustomDialog(
          variant: DialogType.error,
          title: "Error",
          description: resposne.message,
          barrierDismissible: false,
        );
        _navigationService.back();
      }
    } catch (e) {
      _loading = false;
      _hasError = true;
      notifyListeners();
      final value = await _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: "Error",
        description: e.toString(),
        barrierDismissible: false,
      );
      _navigationService.back();
      // _snackBarService.showSnackbar(message: e.toString());
    }
  }

  void updateUserTable(BuildContext context) async {
    showProgressDialogService("Please wait...");
    try {
      final response = await _apiService.userDetails();
      final data = response.data;
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
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
          Utility.pushToDashboard(1);
        }
      } else {
        DialogHelper.showErrorDialog(context, "Error", response.message,
            onOkClicked: () {
          _navigationService.back();
          updateUserTable(context);
        });
      }
    } catch (e) {
      hideProgressDialogService();
      DialogHelper.showErrorDialog(context, "Error", e.toString(),
          onOkClicked: () {
        _navigationService.back();
        updateUserTable(context);
      });
    }
  }
}
