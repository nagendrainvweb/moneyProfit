import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/model/easyCashData.dart';
import 'package:moneypros/pages/address_profile/address_profile.dart';
import 'package:moneypros/pages/basic_profile/basic_info_page.dart';
import 'package:moneypros/pages/identity_profile/identity_profile.dart';
import 'package:moneypros/pages/login/login_page.dart';
import 'package:moneypros/pages/subscription/subscription_page.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  UserRepo _userRepo;

  String _type;
  bool _loading = true;
  bool _hasError = false;

  int _currentPosition = 0;

  List<EasyCashData> _easyCashList = [];
  List<EasyCashData> _trandingList = [];

  int get currentPosition => _currentPosition;
  List<EasyCashData> get easyCashList => _easyCashList;
  List<EasyCashData> get trandingList => _trandingList;

  bool _login = false;
  bool _subscribe = false;
  bool _basicDone = false;

  bool _addressDone = false;
  bool _identitiyDone = false;

  String get type => _type;
  bool get loading => _loading;
  bool get hasError => _hasError;

  UserRepo get userRepo => _userRepo;
  bool get login => _login;
  bool get subscribe => _subscribe;
  bool get addressDone => _addressDone;
  bool get identitiyDone => _identitiyDone;
  bool get basicDone => _basicDone;

  setTrandingData() {
    _trandingList.add(EasyCashData(
        id: 1,
        title: AppStrings.homeLoan,
        desc:
            "Life is great if we have our own house to live in. You may not have much of luxuries, but if you own a small house, it is an achievement.",
        image: ImageAsset.homeLoan));

    _trandingList.add(EasyCashData(
        id: 2,
        title: AppStrings.personalLoan,
        desc:
            "Invest or spend to the best of it’s utilization then a personal loan serves you best. Personal loans are affordable and satisfy all your needs at your convenience",
        image: ImageAsset.persoalLoan));
    _trandingList.add(EasyCashData(
        id: 3,
        title: AppStrings.businessLoan,
        desc:
            "Business loan helps traders, businessmen and professionals to start and also to expand their commercial activities to where sky is the limit.",
        image: ImageAsset.businessLoan));
    _trandingList.add(EasyCashData(
        id: 4,
        title: AppStrings.loanAgaintsProperty,
        desc:
            "Your Property is your financial wealth and it helps you build value both emotionally and economically with time.",
        image: ImageAsset.loanAgaintsProperty));
    _trandingList.add(EasyCashData(
        id: 5,
        title: AppStrings.educationLoan,
        desc:
            "Education loan is the need of the growing world and its importance is most valued in today’s society.",
        image: ImageAsset.educationLoan));
    _trandingList.add(EasyCashData(
        id: 6,
        title: AppStrings.goldLoan,
        desc:
            "A Gold loan is one of the fastest and easiest way to meet all your major financial needs such as capital needs of your business.",
        image: ImageAsset.goldLoan));
    _trandingList.add(EasyCashData(
        id: 6,
        title: AppStrings.healthInsurance,
        desc:
            "For the on road insurance of any individual, the need of Car/Auto Insurance has increased due to the mandatory law of insuring every vehicle that runs on the road.",
        image: ImageAsset.insurance));
    _trandingList.add(EasyCashData(
        id: 6,
        title: "Wealth Management",
        desc:
            "MoneyPros provides financial planning and goal based services to customers’.",
        image: ImageAsset.walth));
    notifyListeners();
  }

  setEasyData() {
    _easyCashList.add(EasyCashData(
        id: 1,
        title: "Free Credit Report",
        desc: "Know your credit Score for free",
        image: ImageAsset.report));

    _easyCashList.add(EasyCashData(
        id: 2,
        title: "Comparison",
        desc: "Easy comparison of the different rates of interest from lenders",
        image: ImageAsset.compare));
    _easyCashList.add(EasyCashData(
        id: 3,
        title: "Quick Disbursal",
        desc: "Quicker & simpler disbursal of loans",
        image: ImageAsset.quick));
    _easyCashList.add(EasyCashData(
        id: 4,
        title: "Document Repository",
        desc: "Have access to your documents on the go just when you need them",
        image: ImageAsset.doc));
    _easyCashList.add(EasyCashData(
        id: 5,
        title: "Advisory Services",
        desc:
            "MoneyPros provides financial advisory services for all your financial needs",
        image: ImageAsset.advisory));
    _easyCashList.add(EasyCashData(
        id: 6,
        title: "Refer And Earn",
        desc: "Refer your friends. Get rewarded!",
        image: ImageAsset.refer));

    notifyListeners();
  }

  void updatePosition(int value) {
    _currentPosition = value;
    notifyListeners();
  }

  void fetchDashboardData() async {
    _loading = true;
    _hasError = false;
    notifyListeners();
    try {
      final response = await _apiService.dashboardData();
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _userRepo.setDashboardData(response.data);
      } else {
        _hasError = true;
      }
      notifyListeners();
    } catch (e) {
      _loading = false;
      _hasError = true;
      notifyListeners();
    }
  }

  validationOnCreditScore() {
    if (_login && _subscribe && _basicDone && _identitiyDone && _addressDone) {
      Utility.pushToDashboard(1);
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

  void initData(UserRepo userRepo) async {
    myPrint("hey i am called");
    _userRepo = userRepo;
    _login = await Prefs.login;
    if (_login) {
      _subscribe = await Prefs.subscription;
      _basicDone = userRepo.basicDetailsAreDone();
      _identitiyDone = userRepo.identityDetailsAreDone();
      _addressDone = userRepo.addressDetailsAreDone();
    }
    if (_userRepo.dashboardData != null) {
      _loading = false;
      notifyListeners();
    } else {
      fetchDashboardData();
    }
  }
}
