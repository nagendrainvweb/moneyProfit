import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/model/notification_data.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  List<NotificationData> _notificationList;

  bool _loading = true;
  bool _hasError = false;
  bool get loading => _loading;
  bool get hasError => _hasError;
  List<NotificationData> get notificationList => _notificationList;

  fetchNotifications() async {
    _loading = true;
    _hasError = false;
    notifyListeners();
    try {
      final resposne = await _apiService.fetchNotification();
      _loading = false;
      if (resposne.status == Constants.SUCCESS) {
        _notificationList = resposne.data;
        notifyListeners();
      } else {
        _hasError = true;
        notifyListeners();
      }
    } catch (e) {
      _loading = false;
      _hasError = true;
      notifyListeners();
      // _snackBarService.showSnackbar(message: e.toString());
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      showProgressDialogService("Please wait...");
      final response = await _apiService.deleteNotification(id);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        return true;
      } else {
        await _dialogService.showCustomDialog(
            variant: DialogType.error,
            title: "Error",
            description: response.message);
        return false;
      }
    } catch (e) {
      await _dialogService.showCustomDialog(
          variant: DialogType.error, title: "Error", description: e.toString());
      return false;
    }
  }
}
