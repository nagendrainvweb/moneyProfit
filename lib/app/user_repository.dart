import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/database/database_constants.dart';
import 'package:moneypros/database/database_helper.dart';
import 'package:moneypros/model/city_data.dart';
import 'package:moneypros/model/dashboard_data.dart';
import 'package:moneypros/model/login_data.dart';
import 'package:moneypros/model/state_data.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/utility.dart';

class UserRepo extends ChangeNotifier {
  Userdetails _userDetails;
  Subscription _subscription;
  Transaction _transaction;
  bool _isLogin = false;
  bool _subscribe = false;
  bool _loginSkipped = false;
  List<StateData> _stateList = [];
  List<CityData> _cityList = [];

  DashboardData _dashboardData;

  final _apiService = locator<ApiService>();

  DashboardData get dashboardData => _dashboardData;
  Userdetails get userDetails => _userDetails;
  Subscription get subscription => _subscription;
  Transaction get transaction => _transaction;
  bool get login => _isLogin;
  bool get subscribe => _subscribe;
  bool get loginSkipped => _loginSkipped;
  List<StateData> get stateList => _stateList;
  List<CityData> get cityList => _cityList;

  setSubscrptionData(Subscription data) {
    _subscription = data;
    notifyListeners();
  }

  setTransactionData(Transaction data) {
    _transaction = data;
    notifyListeners();
  }

  setLogin() async {
    _isLogin = await Prefs.login;
    notifyListeners();
  }

  setLoginSkipped() async {
    _loginSkipped = await Prefs.loginSkip;
    notifyListeners();
  }

  setDashboardData(DashboardData data) {
    _dashboardData = data;
    notifyListeners();
  }

  setSubscription() async {
    _subscribe = await Prefs.subscription;
    notifyListeners();
  }

  setUserData(Userdetails userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }

  setUserDatafromServer() async {
    if (_isLogin) {
      try {
        final response = await _apiService.userDetails();
        if (response.status == Constants.SUCCESS) {
          _userDetails = response.data.userdetails;
          _subscription = response.data.subscription;
          _transaction = response.data.transaction;
          final data = response.data;
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
          setUserDataIntoTable(_userDetails.toJson());
          // _subscribe = response.data.subscription;
        }
      } catch (e) {}
    }
  }

  clear() {
    _isLogin = false;
    _subscribe = false;
    _userDetails = null;
  }

  setStateList() async {
    final savedList = await Prefs.stateList;

    if (savedList.isEmpty) {
      final response = await _apiService.stateList();
      _stateList = response.data;
    } else {
      final list = json.decode(savedList);
      for (var map in list) {
        _stateList.add(StateData.fromJson(map));
      }
    }
    myPrint("state length is ${_stateList.length}");
  }

  setCityList() async {
    final savedList = await Prefs.cityList;

    if (savedList.isEmpty) {
      final response = await _apiService.cityList();
      _cityList = response.data;
    } else {
      final list = json.decode(savedList);
      for (var map in list) {
        _cityList.add(CityData.fromJson(map));
      }
    }
  }

  Future<int> setUserDataIntoTable(Map<String, dynamic> map) async {
    final row = await DatabaseHelper.instance
        .queryGetRow(DatabaseConstant.USER_TABLE, map["id"]);
    if (row == null) {
      return await DatabaseHelper.instance
          .insert(map, DatabaseConstant.USER_TABLE);
    } else {
      return await DatabaseHelper.instance
          .update(map, DatabaseConstant.USER_TABLE);
    }
  }

  Future<Userdetails> getUserDataFromTable(String userId) async {
    // myPrint(" id is $userId");
    // final list =
    //     await DatabaseHelper.instance.queryAllRow(DatabaseConstant.USER_TABLE);
    // list.forEach((element) {
    //   myPrint(" map is ${element.toString()}");
    // });
    final map = await DatabaseHelper.instance
        .queryGetRow(DatabaseConstant.USER_TABLE, userId);
    myPrint("map is ${map.toString()}");
    if (map != null) {
      Userdetails user = Userdetails.fromJson(map);
      _userDetails = user;
      return user;
    }
    return null;
  }

  Future init() async {
    await setLogin();
    await setLoginSkipped();
    await setSubscription();
    if (_isLogin) {
      final id = await Prefs.userId;
      final user = await getUserDataFromTable(id);
      _userDetails = user;
    }
  }

  bool basicDetailsAreDone() {
    return (_userDetails.firstName.isNotEmpty &&
        _userDetails.firstName.isNotEmpty &&
        _userDetails.lastName.isNotEmpty &&
        _userDetails.fatherName.isNotEmpty &&
        _userDetails.maritalStatus.isNotEmpty &&
        _userDetails.email.isNotEmpty &&
        _userDetails.mobile.isNotEmpty &&
        _userDetails.dob.isNotEmpty &&
        _userDetails.age.isNotEmpty &&
        _userDetails.gender.isNotEmpty);
  }

  bool identityDetailsAreDone() {
    return (_userDetails.pan.isNotEmpty ||
        _userDetails.drivingLicense.isNotEmpty ||
        _userDetails.voterId.isNotEmpty ||
        _userDetails.passport.isNotEmpty ||
        _userDetails.rationCard.isNotEmpty ||
        _userDetails.aadharUid.isNotEmpty);
  }

  bool addressDetailsAreDone() {
    return (_userDetails.address.isNotEmpty &&
        _userDetails.village.isNotEmpty &&
        _userDetails.state.isNotEmpty &&
        _userDetails.city.isNotEmpty &&
        _userDetails.pincode.isNotEmpty &&
        _userDetails.country.isNotEmpty);
  }
}
