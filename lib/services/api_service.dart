import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:moneypros/model/basic_response.dart';
import 'package:moneypros/model/city_data.dart';
import 'package:moneypros/model/crif_data.dart';
import 'package:moneypros/model/crif_history_date_data.dart';
import 'package:moneypros/model/dashboard_data.dart';
import 'package:moneypros/model/loan_data.dart';
import 'package:moneypros/model/login_data.dart';
import 'package:moneypros/model/notification_data.dart';
import 'package:moneypros/model/payment_data.dart';
import 'package:moneypros/model/referal_response.dart';
import 'package:moneypros/model/state_data.dart';
import 'package:moneypros/model/subscription_data.dart';
import 'package:moneypros/model/user_doc_data.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/api_error_exception.dart';
import 'package:moneypros/utils/urlList.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Future<BasicResponse<String>> sendOtp(String mobile, String random) async {
  //   myPrint("inside fetchLogin method");
  //   final body = {
  //     "apikey": "${Constants.API_KEY}",
  //     "numbers": "${mobile}",
  //     "sender": "${Constants.OTP_SENDER_CODE}",
  //     "message": "Your OTP for MoneyPros mobile verification is ${random}",
  //   };

  //   myPrint(body.toString());
  //   try {
  //     final result = await http.post(UrlList.OTP_URL, body: body);
  //     myPrint(result.body.toString());
  //     final response = json.decode(result.body);
  //     final basicResponse = BasicResponse<String>.fromJson(json: response);
  //     return basicResponse;
  //   } on SocketException catch (e) {
  //     throw ApiErrorException(NO_INTERNET_CONN);
  //   } on TimeoutException catch (e) {
  //     throw ApiErrorException(NO_INTERNET_CONN);
  //   } on Exception catch (e) {
  //     myPrint(e.toString());
  //     throw ApiErrorException(SOMETHING_WRONG_TEXT);
  //   }
  // }

  Future<BasicResponse<LoginData>> fetchLogin(
      String userName, String password) async {
    final commonFeilds = _getCommonFeild();
    final fcm = await Prefs.fcmToken;
    final body = {
      "username": userName,
      "password": password,
      "fcm_token": "$fcm"
    };
    body.addAll(commonFeilds);

    myPrint(body.toString());
    try {
      final result = await http.post(Uri.parse(UrlList.LOGIN), body: body);
      //myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<LoginData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        LoginData loginData = LoginData.fromJson(response[Constants.DATA]);
        basicResponse.data = loginData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> checkUpdate() async {
    final commonFeilds = _getCommonFeild();

    try {
      final result =
          await http.post(Uri.parse(UrlList.CHECK_UPDATE), body: commonFeilds);
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<String>.fromJson(json: response);
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> acessToken(String id) async {
    final commonFeilds = _getCommonFeild();
    final body = {
      "user_id": id,
    };
    body.addAll(commonFeilds);

    try {
      final result =
          await http.post(Uri.parse(UrlList.ACCESS_TOKEN), body: body);
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<String>.fromJson(json: response);
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> sendotp(
      String number, String otp, String type) async {
    final commonFeilds = _getCommonFeild();
    final body = {"mobile_number": number, "otp": otp, "type": "$type"};
    body.addAll(commonFeilds);
    myPrint(body.toString());
    try {
      final result = await http.post(Uri.parse(UrlList.SEND_OTP), body: body);
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<String>.fromJson(json: response);
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<LoginData>> verifyUser(String number) async {
    final commonFeilds = _getCommonFeild();
    final body = {
      "username": number,
    };
    body.addAll(commonFeilds);

    try {
      final result =
          await http.post(Uri.parse(UrlList.VERIFY_USER), body: body);
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<LoginData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        final data = response[Constants.DATA];
        LoginData loginData = LoginData.fromJson(data);
        basicResponse.data = loginData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> restPassowrd(
      String userId, String password) async {
    final commonFeilds = _getCommonFeild();
    final body = {
      "user_id": userId,
      "new_password": password,
    };
    body.addAll(commonFeilds);

    try {
      final result =
          await http.post(Uri.parse(UrlList.RESET_PASSWORD), body: body);
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<String>.fromJson(json: response);
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> validateRegistrationForm(
      String email, String number) async {
    final commonFeilds = _getCommonFeild();
    final body = {
      "email": email,
      "number": number,
    };
    body.addAll(commonFeilds);

    try {
      final result =
          await http.post(Uri.parse(UrlList.CHECK_REGISTERED_USER), body: body);
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<String>.fromJson(json: response);
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<ReferalResponse>> verifyReferalCode(
      String code, String subscriptionId) async {
    final commonFeilds = _getCommonFeild();
    final userId = await Prefs.userId;
    final body = {
      "user_id": userId,
      "subscription_id": subscriptionId,
      "referral_code": code,
    };
    body.addAll(commonFeilds);
    print("body is " + body.toString());

    try {
      final result = await http.post(Uri.parse(UrlList.verifyReferral),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      if (response["status"] == "success") {
        final basicResponse = BasicResponse<ReferalResponse>.fromJson(
            json: response, data: ReferalResponse.fromJson(response["data"]));
        return basicResponse;
      }
      throw ApiErrorException(response["message"]);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(e.toString());
    }
  }

  Future<BasicResponse<LoginData>> registerUser(String firstName,
      String lastname, String email, String number, String password) async {
    final commonFeilds = _getCommonFeild();
    final fcm = await Prefs.fcmToken;
    final body = {
      "first_name": firstName,
      "last_name": lastname,
      "email": email,
      "number": number,
      "password": password,
      "fcm_token": "$fcm",
    };
    body.addAll(commonFeilds);

    try {
      final result =
          await http.post(Uri.parse(UrlList.REGISTER_USER), body: body);
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<LoginData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        LoginData loginData = LoginData.fromJson(response[Constants.DATA]);
        basicResponse.data = loginData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<LoginData>> updatePersonalDetails(
      String userId,
      String firstName,
      String middleName,
      String lastname,
      String fathername,
      String mothername,
      String martialStatus,
      String spouseName,
      String dob,
      String age,
      String gender) async {
    final commonFeilds = _getCommonFeild();
    final body = {
      "user_id": userId,
      "first_name": firstName,
      "middle_name": middleName,
      "last_name": lastname,
      "father_name": fathername,
      "mother_name": mothername,
      "marital_status": martialStatus,
      "spouse_name": spouseName,
      "dob": dob,
      "age": age,
      "gender": gender,
    };
    body.addAll(commonFeilds);
    myPrint("body is ${body.toString()}");

    try {
      final result = await http.post(Uri.parse(UrlList.UPDATE_PERSONAL_DETAILS),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<LoginData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        LoginData loginData = LoginData.fromJson(response[Constants.DATA]);
        basicResponse.data = loginData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<LoginData>> updateIdentitiyDetails(
    String userId,
    String panCard,
    String drivingLicense,
    String voterId,
    String passport,
    String rationCard,
    String aadharId,
  ) async {
    final commonFeilds = _getCommonFeild();
    final body = {
      "user_id": userId,
      "pan_card": panCard,
      "driving_license": drivingLicense,
      "voter_id": voterId,
      "passport_no": passport,
      "ration_card_no": aadharId,
    };
    body.addAll(commonFeilds);

    try {
      final result = await http.post(
          Uri.parse(UrlList.UPDATE_IDENTITIY_DETAILS),
          body: body,
          headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<LoginData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        LoginData loginData = LoginData.fromJson(response[Constants.DATA]);
        basicResponse.data = loginData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<LoginData>> updateAddressDetails(
    String userId,
    String address,
    String village,
    String state,
    String city,
    String pincode,
    String country,
    String concent,
  ) async {
    final commonFeilds = _getCommonFeild();
    final body = {
      "user_id": userId,
      "address": address,
      "village_city": village,
      "state": state,
      "city": city,
      "pincode": pincode,
      "country": country,
      "consent": concent,
    };
    body.addAll(commonFeilds);
    try {
      final result = await http.post(Uri.parse(UrlList.UPDATE_ADDRESS_DETAILS),
          body: body, headers: await _getHeader());
      myPrint("result" + result.body);
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<LoginData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        LoginData loginData = LoginData.fromJson(response[Constants.DATA]);
        basicResponse.data = loginData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<LoginData>> userDetails() async {
    final commonFeilds = _getCommonFeild();
    final userId = await Prefs.userId;
    final body = {
      "user_id": userId,
    };
    body.addAll(commonFeilds);
    try {
      final result = await http.post(Uri.parse(UrlList.USER_DETAILS),
          body: body, headers: await _getHeader());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<LoginData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        LoginData data = LoginData.fromJson(response[Constants.DATA]);
        basicResponse.data = data;

        if (data.subscription != null) {
          Prefs.setSubscriptionDate(data.subscription.subscriptionDate);
          Prefs.setSubscriptionExpiryDate(data.subscription.expiryDate);
          final exprydate = data.subscription.expiryDate;
          final expiryDatetime = Utility.parseServerDate(exprydate);
          if (expiryDatetime.isAfter(DateTime.now())) {
            Prefs.setSubscription(true);
          } else {
            Prefs.setSubscription(false);
          }
        }
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<Userdetails>> updateProfilePic(String base64) async {
    final commonFeilds = _getCommonFeild();
    final userId = await Prefs.userId;
    final body = {
      "user_id": userId,
      "image": base64,
    };
    body.addAll(commonFeilds);
    try {
      final result = await http.post(Uri.parse(UrlList.UPDATE_PROFILE_PIC),
          body: body, headers: await _getHeader());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<Userdetails>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        Userdetails userData = Userdetails.fromJson(response[Constants.DATA]);
        basicResponse.data = userData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<CrifData>> crifData() async {
    final commonFeilds = _getCommonFeild();
    final userId = await Prefs.userId;
    final body = {
      "user_id": userId,
    };
    body.addAll(commonFeilds);
    try {
      final result = await http.post(Uri.parse(UrlList.CRIF_DATA),
          body: body, headers: await _getHeader());
      myPrint(result.body);
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<CrifData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        CrifData userData = CrifData.fromJson(response[Constants.DATA]);
        if (basicResponse.from != "crif") {
          Prefs.setCrifData(json.encode(response[Constants.DATA]));
        }
        basicResponse.data = userData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<CrifData>> crifStageTwo(String reportId, String orderId,
      String redirectURL, String answer) async {
    final commonFeilds = _getCommonFeild();
    final userId = await Prefs.userId;
    final body = {
      "user_id": "$userId",
      "reportId": "$reportId",
      "orderId": "$orderId",
      "redirectURL": "$redirectURL",
      "answer": "$answer",
    };
    body.addAll(commonFeilds);
    myPrint("body is ${body.toString()}");
    try {
      final result = await http.post(Uri.parse(UrlList.CRIF_STAGE_TWO),
          body: body, headers: await _getHeader());
      myPrint(result.body);
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<CrifData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        CrifData userData = CrifData.fromJson(response[Constants.DATA]);
        basicResponse.data = userData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<CrifData>> crifStageThree(
      String reportId, String orderId, String redirectURL) async {
    final commonFeilds = _getCommonFeild();
    final userId = await Prefs.userId;
    final body = {
      "user_id": "$userId",
      "reportId": "$reportId",
      "orderId": "$orderId",
      "redirectURL": "$redirectURL",
    };
    body.addAll(commonFeilds);
    myPrint("body is ${body.toString()}");
    try {
      final result = await http.post(Uri.parse(UrlList.CRIF_STAGE_THREE),
          body: body, headers: await _getHeader());
      myPrint(result.body);
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<CrifData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        CrifData userData = CrifData.fromJson(response[Constants.DATA]);
        Prefs.setCrifData(json.encode(response[Constants.DATA]));
        basicResponse.data = userData;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<List<StateData>>> stateList() async {
    try {
      final result = await http.get(
        Uri.parse(UrlList.STATE_LIST),
      );
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<List<StateData>>.fromJson(json: response);
      List<StateData> stateList = [];
      if (basicResponse.status == Constants.SUCCESS) {
        final list = response["data"];
        Prefs.setStateList(json.encode(list));
        for (var map in list) {
          stateList.add(StateData.fromJson(map));
        }
        basicResponse.data = stateList;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<List<SubscriptionData>>> subscriptionList() async {
    try {
      final commonFeilds = _getCommonFeild();
      final userId = await Prefs.userId;
      final body = {
        "user_id": "$userId",
      };
      body.addAll(commonFeilds);
      final result = await http.post(Uri.parse(UrlList.SUBSCRPTION),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<List<SubscriptionData>>.fromJson(json: response);
      List<SubscriptionData> subscriptionList = [];
      if (basicResponse.status == Constants.SUCCESS) {
        final list = response["data"];
        for (var map in list) {
          subscriptionList.add(SubscriptionData.fromJson(map));
        }
        basicResponse.data = subscriptionList;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<PaymentData>> initiatePayment(
      String email,
      String mobile,
      String amount,
      String code,
      String subscriptionId,
      String totalDiscount) async {
    try {
      final commonFeilds = _getCommonFeild();
      final userId = await Prefs.userId;
      final body = {
        "user_id": "$userId",
        "email_id": "$email",
        "smobile_no": "$mobile",
        "channel": "MOBILE",
        "amount": "$amount",
        "referral_code": "$code",
        "subscription_id": "$subscriptionId",
        "total_discount": "$totalDiscount",
      };
      body.addAll(commonFeilds);
      myPrint("initiatePayment body is " + body.toString());
      final result = await http.post(Uri.parse(UrlList.INTITAE_PAYMENT),
          body: body, headers: await _getHeader());
      myPrint("initiatePayment " + result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<PaymentData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        basicResponse.data = PaymentData.fromJson(response['data']);
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<LoanData>> loanDetails(String type) async {
    try {
      final body = {
        "type": "$type",
      };
      myPrint(body.toString());
      final result = await http.post(
        Uri.parse(UrlList.LOAN_DETAILS),
        body: body,
      );
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<LoanData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        basicResponse.data = LoanData.fromJson(response['data']);
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<DashboardData>> dashboardData() async {
    try {
      final result = await http.get(
        Uri.parse(UrlList.DASHBOARD_DETAILS),
      );
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<DashboardData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        basicResponse.data = DashboardData.fromJson(response['data']);
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<List<CrifHistoryDateData>>> crifHistoryDates() async {
    try {
      final commonFeilds = _getCommonFeild();
      final userId = await Prefs.userId;
      final body = {
        "user_id": "$userId",
      };
      body.addAll(commonFeilds);
      final result = await http.post(Uri.parse(UrlList.CRIF_HOSTORY_DATES),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<List<CrifHistoryDateData>>.fromJson(json: response);
      List<CrifHistoryDateData> dates = [];
      if (basicResponse.status == Constants.SUCCESS) {
        for (var map in response['data']) {
          dates.add(CrifHistoryDateData.fromJson(map));
        }
        basicResponse.data = dates;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<CrifData>> crifHistoryData(String date) async {
    try {
      final commonFeilds = _getCommonFeild();
      final userId = await Prefs.userId;
      final body = {"user_id": "$userId", "date_val": '$date'};
      body.addAll(commonFeilds);
      final result = await http.post(Uri.parse(UrlList.CRIF_HISTORY),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<CrifData>.fromJson(json: response);

      if (basicResponse.status == Constants.SUCCESS) {
        basicResponse.data = CrifData.fromJson(response['data']);
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<List<CityData>>> cityList() async {
    try {
      final result = await http.get(
        Uri.parse(UrlList.CITY_LIST),
      );
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<List<CityData>>.fromJson(json: response);
      List<CityData> cityList = [];
      if (basicResponse.status == Constants.SUCCESS) {
        final list = response["data"];
        Prefs.setCityList(json.encode(list));
        for (var map in list) {
          cityList.add(CityData.fromJson(map));
        }
        basicResponse.data = cityList;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<List<UserDocData>>> docList() async {
    try {
      final commonFeilds = _getCommonFeild();
      final userId = await Prefs.userId;
      final body = {
        "user_id": "$userId",
      };
      body.addAll(commonFeilds);
      final result = await http.post(Uri.parse(UrlList.USER_DOCUMENTS),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<List<UserDocData>>.fromJson(json: response);
      List<UserDocData> userDocList = [];
      if (basicResponse.status == Constants.SUCCESS) {
        if (response["data"] != null) {
          final list = response["data"];
          for (var map in list) {
            userDocList.add(UserDocData.fromJson(map));
          }
          basicResponse.data = userDocList;
        }
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<UserDocData>> fileUpload(File file, String type) async {
    //create multipart request for POST or PATCH method
    final user_id = await Prefs.userId;
    final token = await Prefs.token;
    final device = Constants.DEVICE;
    final appversion = Constants.VERSION;
    final header = {"authorization": "Bearer $token"};
    final uri = Uri.parse(UrlList.UPLOAD_DOCUMENT);
    var request = http.MultipartRequest(
      "POST",
      uri,
    );
    //add text fields
    request.fields[Constants.USERID] = user_id;
    request.fields[Constants.APP_VERSION] = appversion;
    request.fields[Constants.DEVICE] = device;
    request.fields["document_type"] = type;
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("document", file.path);
    //add multipart to request
    request.files.add(pic);
    request.headers.addAll(header);

    try {
      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);

      final responseJson = json.decode(responseString);
      final basicResponse =
          BasicResponse<UserDocData>.fromJson(json: responseJson);
      if (basicResponse.status == Constants.SUCCESS) {
        basicResponse.data = UserDocData.fromJson(responseJson['data'][0]);
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> deleteDocument(String id) async {
    try {
      final commonFeilds = _getCommonFeild();
      final userId = await Prefs.userId;
      final body = {
        "user_id": "$userId",
        "document_id": "$id",
      };
      body.addAll(commonFeilds);
      final result = await http.post(Uri.parse(UrlList.DELETE_DOCUMENT),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse = BasicResponse<String>.fromJson(json: response);
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<List<NotificationData>>> fetchNotification() async {
    final commonBody = _getCommonFeild();
    final user_id = await Prefs.userId;
    final token = await Prefs.token;
    final body = {
      Constants.USERID: "$user_id",
    };
    body.addAll(commonBody);
    myPrint(body.toString());
    try {
      final result = await http.post(Uri.parse(UrlList.NOTIFICATION),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<List<NotificationData>>.fromJson(json: response);
      final List<NotificationData> notificaionList = [];
      if (basicResponse.status == Constants.SUCCESS) {
        final list = response["data"];
        for (var map in list) {
          notificaionList.add(NotificationData.fromJson(map));
        }
        basicResponse.data = notificaionList;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> deleteNotification(
      String notificationId) async {
    final commonBody = _getCommonFeild();
    final user_id = await Prefs.userId;
    final token = await Prefs.token;
    final body = {
      Constants.USERID: "$user_id",
      Constants.NOTIFICATION_ID: "$notificationId"
    };
    body.addAll(commonBody);
    myPrint(body.toString());
    try {
      final result = await http.post(Uri.parse(UrlList.DELETE_NOTIFICATION),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<String>.fromJson(json: response, data: "");
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> markSeenNotification(
      String notificationId) async {
    final commonBody = _getCommonFeild();
    final user_id = await Prefs.userId;
    final token = await Prefs.token;
    final body = {
      Constants.USERID: "$user_id",
      Constants.NOTIFICATION_ID: "$notificationId"
    };
    body.addAll(commonBody);
    myPrint(body.toString());
    try {
      final result = await http.post(Uri.parse(UrlList.DELETE_NOTIFICATION),
          body: body, headers: await _getHeader());
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<String>.fromJson(json: response, data: "");
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> sendQuery(
      String name, String email, String mobileNo, String content) async {
    final commonBody = _getCommonFeild();
    final body = {
      //Constants.USERID: "$user_id",
      "first_name": "$name",
      "last_name": "",
      "mobile": "$mobileNo",
      "email": "$email",
      "message": "$content",
    };
    body.addAll(commonBody);
    myPrint(body.toString());
    try {
      final result = await http.post(Uri.parse(UrlList.EQUIRY), body: body);
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<String>.fromJson(json: response, data: "");
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on TimeoutException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      myPrint(e.toString());
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  // common fields like device and app version
  _getCommonFeild() {
    final device = Constants.DEVICE;
    final appversion = Constants.VERSION;

    final map = {
      Constants.APP_VERSION: appversion,
      Constants.URL_DEVICE: device
    };
    return map;
  }

  Future<Map<String, dynamic>> _getHeader() async {
    final token = await Prefs.token;
    final header = {"authorization": "Bearer $token"};
    return header;
  }
}
