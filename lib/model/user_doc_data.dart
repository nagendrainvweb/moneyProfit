class UserDocData {
  String id;
  String userId;
  String documentType;
  String documentImage;
  String addedonDate;
  String addedonTime;

  UserDocData(
      {this.id,
      this.userId,
      this.documentType,
      this.documentImage,
      this.addedonDate,
      this.addedonTime});

  UserDocData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    documentType = json['document_type'];
    documentImage = json['document_image'];
    addedonDate = json['addedon_date'];
    addedonTime = json['addedon_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['document_type'] = this.documentType;
    data['document_image'] = this.documentImage;
    data['addedon_date'] = this.addedonDate;
    data['addedon_time'] = this.addedonTime;
    return data;
  }
}
