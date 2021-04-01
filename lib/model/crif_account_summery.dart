class CrifAccountSummary {
  String id;
  String crifResponeDataId;
  String moneyUserId;
  String inquiryInLast6Months;
  String lengthOfCreditHistoryYear;
  String lengthOfCreditHistoryMonth;
  String averageAccountAgeYear;
  String averageAccountAgeMonth;
  String newAccountInLast6Months;
  String newDelinqAccountInLast6Months;
  String primaryNoOfAccounts;
  String primaryActiveNoOfAccounts;
  String primaryOverdueNoOfAccounts;
  String primarySecuredNoOfAccounts;
  String primaryUnsecuredNoOfAccounts;
  String primaryUntaggedNoOfAccounts;
  String primaryCurrentBalance;
  String primarySectionedAmount;
  String primaryDisbursedAmount;
  String secondaryNoOfAccounts;
  String secondaryActiveNoOfAccounts;
  String secondaryOverdueNoOfAccounts;
  String secondarySecuredNoOfAccounts;
  String secondaryUnsecuredNoOfAccounts;
  String secondaryUntaggedNoOfAccounts;
  String secondaryCurrentBalance;
  String secondarySectionedAmount;
  String secondaryDisbursedAmount;
  String addedonDate;
  String addedonTime;
  String updatedDate;
  String updatedTime;

  CrifAccountSummary(
      {this.id,
      this.crifResponeDataId,
      this.moneyUserId,
      this.inquiryInLast6Months,
      this.lengthOfCreditHistoryYear,
      this.lengthOfCreditHistoryMonth,
      this.averageAccountAgeYear,
      this.averageAccountAgeMonth,
      this.newAccountInLast6Months,
      this.newDelinqAccountInLast6Months,
      this.primaryNoOfAccounts,
      this.primaryActiveNoOfAccounts,
      this.primaryOverdueNoOfAccounts,
      this.primarySecuredNoOfAccounts,
      this.primaryUnsecuredNoOfAccounts,
      this.primaryUntaggedNoOfAccounts,
      this.primaryCurrentBalance,
      this.primarySectionedAmount,
      this.primaryDisbursedAmount,
      this.secondaryNoOfAccounts,
      this.secondaryActiveNoOfAccounts,
      this.secondaryOverdueNoOfAccounts,
      this.secondarySecuredNoOfAccounts,
      this.secondaryUnsecuredNoOfAccounts,
      this.secondaryUntaggedNoOfAccounts,
      this.secondaryCurrentBalance,
      this.secondarySectionedAmount,
      this.secondaryDisbursedAmount,
      this.addedonDate,
      this.addedonTime,
      this.updatedDate,
      this.updatedTime});

  CrifAccountSummary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    crifResponeDataId = json['crif_respone_data_id'];
    moneyUserId = json['money_user_id'];
    inquiryInLast6Months = json['inquiry_in_last_6_months'];
    lengthOfCreditHistoryYear = json['length_of_credit_history_year'];
    lengthOfCreditHistoryMonth = json['length_of_credit_history_month'];
    averageAccountAgeYear = json['average_account_age_year'];
    averageAccountAgeMonth = json['average_account_age_month'];
    newAccountInLast6Months = json['new_account_in_last_6_months'];
    newDelinqAccountInLast6Months = json['new_delinq_account_in_last_6_months'];
    primaryNoOfAccounts = json['primary_no_of_accounts'];
    primaryActiveNoOfAccounts = json['primary_active_no_of_accounts'];
    primaryOverdueNoOfAccounts = json['primary_overdue_no_of_accounts'];
    primarySecuredNoOfAccounts = json['primary_secured_no_of_accounts'];
    primaryUnsecuredNoOfAccounts = json['primary_unsecured_no_of_accounts'];
    primaryUntaggedNoOfAccounts = json['primary_untagged_no_of_accounts'];
    primaryCurrentBalance = json['primary_current_balance'];
    primarySectionedAmount = json['primary_sectioned_amount'];
    primaryDisbursedAmount = json['primary_disbursed_amount'];
    secondaryNoOfAccounts = json['secondary_no_of_accounts'];
    secondaryActiveNoOfAccounts = json['secondary_active_no_of_accounts'];
    secondaryOverdueNoOfAccounts = json['secondary_overdue_no_of_accounts'];
    secondarySecuredNoOfAccounts = json['secondary_secured_no_of_accounts'];
    secondaryUnsecuredNoOfAccounts = json['secondary_unsecured_no_of_accounts'];
    secondaryUntaggedNoOfAccounts = json['secondary_untagged_no_of_accounts'];
    secondaryCurrentBalance = json['secondary_current_balance'];
    secondarySectionedAmount = json['secondary_sectioned_amount'];
    secondaryDisbursedAmount = json['secondary_disbursed_amount'];
    addedonDate = json['addedon_date'];
    addedonTime = json['addedon_time'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['crif_respone_data_id'] = this.crifResponeDataId;
    data['money_user_id'] = this.moneyUserId;
    data['inquiry_in_last_6_months'] = this.inquiryInLast6Months;
    data['length_of_credit_history_year'] = this.lengthOfCreditHistoryYear;
    data['length_of_credit_history_month'] = this.lengthOfCreditHistoryMonth;
    data['average_account_age_year'] = this.averageAccountAgeYear;
    data['average_account_age_month'] = this.averageAccountAgeMonth;
    data['new_account_in_last_6_months'] = this.newAccountInLast6Months;
    data['new_delinq_account_in_last_6_months'] =
        this.newDelinqAccountInLast6Months;
    data['primary_no_of_accounts'] = this.primaryNoOfAccounts;
    data['primary_active_no_of_accounts'] = this.primaryActiveNoOfAccounts;
    data['primary_overdue_no_of_accounts'] = this.primaryOverdueNoOfAccounts;
    data['primary_secured_no_of_accounts'] = this.primarySecuredNoOfAccounts;
    data['primary_unsecured_no_of_accounts'] =
        this.primaryUnsecuredNoOfAccounts;
    data['primary_untagged_no_of_accounts'] = this.primaryUntaggedNoOfAccounts;
    data['primary_current_balance'] = this.primaryCurrentBalance;
    data['primary_sectioned_amount'] = this.primarySectionedAmount;
    data['primary_disbursed_amount'] = this.primaryDisbursedAmount;
    data['secondary_no_of_accounts'] = this.secondaryNoOfAccounts;
    data['secondary_active_no_of_accounts'] = this.secondaryActiveNoOfAccounts;
    data['secondary_overdue_no_of_accounts'] =
        this.secondaryOverdueNoOfAccounts;
    data['secondary_secured_no_of_accounts'] =
        this.secondarySecuredNoOfAccounts;
    data['secondary_unsecured_no_of_accounts'] =
        this.secondaryUnsecuredNoOfAccounts;
    data['secondary_untagged_no_of_accounts'] =
        this.secondaryUntaggedNoOfAccounts;
    data['secondary_current_balance'] = this.secondaryCurrentBalance;
    data['secondary_sectioned_amount'] = this.secondarySectionedAmount;
    data['secondary_disbursed_amount'] = this.secondaryDisbursedAmount;
    data['addedon_date'] = this.addedonDate;
    data['addedon_time'] = this.addedonTime;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}