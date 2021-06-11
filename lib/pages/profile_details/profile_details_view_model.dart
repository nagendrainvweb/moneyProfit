import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/model/city_data.dart';
import 'package:moneypros/model/login_data.dart';
import 'package:moneypros/pages/address_profile/address_profile.dart';
import 'package:moneypros/pages/home/home_page.dart';
import 'package:moneypros/pages/identity_profile/identity_profile.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileEditViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  UserRepo _userRepo;

  bool _basicEditable;
  bool _identityEdiatble;
  bool _addressEditable;

  String _basicFrom;
  String _identityFrom;
  String _addressFrom;

  /** Personal details textController */
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final spouseNameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  final ageController = TextEditingController();
  final marriedStatusController = TextEditingController(text: "Unmarried");

  /** Identity details Textcontroller */
  final panController = TextEditingController();
  final drivingController = TextEditingController();
  final voterController = TextEditingController();
  final passportController = TextEditingController();
  final rationController = TextEditingController();
  final aadharController = MaskedTextController(mask: "0000 0000 0000");

  /** Address Details TextController */
  final addressController = TextEditingController();
  final villageController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();

  List<String> _genderList = ["Male", "Female", "Transgender"];
  List<String> _martialStausList = ["Married", "Unmarried"];
  List<CityData> _cityList = [];

  String _stateId = "";
  bool _checkBoxValue = false;

  bool get basicEditable => _basicEditable;
  bool get identityEditable => _identityEdiatble;
  bool get addressEditable => _addressEditable;

  String get basicFrom => _basicFrom;
  String get identityFrom => _identityFrom;
  String get addressFrom => _addressFrom;

  List<String> get genderList => _genderList;
  List<String> get martialStatusList => _martialStausList;
  String get stateId => _stateId;
  List<CityData> get cityList => _cityList;
  UserRepo get userRepo => _userRepo;
  bool get checkBoxValue => _checkBoxValue;

  setDOB(DateTime date) {
    dobController.text = Utility.formattedDeviceDate(date);
    ageController.text = Utility.calculateAge(date) + " Years";
    notifyListeners();
  }

  void backToHome() {
    _navigationService.clearTillFirstAndShowView(HomePage());
  }

  onCheckBoxChanged(bool value) {
    _checkBoxValue = value;
    notifyListeners();
  }

  void updateAddressClicked() {
    final address = addressController.text;
    final village = villageController.text;
    final state = stateController.text;
    final city = cityController.text;
    final pincode = pincodeController.text;

    if (address.isNotEmpty &&
        village.isNotEmpty &&
        state.isNotEmpty &&
        city.isNotEmpty &&
        pincode.isNotEmpty) {
      if (_checkBoxValue) {
        _updateAddress(address, village, state, city, pincode);
      } else {
        _snackBarService.showSnackbar(
            message:
                "Please provide your concent to save your details with moneyPros");
      }
    } else {
      _snackBarService.showSnackbar(
          message: "Please fill all required information");
    }
  }

  void onUpdateBasicDetailsClicked() async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final fatherName = fatherNameController.text;
    final martialStatus = marriedStatusController.text;
    final spouse = spouseNameController.text;
    final email = emailController.text;
    final number = numberController.text;
    final dob = dobController.text;
    final age = ageController.text;
    final gender = genderController.text;

    // not required feilds
    final middleName = middleNameController.text;
    final motherName = motherNameController.text;

    myPrint(
        "value is ${(firstName.isNotEmpty && lastName.isNotEmpty && fatherName.isNotEmpty && martialStatus.isNotEmpty && (martialStatus != "Married" && spouse.isEmpty) && email.isNotEmpty && number.isNotEmpty && dob.isNotEmpty && age.isNotEmpty && gender.isNotEmpty)}");
    myPrint("firstName is ${firstName.isNotEmpty}");
    myPrint("lastName is ${lastName.isNotEmpty}");
    myPrint("fatherName is ${fatherName.isNotEmpty}");
    myPrint("martialStatus is ${martialStatus.isNotEmpty}");
    myPrint("email is ${email.isNotEmpty}");
    myPrint("number is ${number.isNotEmpty}");
    myPrint("age is ${age.isNotEmpty}");
    myPrint("age is ${age.isNotEmpty}");
    myPrint("gender is ${gender.isNotEmpty}");
    myPrint(
        "martialStatus == Married && spouse.isEmpty ${(martialStatus == "Married" && spouse.isNotEmpty)}");

    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        fatherName.isNotEmpty &&
        martialStatus.isNotEmpty &&
        email.isNotEmpty &&
        number.isNotEmpty &&
        dob.isNotEmpty &&
        age.isNotEmpty &&
        gender.isNotEmpty) {
      if (martialStatus == "Married") {
        if (spouse.isNotEmpty) {
          _updateBasicDetails();
        } else {
          _snackBarService.showSnackbar(message: "Please fill spouse name");
        }
      } else {
        _updateBasicDetails();
      }
    } else {
      _snackBarService.showSnackbar(
          message: "Please fill all required information");
    }
    // _navigationService.navigateToView(IdentityProfile());
  }

  _updateBasicDetails() async {
    final DateTime date = Utility.parseDeviceDate(dobController.text);
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final fatherName = fatherNameController.text;
    final martialStatus = marriedStatusController.text;
    final spouseName = spouseNameController.text;
    final email = emailController.text;
    final number = numberController.text;
    final dob = Utility.formattedServerDate(date);
    final age = ageController.text.replaceAll("Years", "");
    final gender = genderController.text;

    // not required feilds
    final middleName = middleNameController.text;
    final motherName = motherNameController.text;
    final userId = await Prefs.userId;

    // register user by calling api
    showProgressDialogService("Please wait...");
    try {
      final resposne = await _apiService.updatePersonalDetails(
          userId,
          firstName,
          middleName,
          lastName,
          fatherName,
          motherName,
          martialStatus,
          spouseName,
          dob,
          age,
          gender);
      hideProgressDialogService();
      if (resposne.status == Constants.SUCCESS) {
        final userDetails = _userRepo.userDetails;
        userDetails.firstName = firstName;
        userDetails.middleName = middleName;
        userDetails.lastName = lastName;
        userDetails.fatherName = fatherName;
        userDetails.motherName = motherName;
        userDetails.maritalStatus = martialStatus;
        userDetails.spouseName = spouseName;
        userDetails.dob = dob;
        userDetails.age = age;
        userDetails.gender = gender;
        final int value =
            await _userRepo.setUserDataIntoTable(userDetails.toJson());
        if (value > -1) {
          _userRepo.setUserData(resposne.data.userdetails);
          _userRepo.setSubscrptionData(resposne.data.subscription);
          _userRepo.setTransactionData(resposne.data.transaction);
          if (_basicFrom == "profile") {
            _navigationService.back(result: resposne.message);
          } else {
            _navigationService.navigateToView(IdentityProfile());
          }
        }
      } else {
        _snackBarService.showSnackbar(message: resposne.message);
      }
    } catch (e) {
      hideProgressDialogService();
      _snackBarService.showSnackbar(message: e.toString());
    }
  }

  void onIdentityClicked() {
    // _navigationService.navigateToView(AddressProfile());

    final panCard = panController.text;
    final drivingLicense = drivingController.text;
    final voterId = voterController.text;
    final passport = passportController.text;
    final rationCard = rationController.text;
    final aadhar = aadharController.text.replaceAll(" ", "");
    myPrint("aadhar is $aadhar");

    if (panCard.isNotEmpty ||
        drivingLicense.isNotEmpty ||
        voterId.isNotEmpty ||
        passport.isNotEmpty ||
        rationCard.isNotEmpty ||
        aadhar.isNotEmpty) {
      _updateIdentityDetails(
          panCard, drivingLicense, voterId, passport, rationCard, aadhar);
    } else {
      _snackBarService.showSnackbar(message: "Please Enter Atleast one feild.");
    }
  }

  void initPersonal(UserRepo userRepo, bool editable, String from) async {
    // final id = await Prefs.userId;
    _userRepo = userRepo;
    _basicEditable = editable;
    _basicFrom = from;
    final _userdetails = _userRepo.userDetails;

    firstNameController.text = _userdetails.firstName;
    middleNameController.text = _userdetails.middleName;
    lastNameController.text = _userdetails.lastName;
    fatherNameController.text = _userdetails.fatherName;
    motherNameController.text = _userdetails.motherName;
    marriedStatusController.text = _userdetails.maritalStatus;
    spouseNameController.text = _userdetails.spouseName;
    emailController.text = _userdetails.email;
    numberController.text = _userdetails.mobile;
    ageController.text = _userdetails.age;
    genderController.text = _userdetails.gender;
    
    try {
      final date = Utility.parseServerDate(_userdetails.dob);
      dobController.text = Utility.formattedDeviceDate(date);
    } catch (e) {
      myPrint(e.toString());
    }
  }

  void initIdentitiy(UserRepo userRepo, bool editable, String from) {
    _userRepo = userRepo;
    _identityEdiatble = editable;
    _identityFrom = from;
    final userData = userRepo.userDetails;
    panController.text = userData.pan;
    drivingController.text = userData.drivingLicense;
    voterController.text = userData.voterId;
    passportController.text = userData.passport;
    rationController.text = userData.rationCard;
    aadharController.text = userData.aadharUid;
  }

  void initAddress(UserRepo userRepo, bool editable, String from) {
    _userRepo = userRepo;
    _addressEditable = editable;
    _addressFrom = from;
    final userData = userRepo.userDetails;
    addressController.text = userData.address;
    villageController.text = userData.village;
    stateController.text = userData.state;
    cityController.text = userData.city;
    pincodeController.text = userData.pincode;

    if (_addressFrom == "profile") {
      _checkBoxValue = true;
    }

    String stateId = "";
    userRepo.stateList.forEach((element) {
      if (element.name == userData.state) {
        stateId = element.id;
      }
    });

    setStateId(stateId);
  }

  void _updateIdentityDetails(String panCard, String drivingLicense,
      String voterId, String passport, String rationCard, String aadhar) async {
    showProgressDialogService("Please wait...");
    try {
      final userId = await Prefs.userId;
      final resposne = await _apiService.updateIdentitiyDetails(
        userId,
        panCard,
        drivingLicense,
        voterId,
        passport,
        rationCard,
        aadhar,
      );
      hideProgressDialogService();
      if (resposne.status == Constants.SUCCESS) {
        final userDetails = _userRepo.userDetails;
        userDetails.pan = panCard;
        userDetails.drivingLicense = drivingLicense;
        userDetails.voterId = voterId;
        userDetails.passport = passport;
        userDetails.rationCard = rationCard;
        userDetails.aadharUid = aadhar;
        final int value =
            await _userRepo.setUserDataIntoTable(userDetails.toJson());
        if (value > -1) {
          _userRepo.setUserData(resposne.data.userdetails);
          _userRepo.setSubscrptionData(resposne.data.subscription);
          _userRepo.setTransactionData(resposne.data.transaction);
          if (_identityFrom == "profile") {
            _navigationService.back(result: resposne.message);
          } else {
            _navigationService.navigateToView(AddressProfile());
          }
        }
      } else {
        _snackBarService.showSnackbar(message: resposne.message);
      }
    } catch (e) {
      hideProgressDialogService();
      _snackBarService.showSnackbar(message: e.toString());
    }
  }

  void setStateId(String id) {
    _stateId = id;
    _cityList.clear();

    _cityList =
        _userRepo.cityList.where((element) => (element.stateId == id)).toList();
    myPrint("city length is ${_cityList.length}");
    notifyListeners();
  }

  void _updateAddress(String address, String village, String state, String city,
      String pincode) async {
    showProgressDialogService("Please wait...");
    try {
      final userId = await Prefs.userId;
      final resposne = await _apiService.updateAddressDetails(
          userId, address, village, state, city, pincode, "India", "Yes");
      hideProgressDialogService();
      if (resposne.status == Constants.SUCCESS) {
        final userDetails = _userRepo.userDetails;
        userDetails.address = address;
        userDetails.village = village;
        userDetails.state = state;
        userDetails.city = city;
        userDetails.pincode = pincode;
        userDetails.country = "India";
        final int value =
            await _userRepo.setUserDataIntoTable(userDetails.toJson());
        if (value > -1) {
          _userRepo.setUserData(resposne.data.userdetails);
          _userRepo.setSubscrptionData(resposne.data.subscription);
          _userRepo.setTransactionData(resposne.data.transaction);
          if (_addressFrom == "profile") {
            _navigationService.back(result: resposne.message);
          } else {
            backToHome();
          }
        }
      } else {
        _snackBarService.showSnackbar(message: resposne.message);
      }
    } catch (e) {
      hideProgressDialogService();
      _snackBarService.showSnackbar(message: e.toString());
    }
  }

  setBasicEditable(bool editable) {
    _basicEditable = editable;
    notifyListeners();
  }

  setIdentityEditable(bool editable) {
    _identityEdiatble = editable;
    notifyListeners();
  }

  setAddressEditable(bool editable) {
    _addressEditable = editable;
    notifyListeners();
  }
}
