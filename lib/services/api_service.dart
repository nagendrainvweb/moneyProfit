import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:moneypros/model/basic_response.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/api_error_exception.dart';
import 'package:moneypros/utils/urlList.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<BasicResponse<String>> sendOtp(String mobile, String random) async {
    myPrint("inside fetchLogin method");
    final body = {
      "apikey": "${Constants.API_KEY}",
      "numbers": "${mobile}",
      "sender": "${Constants.OTP_SENDER_CODE}",
      "message": "Your OTP for MoneyPros mobile verification is ${random}",
    };

    myPrint(body.toString());
    try {
      final result = await http.post(UrlList.OTP_URL, body: body);
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
}
