import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/model/emi_data.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'dart:math' as math;

import 'package:stacked_services/stacked_services.dart';

class CalculatorViewModel extends BaseViewModel {
  final loanController = TextEditingController();
  final incomeController = TextEditingController();
  final loanCommitController = TextEditingController();
  final loanTenureController = TextEditingController();
  final rateonInterestController = TextEditingController(text: "");

  final emiLoanAmountController = TextEditingController(text: "");
  final emiNoOfMonthController = TextEditingController(text: "");
  final emiROIControlller = MaskedTextController(text: "", mask: "00.00");

  /** SIP textController */

  final spiMonthlyInstallment = TextEditingController(text: "");
  final spiPeriod = TextEditingController(text: "");
  final spiReturn = TextEditingController(text: "");

  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _eligibleOpen = false;
  bool _emiOpen = false;
  bool _sipOpen = false;

  bool get eligibleOpen => _eligibleOpen;
  bool get emiOpen => _emiOpen;
  bool get sipOpen => _sipOpen;

  double sipExpectedAmount, sipInvestedAmount, sipProfit;

  

  List<EMIData> _emiList = [];

  double _loanValue = 0.0;
  double _loanMinValue = 100000.0;
  double _loanMaxValue = 5000000.0;
  double _loanInterval = 1000000.0;

  double _monthValue = 0.0;
  double _monthMinValue = 10.0;
  double _monthMaxValue = 360.0;
  double _monthInterval = 30.0;

  double _rateValue = 0.0;
  double _rateMinValue = 8.0;
  double _rateMaxValue = 16.0;
  double _rateInterval = 1.0;

  String _calEmi, _calTotalIntrest, _calPayableAmount, _calInterest;

  double get loanValue => _loanValue;
  double get loanMinValue => _loanMinValue;
  double get loanMaxValue => _loanMaxValue;
  double get loanInterval => _loanInterval;

  double get monthValue => _monthValue;
  double get monthMinValue => _monthMinValue;
  double get monthMaxValue => _monthMaxValue;
  double get monthInterval => _monthInterval;

  double get rateValue => _rateValue;
  double get rateMinValue => _rateMinValue;
  double get rateMaxValue => _rateMaxValue;
  double get rateInterval => _rateInterval;

  String get calEmi => _calEmi;
  String get calTotalIntrest => _calTotalIntrest;
  String get calPayableAmount => _calPayableAmount;
  String get calInterest => _calInterest;

  List<EMIData> get emiList => _emiList;

  void resetAllClicked() {
    loanController.text = "";
    incomeController.text = "";
    loanCommitController.text = "";
    loanTenureController.text = "";
    rateonInterestController.text = "9.5";
    notifyListeners();
  }

  void checkEligibility({Function onResult}) {
    if (loanController.text.isNotEmpty &&
        incomeController.text.isNotEmpty &&
        loanCommitController.text.isNotEmpty &&
        loanTenureController.text.isNotEmpty &&
        rateonInterestController.text.isNotEmpty) {
      final loan = int.parse(loanController.text);
      final income = int.parse(incomeController.text);
      final loanCommit = int.parse(loanCommitController.text);
      final year = int.parse(loanTenureController.text);
      final rateText = double.parse(rateonInterestController.text);

      String text1, text2, text3;
      bool suceess;

      final rate = rateText / (12 * 100);
      final double compundIntetrest =
          (loan * rate * math.pow((1 + rate), year * 12)) /
              (math.pow((1 + rate), year * 12) - 1);
      // to calculate compound interest..
      final emi1 =
          ((compundIntetrest * 100) / 100).ceil(); // to parse emi amount..
      final existingLoan = (loanCommit - (loanCommit * 60 / 100));
      double incomere;
      if (income <= 14999) {
        incomere = ((income) * 40 / 100) - existingLoan;
      } else if (income <= 29999) {
        incomere = ((income) * 45 / 100) - existingLoan;
      } else if (income >= 30000) {
        incomere = ((income) * 50 / 100) - existingLoan;
      }

      final incomereq = (incomere / emi1 * loan).ceil();
      final double compundIntetrest2 =
          (incomereq * rate * math.pow((1 + rate), year * 12)) /
              (math.pow((1 + rate), year * 12) -
                  1); // to calculate compound interest2..
      var emi2 = ((compundIntetrest2) * 100).ceil() /
          100; // to parse emi2 amount..   //Check again Reminder

      if (incomereq > loan) {
        myPrint("You are Eligible for this loan");
        myPrint(("₹ " + "$loan" + " at EMI " + "₹ " + emi1.toStringAsFixed(0)));
        myPrint("You are Eligible for a maximum loan of " +
            ("₹ " +
                '$incomereq' +
                " at EMI " +
                "₹ " +
                emi2.toStringAsFixed(0)));

        text1 = "You are Eligible for this loan";
        text2 = "₹ " + "$loan" + " at EMI " + "₹ " + emi1.toStringAsFixed(0);
        text3 = "You are Eligible for a maximum loan of " +
            ("₹ " + '$incomereq' + " at EMI " + "₹ " + emi2.toStringAsFixed(0));
        suceess = true;
      } else {
        myPrint("You are not Eligible for this loan");
        myPrint("");
        myPrint("You are Eligible for a maximum loan of " +
            ("₹ " +
                "$incomereq" +
                " at EMI " +
                "₹ " +
                emi2.toStringAsFixed(0)));
        text1 = "You are not Eligible for this loan";
        text2 = "";
        text3 = "You are Eligible for a maximum loan of " +
            ("₹ " + "$incomereq" + " at EMI " + "₹ " + emi2.toStringAsFixed(0));
        suceess = false;
      }

      onResult(text1, text2, text3, suceess);
    } else {
      _snackBarService.showSnackbar(message: "Please enter valid amount");
    }
  }

  void calculateSIP() {
    final investmentAmount = (spiMonthlyInstallment.text.isNotEmpty)?double.parse(spiMonthlyInstallment.text):0.0;
    final numberOfYears =(spiPeriod.text.isNotEmpty)? double.parse(spiPeriod.text):0.0;
    final annaulReturn =(spiReturn.text.isNotEmpty)? double.parse(spiReturn.text):0.0;
    final monthlyInterestRatio = annaulReturn / 12 / 100;
    final months = numberOfYears * 12;

    sipExpectedAmount = investmentAmount *
        (math.pow(1 + monthlyInterestRatio, months) - 1) /
        monthlyInterestRatio;
    sipInvestedAmount = months * investmentAmount;
    sipProfit = sipExpectedAmount - sipInvestedAmount;
    notifyListeners();
  }

  void showSnackbar(String s) {
    _snackBarService.showSnackbar(message: s);
  }

  loanSliderChanged(String value) {
    _loanValue = double.parse(value);
    calculateEMI();
    // notifyListeners();
  }

  monthSliderChanged(String value) {
    _monthValue = double.parse(value);
    calculateEMI();
    //notifyListeners();
  }

  rateSliderChanged(String value) {
    _rateValue = double.parse(value);
    calculateEMI();
    // notifyListeners();
  }

  calculateEMI() {
    _emiList.clear();
    final monthlyInterestRatio = (_rateValue / 100) / 12;
    var top = math.pow((1 + monthlyInterestRatio), _monthValue);
    var bottom = top - 1;
    var sp = top / bottom;
    var emi = ((_loanValue * monthlyInterestRatio) * sp);
    var full = _monthValue * emi;
    var interest = full - _loanValue;
    var int_pge = (interest / full) * 100;

    var emi_str = emi
        .toStringAsFixed(2)
        .toString()
        .replaceAll("/,/g", "")
        .replaceAll("/\B(?=(\d{3})+(?!\d))/g", ",");
    var loanAmount_str = _loanValue
        .toString()
        .replaceAll("/,/g", "")
        .replaceAll("/\B(?=(\d{3})+(?!\d))/g", ",");
    var full_str = full
        .toStringAsFixed(2)
        .toString()
        .replaceAll("/,/g", "")
        .replaceAll("/\B(?=(\d{3})+(?!\d))/g", ",");
    var int_str = interest
        .toStringAsFixed(2)
        .toString()
        .replaceAll("/,/g", "")
        .replaceAll("/\B(?=(\d{3})+(?!\d))/g", ",");

    _calEmi = emi_str;
    _calTotalIntrest = int_str;
    _calPayableAmount = full_str;
    _calInterest = int_pge.toStringAsFixed(2) + " %";

    var bb = _loanValue.toInt();
    var int_dd = 0;
    var pre_dd = 0.0;
    var end_dd = 0.0;

    for (var j = 1; j <= _monthValue.toInt(); j++) {
      int_dd = bb * (_rateValue / 100) ~/ 12;
      pre_dd = (emi - int_dd);
      end_dd = bb - pre_dd;
      _emiList.add(EMIData(
          beggingBalance: bb.toStringAsFixed(2),
          emi: emi.toStringAsFixed(2),
          principal: pre_dd.toStringAsFixed(2),
          interest: int_dd.toStringAsFixed(2),
          endingBalance: end_dd.toStringAsFixed(2)));
      // myPrint(
      //     "${bb.toStringAsFixed(2)} && ${emi.toStringAsFixed(2)} && ${pre_dd.toStringAsFixed(2)} && ${int_dd.toStringAsFixed(2)} && ${end_dd.toStringAsFixed(2)}");

      bb = bb - pre_dd.toInt();
    }

    notifyListeners();

    // myPrint("$emi_str  $loanAmount_str  $full_str  $int_str");
  }

  void setEligibilityOpen(bool value) {
    _eligibleOpen = value;
    notifyListeners();
  }

  void setEmiOpen(bool value) {
    _emiOpen = value;
    notifyListeners();
  }

  void setSipOpen(bool value) {
    _sipOpen = value;
    notifyListeners();
  }
}
