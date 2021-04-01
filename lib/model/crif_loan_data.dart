import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/resources/strings/app_strings.dart';

class CrifLoanData {
  String id;
  String crifResponeDataId;
  String moneyUserId;
  String accountNo;
  String creditGuarantor;
  String accountType;
  String reportedDate;
  String ownershipInd;
  String accountStatus;
  String disbursedAmount;
  String disbursedDate;
  String lastPaymentDate;
  String closedDate;
  String installmentAmount;
  String overdueAmount;
  String writeOfAmount;
  String currentBalance;
  String combinedPaymentHistory;
  String matchedType;
  String linkedAccounts;
  String creditLimit;
  String securityDetails;
  String accountRemarks;
  String paymentTenure;
  String addedonDate;
  String addedonTime;
  String updatedonDate;
  String updatedonTime;
  String image;

  CrifLoanData(
      {this.id,
      this.crifResponeDataId,
      this.moneyUserId,
      this.accountNo,
      this.creditGuarantor,
      this.accountType,
      this.reportedDate,
      this.ownershipInd,
      this.accountStatus,
      this.disbursedAmount,
      this.disbursedDate,
      this.image,
      this.lastPaymentDate,
      this.closedDate,
      this.installmentAmount,
      this.overdueAmount,
      this.writeOfAmount,
      this.currentBalance,
      this.combinedPaymentHistory,
      this.matchedType,
      this.linkedAccounts,
      this.creditLimit,
      this.securityDetails,
      this.accountRemarks,
      this.paymentTenure,
      this.addedonDate,
      this.addedonTime,
      this.updatedonDate,
      this.updatedonTime});

  CrifLoanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    crifResponeDataId = json['crif_respone_data_id'];
    moneyUserId = json['money_user_id'];
    accountNo = json['account_no'];
    creditGuarantor = json['credit_guarantor'];
    accountType = json['account_type'];
    reportedDate = json['reported_date'];
    ownershipInd = json['ownership_ind'];
    accountStatus = json['account_status'];
    disbursedAmount = json['disbursed_amount'];
    disbursedDate = json['disbursed_date'];
    lastPaymentDate = json['last_payment_date'];
    closedDate = json['closed_date'];
    installmentAmount = json['installment_amount'];
    final String overdue = json['overdue_amount'] ?? "0";
    overdueAmount = overdue.isEmpty ? "0" : overdue;
    writeOfAmount = json['write_of_amount'];
    currentBalance = json['current_balance'];
    combinedPaymentHistory = json['combined_payment_history'];
    matchedType = json['matched_type'];
    linkedAccounts = json['linked_accounts'].toString().isEmpty
        ? "No Data"
        : json['linked_accounts'];
    creditLimit = json['credit_limit'];
    securityDetails = json['security_details'].toString().isEmpty
        ? "No Data"
        : json['security_details'];
    accountRemarks = json['account_remarks'].toString().isEmpty
        ? "No Data"
        : json['account_remarks'];
    paymentTenure = json['payment_tenure'];
    addedonDate = json['addedon_date'];
    addedonTime = json['addedon_time'];
    updatedonDate = json['updatedon_date'];
    updatedonTime = json['updatedon_time'];
    image = _getImagePath(accountType);
  }

  _getImagePath(String type) {
    String image = "";
    if(type.contains(AppStrings.creditCard)){
       image = ImageAsset.creditCard;
    }else if(type.contains(AppStrings.housingLoan)){
       image = ImageAsset.homeLoan;
    }else if(type.contains(AppStrings.personalLoan)){
      image = ImageAsset.persoalLoan;
    }else if(type.contains(AppStrings.propertyLoan)){
       image = ImageAsset.homeLoan;
    }else if(type.contains(AppStrings.autoLoan)){
      image = ImageAsset.auto;
    }else if(type.contains(AppStrings.consumerLoan)){
      image = ImageAsset.consumer;
    }else if(type.contains(AppStrings.businessLoan)){
      image = ImageAsset.businessLoan;
    }else if(type.contains(AppStrings.twoWheelerLoan)){
      image = ImageAsset.auto;
    }else if(type.contains(AppStrings.goldLoan)){
      image = ImageAsset.goldLoan;
    }else if(type.contains(AppStrings.overdraft)){
      image = ImageAsset.overdraft;
    }else{
      image = ImageAsset.homeLoan;
    }

    return image;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['crif_respone_data_id'] = this.crifResponeDataId;
    data['money_user_id'] = this.moneyUserId;
    data['account_no'] = this.accountNo;
    data['credit_guarantor'] = this.creditGuarantor;
    data['account_type'] = this.accountType;
    data['reported_date'] = this.reportedDate;
    data['ownership_ind'] = this.ownershipInd;
    data['account_status'] = this.accountStatus;
    data['disbursed_amount'] = this.disbursedAmount;
    data['disbursed_date'] = this.disbursedDate;
    data['last_payment_date'] = this.lastPaymentDate;
    data['closed_date'] = this.closedDate;
    data['installment_amount'] = this.installmentAmount;
    data['overdue_amount'] = this.overdueAmount;
    data['write_of_amount'] = this.writeOfAmount;
    data['current_balance'] = this.currentBalance;
    data['combined_payment_history'] = this.combinedPaymentHistory;
    data['matched_type'] = this.matchedType;
    data['linked_accounts'] = this.linkedAccounts;
    data['credit_limit'] = this.creditLimit;
    data['security_details'] = this.securityDetails;
    data['account_remarks'] = this.accountRemarks;
    data['payment_tenure'] = this.paymentTenure;
    data['addedon_date'] = this.addedonDate;
    data['addedon_time'] = this.addedonTime;
    data['updatedon_date'] = this.updatedonDate;
    data['updatedon_time'] = this.updatedonTime;
    return data;
  }
}
