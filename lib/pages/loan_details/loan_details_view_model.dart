import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/model/loan_data.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoanDetailsViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  UserRepo _userRepo;
  String _type;
  bool _loading = true;
  bool _hasError = false;

  List<Comparison> _comparisonList;
  List<Overview> _overViewList;
  List<Faq> _faqList;
  EligibleDocData _eligibleDocData;

  String get type => _type;
  bool get loading => _loading;
  bool get hasError => _hasError;
  EligibleDocData get eligibleDocData => _eligibleDocData;

  List<Comparison> get comparisonList => _comparisonList;
  List<Overview> get overViewList => _overViewList;
  List<Faq> get faqList => _faqList;
  int get selectedQuestion => _selectedQuestion;

  int _selectedQuestion = -1;

  void initData(String type) {
    _type = Utility.loanDetailsType(type.trim());
    fetchLoanDetails();
  }

  void setQuestionOpen(int value) {
    _selectedQuestion = (_selectedQuestion == value) ? -1 : value;
    notifyListeners();
  }

  void fetchLoanDetails() async {
    _loading = true;
    _hasError = false;
    notifyListeners();
    try {
      final resposne = await _apiService.loanDetails(_type);
      _loading = false;
      if (resposne.status == Constants.SUCCESS) {
        _comparisonList = resposne.data.comparison;
        _overViewList = resposne.data.overview;
        _faqList = resposne.data.faq;
        _eligibleDocData = resposne.data.eligibleDocData;
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
}
