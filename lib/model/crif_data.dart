import 'crif_account_summery.dart';
import 'crif_header.dart';
import 'crif_loan_data.dart';
import 'crif_score_data.dart';

class CrifData {
  CrifHeader header;
  CrifScoreData scoreData;
  CrifAccountSummary accountSummary;
  List<CrifLoanData> loanList;
  String redirectURL;
  String reportId;
  String orderId;
  String status;
  String question;
  List<String> options;
  String buttonBehavior;
  String statusDesc;

  List<CrifLoanData> activeList;
  List<CrifLoanData> closedList;
  List<CrifLoanData> overdueList;
  List<String> activeTypeList;
  List<String> closeTypeList;
  List<String> overdueTypeList;

  int activeBalance = 0;
  int closeBalance = 0;
  int overdueBalance = 0;

  CrifData(
      {this.header,
      this.scoreData,
      this.accountSummary,
      this.loanList,
      this.redirectURL,
      this.reportId,
      this.orderId,
      this.status,
      this.question,
      this.options,
      this.statusDesc,
      this.buttonBehavior});

  CrifData.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new CrifHeader.fromJson(json['header']) : null;
    scoreData = json['score_data'] != null
        ? new CrifScoreData.fromJson(json['score_data'])
        : null;
    accountSummary = json['account_summary'] != null
        ? new CrifAccountSummary.fromJson(json['account_summary'])
        : null;

    if (json['loan_details'] != null) {
      loanList = new List<CrifLoanData>();
      json['loan_details'].forEach((v) {
        loanList.add(new CrifLoanData.fromJson(v));
      });
    }

    redirectURL = json['redirectURL'];
    reportId = json['reportId'];
    orderId = json['orderId'];
    status = json['status'];
    question = json['Question'];
    statusDesc = json['statusDesc'];
    buttonBehavior = json['buttonBehavior'];
    if (json['optionsList'] != null) {
      options = new List<String>();
      json['optionsList'].forEach((v) {
        loanList.add(v);
      });
    }

    if (loanList != null) {
      _setActiveAccount();
      _setClosedAccount();
      _setOverDueAccount();
    }
  }

  _setActiveAccount() {
    activeList = loanList
        .where((element) => (element.accountStatus == "Active"))
        .toList();
    activeList.sort((a, b) {
      return (a.accountType.compareTo(b.accountType));
    });
    _setActiveAccountType();
  }

  _setClosedAccount() {
    closedList = loanList
        .where((element) => (element.accountStatus == "Closed"))
        .toList();
    closedList.sort((a, b) {
      return (a.accountType.compareTo(b.accountType));
    });
    _setClosedAccountType();
  }

  _setOverDueAccount() {
    overdueList = loanList.where((element) {
      //final overdueAmount = int.parse(element.overdueAmount);
      return (element.overdueAmount != "0");
    }).toList();

    overdueList.sort((a, b) {
      return (a.accountType.compareTo(b.accountType));
    });

    _setOverdueAccountType();
  }

  _setActiveAccountType() {
    activeTypeList = [];
    String value = "";
    activeList.forEach((element) {
      if (element.accountType != value) {
        activeTypeList.add(element.accountType);
        value = element.accountType;
      }
    });
  }

  _setClosedAccountType() {
    closeTypeList = [];
    String value = "";
    closedList.forEach((element) {
      if (element.accountType != value) {
        closeTypeList.add(element.accountType);
        value = element.accountType;
      }
    });
  }

  _setOverdueAccountType() {
    overdueTypeList = [];
    String value = "";
    overdueList.forEach((element) {
      if (element.accountType != value) {
        overdueTypeList.add(element.accountType);
        value = element.accountType;
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.scoreData != null) {
      data['score_data'] = this.scoreData.toJson();
    }
    if (this.accountSummary != null) {
      data['account_summary'] = this.accountSummary.toJson();
    }
    if (this.loanList != null) {
      data['loan_details'] = this.loanList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoanTypeData {
  String type;
  String totalAmount;
  String date;

  LoanTypeData({this.type, this.totalAmount, this.date});
}
