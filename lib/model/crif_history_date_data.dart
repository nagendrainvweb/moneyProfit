class CrifHistoryDateData {
  String id;
  String moneyUserId;
  String preparedFor;
  String batchId;
  String reportId;
  String dateOfRequest;
  String dateOfIssue;
  String status;
  String addedonDate;
  String addedonTime;
  String updatedonDate;
  String updatedonTime;
  String entryDate;

  CrifHistoryDateData(
      {this.id,
      this.moneyUserId,
      this.preparedFor,
      this.batchId,
      this.reportId,
      this.dateOfRequest,
      this.dateOfIssue,
      this.status,
      this.addedonDate,
      this.addedonTime,
      this.updatedonDate,
      this.updatedonTime,
      this.entryDate});

  CrifHistoryDateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moneyUserId = json['money_user_id'];
    preparedFor = json['prepared_for'];
    batchId = json['batch_id'];
    reportId = json['report_id'];
    dateOfRequest = json['date_of_request'];
    dateOfIssue = json['date_of_issue'];
    status = json['status'];
    addedonDate = json['addedon_date'];
    addedonTime = json['addedon_time'];
    updatedonDate = json['updatedon_date'];
    updatedonTime = json['updatedon_time'];
    entryDate = json['entry_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['money_user_id'] = this.moneyUserId;
    data['prepared_for'] = this.preparedFor;
    data['batch_id'] = this.batchId;
    data['report_id'] = this.reportId;
    data['date_of_request'] = this.dateOfRequest;
    data['date_of_issue'] = this.dateOfIssue;
    data['status'] = this.status;
    data['addedon_date'] = this.addedonDate;
    data['addedon_time'] = this.addedonTime;
    data['updatedon_date'] = this.updatedonDate;
    data['updatedon_time'] = this.updatedonTime;
    data['entry_date'] = this.entryDate;
    return data;
  }
}
