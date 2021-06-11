import 'dart:convert';

import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/model/crif_data.dart';
import 'package:moneypros/pages/login/login_page.dart';
import 'package:moneypros/pages/question_page/question_page.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreditScoreViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  int _score = 810;
  int _animatedScore = 0;
  int _daysLeft = 0;
  int _currentTab = 2;
  int _questionCount = 0;
  String _historyDate = "";

  int get score => _score;
  int get animatedScore => _animatedScore;
  int get daysLeft => _daysLeft;
  int get currentTab => _currentTab;

  UserRepo _userRepo;
  CrifData _crifData;
  bool _login = false;
  bool _subscribe = false;
  bool _basicDone = false;
  bool _addressDone = false;
  bool _identitiyDone = false;
  String _asOnDate = "";

  bool hasError = false;

  UserRepo get userRepo => _userRepo;
  bool get login => false;
  bool get subscribe => false;
  bool get addressDone => _addressDone;
  bool get identitiyDone => _identitiyDone;
  bool get basicDone => _basicDone;
  CrifData get crifData => _crifData;
  String get asonDate => _asOnDate;

  void initData(UserRepo userRepo, String date) async {
    setBusy(true);
    _userRepo = userRepo;
    _login = await Prefs.login;
    _subscribe = await Prefs.subscription;
    _basicDone = userRepo.basicDetailsAreDone();
    _identitiyDone = userRepo.identityDetailsAreDone();
    _addressDone = userRepo.addressDetailsAreDone();
    _historyDate = date;

    if (_historyDate.isEmpty) {
      fetchCrifData();
    } else {
      fetchCrifHistory();
    }
  }

  void fetchCrifHistory() async {
    hasError = false;
    setBusy(true);
    try {
      final resposne = await _apiService.crifHistoryData(_historyDate);
      setBusy(false);
      if (resposne.status == Constants.SUCCESS) {
        _setCrifData(resposne.data);
      } else {
        hasError = true;
        notifyListeners();
      }
    } catch (e) {
      hasError = true;
      setBusy(false);
      notifyListeners();
    }
  }

  onTabClicked(int value) {
    _currentTab = value;
    notifyListeners();
  }

  fetchCrifData() async {
    final value = await Prefs.crifData;

    try {
      if (value.isEmpty) {
        fetchCrifDataFromServer();
      } else {
        final json = jsonDecode(value);
        setBusy(false);
        CrifData crifData = CrifData.fromJson(json);
        _setCrifData(crifData);
      }
    } catch (e) {
      hasError = true;
      setBusy(false);
      //hideProgressDialogService();
      _snackBarService.showSnackbar(message: e.toString());
    }
  }

  fetchCrifDataFromServer() async {
    _questionCount = 0;
    try {
      setBusy(true);
      showProgressDialogService("Fetching Crif Data...");
      final response = await _apiService.crifData();
      //hideProgressDialogService();

      if (response.status == Constants.SUCCESS) {
        if (response.from == "crif") {
          // call stage two
          if (response.data.status == "S06") {
            hideProgressDialogService();
            fetchCrifStageTwoData(response.data.reportId, response.data.orderId,
                response.data.redirectURL, null);
          } else {
            setBusy(false);
            hideProgressDialogService();
            hasError = false;
            notifyListeners();
          }
        } else {
          setBusy(false);
          hideProgressDialogService();
          _setCrifData(response.data);
          hasError = false;
          notifyListeners();
        }
      } else {
        setBusy(false);
        hideProgressDialogService();
        notifyListeners();
        _snackBarService.showSnackbar(message: response.message);
      }
    } catch (e) {
      hasError = true;
      setBusy(false);
      hideProgressDialogService();
      e.toString(e.toString());
      //hideProgressDialogService();
      _snackBarService.showSnackbar(message: e.toString());
    }
  }

  fetchCrifStageTwoData(String reportId, String orderId, String redirectUrl,
      String answer) async {
    try {
      setBusy(true);
      showProgressDialogService("Fetching Crif Data...");
      final response = await _apiService.crifStageTwo(
          reportId, orderId, redirectUrl, answer);
      if (response.status == Constants.SUCCESS) {
        if (response.data.status == "S10" || response.data.status == "S01") {
          // s10 status means auto Authentication done
          // s01 status means user given correct answer, call stage 3 api
          // call stage three api

          final thrirdResponse =
              await _apiService.crifStageThree(reportId, orderId, redirectUrl);
          setBusy(false);
          hideProgressDialogService();
          if (thrirdResponse.status == Constants.SUCCESS) {
            _setCrifData(thrirdResponse.data,fromServer: true);
          } else {
            hasError = true;
            notifyListeners();
          }
        } else if (response.data.status == "S11") {
          // user given incorrect answer, call stage 2 api again
          hideProgressDialogService();
          _questionCount++;
          final answer = await _navigationService.navigateToView(QuestionPage(
            question: response.data.question,
            options: response.data.options,
            questionCount: _questionCount,
            buttonType: response.data.buttonBehavior,
          ));

          fetchCrifStageTwoData(reportId, orderId, redirectUrl, answer);
          // Utility.pushToNext(, context);
        } else if (response.data.status == "S02") {
          // This is the User Authorization Failure scenario. In this scenario, user will need to get in touch with CHM Product Support team to fetch the CIR Report.
          hideProgressDialogService();
          setBusy(false);
          hasError = true;
          notifyListeners();
        } else {
          // unknown status code
          hideProgressDialogService();
          setBusy(false);
          hasError = true;
          notifyListeners();
        }
      } else {
        hideProgressDialogService();
        hasError = true;
        notifyListeners();
        _snackBarService.showSnackbar(message: response.message);
      }
    } catch (e) {
      hasError = true;
      setBusy(false);
      hideProgressDialogService();
      //hideProgressDialogService()
      myPrint(e.toString());
      _snackBarService.showSnackbar(message: e.toString());
    }
  }

  _setCrifData(CrifData crifData, {bool fromServer = false}) {
    _crifData = crifData;
    if (_crifData.overdueList.isEmpty) {
      _currentTab = 0;
    }
    _score = int.parse(_crifData.scoreData.scoreValue);

    final dateTime = Utility.parseServerDate(_crifData.header.addedonDate);
    _asOnDate = Utility.formattedDeviceMonthDate(dateTime);
    final nextMonthDate = DateTime(dateTime.year, dateTime.month + 1, 6);
    _daysLeft = nextMonthDate.difference(DateTime.now()).inDays;

    myPrint("days left $_daysLeft");
    if (fromServer) {
      _animatedScore = _score;
    }
    notifyListeners();
  }

  Stream<int> animateScore() async* {
    await Future.delayed(Duration(milliseconds: 1200));
    while (_animatedScore <= _score) {
      yield _animatedScore++;
      await Future.delayed(Duration(microseconds: 950));
    }
  }
}
