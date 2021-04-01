import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/model/login_data.dart';
import 'package:moneypros/pages/address_profile/address_profile.dart';
import 'package:moneypros/pages/basic_profile/basic_info_page.dart';
import 'package:moneypros/pages/identity_profile/identity_profile.dart';
import 'package:moneypros/pages/login/login_page.dart';
import 'package:moneypros/pages/subscription/subscription_page.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/api_error_exception.dart';
import 'package:moneypros/utils/dialog_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  int _currentBottomIndex = 0;
  int get currentBottomIndex => _currentBottomIndex;
  UserRepo _userRepo;
  bool _login = false;
  bool _subscribe = false;
  bool _basicDone = false;

  bool _addressDone = false;
  bool _identitiyDone = false;

  UserRepo get userRepo => _userRepo;
  bool get login => _login;
  bool get subscribe => _subscribe;
  bool get addressDone => _addressDone;
  bool get identitiyDone => _identitiyDone;
  bool get basicDone => _basicDone;

  void onBottomButtonClicked(int value) {
    if (value == 1) {
      _validationOnCreditScore(value);
    } else if (value == 2) {
      if (_login) {
        _currentBottomIndex = value;
        notifyListeners();
      } else {
        _navigationService.navigateToView(LoginPage(
          showClose: true,
        ));
      }
    } else {
      _currentBottomIndex = value;
      notifyListeners();
    }
  }

  listenFirebase() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  _validationOnCreditScore(value) {
    if (_login && _subscribe && _basicDone && _identitiyDone && _addressDone) {
      _currentBottomIndex = value;
      notifyListeners();
    } else if (!_login) {
      _navigationService.navigateToView(LoginPage(
        showClose: true,
      ));
    } else if (!_subscribe) {
      _navigationService.navigateToView(SubscriptionPage());
    } else if (!_basicDone) {
      _navigationService.navigateToView(BasicInfoPage());
    } else if (!_identitiyDone) {
      _navigationService.navigateToView(IdentityProfile());
    } else if (!_addressDone) {
      _navigationService.navigateToView(AddressProfile());
    }
  }

  void retryClicked() {}

  void initData(UserRepo userRepo, int position) async {
    _userRepo = userRepo;
    _login = await Prefs.login;
    if (_login) {
      _subscribe = await Prefs.subscription;
      _basicDone = userRepo.basicDetailsAreDone();
      _identitiyDone = userRepo.identityDetailsAreDone();
      _addressDone = userRepo.addressDetailsAreDone();
    }
    if (position == 1 && _basicDone && _identitiyDone && _addressDone) {
      _currentBottomIndex = position;
    } else if (position == 2) {
      _currentBottomIndex = position;
    } else {
      _currentBottomIndex = 0;
    }

    notifyListeners();
  }

  void checkUpdate(BuildContext context) async {
    try {
      final response = await _apiService.checkUpdate();
      if (response.isUpdate == "1") {
        DialogHelper.showUpdateDialog(context, response);
      }
    } on ApiErrorException catch (e) {} on Exception catch (e) {}
  }
}
