class SubscriptionData {
  String id;
  String name;
  String price;
  String duration;
  String benefitsPoint;
  String status;
  String addedby;
  String addedonDate;
  String addedonTime;
  String modifiedby;
  String modifiedonDate;
  String modifiedonTime;
  List<String> benifitList;

  SubscriptionData(
      {this.id,
      this.name,
      this.price,
      this.duration,
      this.benefitsPoint,
      this.status,
      this.addedby,
      this.addedonDate,
      this.addedonTime,
      this.modifiedby,
      this.modifiedonDate,
      this.modifiedonTime});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      price = json['price'];
      duration = json['duration'];
      benefitsPoint = json['benefits_point'];
      status = json['status'];
      addedby = json['addedby'];
      addedonDate = json['addedon_date'];
      addedonTime = json['addedon_time'];
      modifiedby = json['modifiedby'];
      modifiedonDate = json['modifiedon_date'];
      modifiedonTime = json['modifiedon_time'];
      benifitList = benefitsPoint.split("||");
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['benefits_point'] = this.benefitsPoint;
    data['status'] = this.status;
    data['addedby'] = this.addedby;
    data['addedon_date'] = this.addedonDate;
    data['addedon_time'] = this.addedonTime;
    data['modifiedby'] = this.modifiedby;
    data['modifiedon_date'] = this.modifiedonDate;
    data['modifiedon_time'] = this.modifiedonTime;
    return data;
  }
}
