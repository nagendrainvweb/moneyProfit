class NotificationData {
  String id;
  String title;
  String content;
  String addOn;
  String firebaseStatus;
  String readUsers;
  String deletedUsers;

  NotificationData(
      {this.id,
      this.title,
      this.content,
      this.addOn,
      this.firebaseStatus,
      this.readUsers,
      this.deletedUsers});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    addOn = json['add_on'];
    firebaseStatus = json['firebase_status'];
    readUsers = json['read_users'];
    deletedUsers = json['deleted_users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['add_on'] = this.addOn;
    data['firebase_status'] = this.firebaseStatus;
    data['read_users'] = this.readUsers;
    data['deleted_users'] = this.deletedUsers;
    return data;
  }
}
