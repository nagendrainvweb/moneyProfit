class ReferalResponse {
  String discountPrice;
  String amountWithDiscount;
  String totalAmount;
  String referralCode;

  ReferalResponse(
      {this.discountPrice,
      this.amountWithDiscount,
      this.totalAmount,
      this.referralCode});

  ReferalResponse.fromJson(Map<String, dynamic> json) {
    discountPrice = json['discount_price'].toString();
    amountWithDiscount = json['amount_with_discount'].toString();
    totalAmount = json['total_amount'].toString();
    referralCode = json['referral_code'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount_price'] = this.discountPrice;
    data['amount_with_discount'] = this.amountWithDiscount;
    data['total_amount'] = this.totalAmount;
    data['referral_code'] = this.referralCode;
    return data;
  }
}
