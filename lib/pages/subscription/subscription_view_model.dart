import 'package:moneypros/app/locator.dart';
import 'package:moneypros/pages/profile_details/profile_details.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SubscriptionViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();

  void payClicked() {
    _navigationService.navigateToView(ProfileEditPage());
  }
}
