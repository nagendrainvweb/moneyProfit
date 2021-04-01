class PaymentData {
  ReturnElements returnElements;
  String paygPaymentUrl;

  PaymentData({this.returnElements, this.paygPaymentUrl});

  PaymentData.fromJson(Map<String, dynamic> json) {
    returnElements = json['return_elements'] != null
        ? new ReturnElements.fromJson(json['return_elements'])
        : null;
    paygPaymentUrl = json['payg_payment_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.returnElements != null) {
      data['return_elements'] = this.returnElements.toJson();
    }
    data['payg_payment_url'] = this.paygPaymentUrl;
    return data;
  }
}

class ReturnElements {
  String meId;
  String orderId;
  String txnDetails;
  String pgDetails;
  String cardDetails;
  String custDetails;
  String billDetails;
  String shipDetails;
  String itemDetails;
  String otherDetails;

  ReturnElements(
      {this.meId,
      this.orderId,
      this.txnDetails,
      this.pgDetails,
      this.cardDetails,
      this.custDetails,
      this.billDetails,
      this.shipDetails,
      this.itemDetails,
      this.otherDetails});

  ReturnElements.fromJson(Map<String, dynamic> json) {
    meId = json['me_id'];
    orderId = json['order_id'];
    txnDetails = json['txn_details'];
    pgDetails = json['pg_details'];
    cardDetails = json['card_details'];
    custDetails = json['cust_details'];
    billDetails = json['bill_details'];
    shipDetails = json['ship_details'];
    itemDetails = json['item_details'];
    otherDetails = json['other_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['me_id'] = this.meId;
    data['order_id'] = this.orderId;
    data['txn_details'] = this.txnDetails;
    data['pg_details'] = this.pgDetails;
    data['card_details'] = this.cardDetails;
    data['cust_details'] = this.custDetails;
    data['bill_details'] = this.billDetails;
    data['ship_details'] = this.shipDetails;
    data['item_details'] = this.itemDetails;
    data['other_details'] = this.otherDetails;
    return data;
  }
}
