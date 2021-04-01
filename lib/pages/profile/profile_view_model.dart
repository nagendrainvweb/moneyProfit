import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/model/crif_history_date_data.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  UserRepo _userRepo;

  List<CrifHistoryDateData> _crifDates;

  List<CrifHistoryDateData> get crifDates => _crifDates;

  initData(UserRepo userRepo) {
    _userRepo = userRepo;
  }

  void fetchCrifHistoryDates({Function onDateCallback}) async {
    showProgressDialogService("Please wait...");
    try {
      final resposne = await _apiService.crifHistoryDates();
      hideProgressDialogService();
      if (resposne.status == Constants.SUCCESS) {
        _crifDates = resposne.data;
        notifyListeners();
        onDateCallback(resposne.data);
      } else {
        final value = await _dialogService.showCustomDialog(
          variant: DialogType.error,
          title: "Error",
          description: resposne.message,
          barrierDismissible: true,
        );
      }
    } catch (e) {
      hideProgressDialogService();
      final value = await _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: "Error",
        description: e.toString(),
        barrierDismissible: true,
      );
    }
  }


}
