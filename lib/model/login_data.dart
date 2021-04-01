class LoginData {
  Userdetails userdetails;
  Subscription subscription;
  String accesstoken;
  Transaction transaction;

  LoginData({this.userdetails, this.subscription, this.accesstoken});

  LoginData.fromJson(Map<String, dynamic> json) {
    try {
      userdetails = json['userdetails'] != null
          ? new Userdetails.fromJson(json['userdetails'])
          : null;

      if (json['subscription'] is bool) {
      } else {
        subscription = json['subscription'] != null
            ? new Subscription.fromJson(json['subscription'])
            : null;
      }

      // subscription = json['subscription'];
      accesstoken = json['accesstoken'];
      transaction = json['transaction'] != null
          ? new Transaction.fromJson(json['transaction'])
          : null;
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userdetails != null) {
      data['userdetails'] = this.userdetails.toJson();
    }
    if (this.subscription != null) {
      data['subscription'] = this.subscription;
    }
    data['accesstoken'] = this.accesstoken;
    return data;
  }
}

class Userdetails {
  String id;
  String firstName;
  String middleName;
  String lastName;
  String username;
  String email;
  String mobile;
  String gender;
  String dob;
  String age;
  String maritalStatus;
  String pan;
  String drivingLicense;
  String voterId;
  String passport;
  String rationCard;
  String aadharUid;
  String fatherName;
  String spouseName;
  String motherName;
  String address;
  String village;
  String city;
  String state;
  String pincode;
  String country;
  String productId;
  String consent;
  String emailConfirmed;
  String mobileConfirmed;
  String referralCode;
  String txtPasswd;
  String encPasswd;
  String role;
  String status;
  String addedby;
  String addedonDate;
  String addedonTime;
  String modifiedby;
  String modifiedonDate;
  String modifiedonTime;
  String profileImage;
  String activationDatetime;

  Userdetails(
      {this.id,
      this.firstName,
      this.middleName,
      this.lastName,
      this.username,
      this.email,
      this.mobile,
      this.gender,
      this.dob,
      this.age,
      this.maritalStatus,
      this.pan,
      this.drivingLicense,
      this.voterId,
      this.passport,
      this.rationCard,
      this.profileImage,
      this.aadharUid,
      this.fatherName,
      this.spouseName,
      this.motherName,
      this.address,
      this.village,
      this.city,
      this.state,
      this.pincode,
      this.country,
      this.productId,
      this.consent,
      this.emailConfirmed,
      this.mobileConfirmed,
      this.referralCode,
      this.txtPasswd,
      this.encPasswd,
      this.role,
      this.status,
      this.addedby,
      this.addedonDate,
      this.addedonTime,
      this.modifiedby,
      this.modifiedonDate,
      this.modifiedonTime,
      this.activationDatetime});

  Userdetails.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      firstName = json['first_name']??"";
      middleName = json['middle_name']??"";
      lastName = json['last_name']??"";
      username = json['username']??"";
      email = json['email']??"";
      mobile = json['mobile']??"";
      gender = json['gender']??"";
      dob = json['dob']??"";
      age = json['age']??"";
      maritalStatus = json['marital_status']??"";
      pan = json['pan']??"";
      drivingLicense = json['driving_license']??"";
      voterId = json['voter_id']??"";
      passport = json['passport']??"";
      rationCard = json['ration_card']??"";
      aadharUid = json['aadhar_uid']??"";
      fatherName = json['father_name']??"";
      spouseName = json['spouse_name']??"";
      motherName = json['mother_name']??"";
      address = json['address']??"";
      village = json['village']??"";
      city = json['city']??"";
      state = json['state']??"";
      pincode = json['pincode']??"";
      country = json['country']??"";
      productId = json['product_id']??"";
      consent = json['consent']??"";
      emailConfirmed = json['email_confirmed'];
      mobileConfirmed = json['mobile_confirmed'];
      referralCode = json['referral_code'];
      txtPasswd = json['txt_passwd'];
      encPasswd = json['enc_passwd'];
      profileImage = json['profile_image']??"";
      role = json['role']??"";
      status = json['status']??"";
      addedby = json['addedby']??"";
      addedonDate = json['addedon_date']??"";
      addedonTime = json['addedon_time']??"";
      modifiedby = json['modifiedby']??"";
      modifiedonDate = json['modifiedon_date']??"";
      modifiedonTime = json['modifiedon_time']??"";
      activationDatetime = json['activation_datetime']??"";
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    //data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['marital_status'] = this.maritalStatus;
    data['pan'] = this.pan;
    data['driving_license'] = this.drivingLicense;
    data['voter_id'] = this.voterId;
    data['passport'] = this.passport;
    data['ration_card'] = this.rationCard;
    data['aadhar_uid'] = this.aadharUid;
    data['father_name'] = this.fatherName;
    data['spouse_name'] = this.spouseName;
    data['mother_name'] = this.motherName;
    data['address'] = this.address;
    data['village'] = this.village;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['country'] = this.country;
    data['product_id'] = this.productId;
    data['consent'] = this.consent;
    data['email_confirmed'] = this.emailConfirmed;
    data['mobile_confirmed'] = this.mobileConfirmed;
    data['referral_code'] = this.referralCode;
    data['role'] = this.role;
    data['status'] = this.status;
    return data;
  }
}

class Subscription {
  String id;
  String subscriptionId;
  String orderId;
  String userId;
  String amount;
  String channel;
  String agRef;
  String pgRef;
  String subscriptionDate;
  String subscriptionTime;
  String expiryDate;
  String expiryTime;
  String name;

  Subscription(
      {this.id,
      this.subscriptionId,
      this.orderId,
      this.userId,
      this.amount,
      this.channel,
      this.agRef,
      this.name,
      this.pgRef,
      this.subscriptionDate,
      this.subscriptionTime,
      this.expiryDate,
      this.expiryTime});

  Subscription.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      subscriptionId = json['subscription_id'];
      orderId = json['order_id'];
      userId = json['user_id'];
      amount = json['amount'];
      channel = json['channel'];
      agRef = json['ag_ref'];
      pgRef = json['pg_ref'];
      name = json["name"];
      subscriptionDate = json['subscription_date'];
      subscriptionTime = json['subscription_time'];
      expiryDate = json['expiry_date'];
      expiryTime = json['expiry_time'];
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subscription_id'] = this.subscriptionId;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['channel'] = this.channel;
    data['ag_ref'] = this.agRef;
    data['pg_ref'] = this.pgRef;
    data['subscription_date'] = this.subscriptionDate;
    data['subscription_time'] = this.subscriptionTime;
    data['expiry_date'] = this.expiryDate;
    data['expiry_time'] = this.expiryTime;
    return data;
  }
}

class Transaction {
  String id;
  String subscriptionId;
  String orderId;
  String userId;
  String userEmail;
  String userMobile;
  String amount;
  String channel;
  String transactionStatus;
  String agRef;
  String pgRef;
  String resMessage;
  String transactionDate;
  String transactionTime;
  String systemResponseDate;
  String systemResponseTime;
  String serverResponseDate;
  String serverResponseTime;

  Transaction(
      {this.id,
      this.subscriptionId,
      this.orderId,
      this.userId,
      this.userEmail,
      this.userMobile,
      this.amount,
      this.channel,
      this.transactionStatus,
      this.agRef,
      this.pgRef,
      this.resMessage,
      this.transactionDate,
      this.transactionTime,
      this.systemResponseDate,
      this.systemResponseTime,
      this.serverResponseDate,
      this.serverResponseTime});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionId = json['subscription_id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    userEmail = json['user_email'];
    userMobile = json['user_mobile'];
    amount = json['amount'];
    channel = json['channel'];
    transactionStatus = json['transaction_status'];
    agRef = json['ag_ref'];
    pgRef = json['pg_ref'];
    resMessage = json['res_message'];
    transactionDate = json['transaction_date'];
    transactionTime = json['transaction_time'];
    systemResponseDate = json['system_response_date'];
    systemResponseTime = json['system_response_time'];
    serverResponseDate = json['server_response_date'];
    serverResponseTime = json['server_response_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subscription_id'] = this.subscriptionId;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['user_email'] = this.userEmail;
    data['user_mobile'] = this.userMobile;
    data['amount'] = this.amount;
    data['channel'] = this.channel;
    data['transaction_status'] = this.transactionStatus;
    data['ag_ref'] = this.agRef;
    data['pg_ref'] = this.pgRef;
    data['res_message'] = this.resMessage;
    data['transaction_date'] = this.transactionDate;
    data['transaction_time'] = this.transactionTime;
    data['system_response_date'] = this.systemResponseDate;
    data['system_response_time'] = this.systemResponseTime;
    data['server_response_date'] = this.serverResponseDate;
    data['server_response_time'] = this.serverResponseTime;
    return data;
  }
}
