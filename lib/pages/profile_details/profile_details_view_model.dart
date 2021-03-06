import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/pages/home/home_page.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileEditViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();

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
  final marriedStatusController = TextEditingController();

  /** Identity details Textcontroller */
  final panController = TextEditingController();
  final drivingController = TextEditingController();
  final voterController = TextEditingController();
  final passportController = TextEditingController();
  final rationController = TextEditingController();
  final aadharController = TextEditingController();

  /** Address Details TextController */
  final addressController = TextEditingController();
  final villageController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();





  List<String> _genderList = ["Male", "Female", "Transgender"];
  List<String> _martialStausList = ["Married", "Unmarried"];

  List<String> get genderList => _genderList;
  List<String> get martialStatusList => _martialStausList;

  setDOB(DateTime date) {
    dobController.text = Utility.formattedDeviceDate(date);
    ageController.text = Utility.calculateAge(date);
    notifyListeners();
  }

  void updateAddressClicked() {
    _navigationService.navigateToView(HomePage());
  }
}
