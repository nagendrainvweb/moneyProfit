import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:intl/intl.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/pages/home/home_page.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:stacked_services/stacked_services.dart';

var smallTextStyle = TextStyle(
    fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey.shade700);

var extraSmallTextStyle = TextStyle(
    fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey.shade600);
var disabledTextStyle = TextStyle(
    fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey.shade500);

var enabledTextStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white);

var normalTextStyle = TextStyle(
    fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey.shade700);

var bigTextStyle = TextStyle(
    fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey.shade700);

var extraBigTextStyle = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700);

var toolbarStyle = TextStyle(fontSize: 16);
var addressStyle = TextStyle(
    color: CustomColor.kgreyTextColor, fontSize: 12, letterSpacing: 0.3);

var desciptionTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 11,
    height: 1.5,
    color: Colors.grey.shade600);

class CustomColor {
  static Color kwhiteColor = const Color(0xFFFFFFFF);
  static Color kredColor = Colors.red;
  static Color kgreyColor = Colors.grey.shade600;
  static Color kgreyBorderColor = Colors.grey.shade400;
  static Color kgreyTextColor = Colors.black87;
  static Color kgreenColor = Colors.green;
  static Color blackGrey = Color(0xff3c3c3c);
  static Color pink = Colors.pink;
}

final String NO_INTERNET_CONN = "No internet connection";
final String SOMETHING_WRONG_TEXT =
    "Something went wrong, sorry for inconvenience cause you, Please try after some time.";
myPrint(String text) {
  //print(text);
}

class CustomMargins {}

class AssetsName {
  static final NO_IMAGE = "assets/no_image.png";
}

class Utility {
  static getOneThirdWidth(BuildContext context) {
    return MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width * 0.3;
  }

  static Future<File> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 5,
    );
    return compressedFile;
  }

  static printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  static String getDocTypeForServer(String type) {
    String value = "";
    if (type == "Pan Card") {
      value = "Pancard";
    } else if (type == "Aadhar Card") {
      value = "AadharCard";
    } else if (type == "Driving license") {
      value = "Drivinglicense";
    } else if (type == "Voter Id") {
      value = "Voterid";
    } else if (type == "Passport") {
      value = "Passport";
    } else if (type == "Ration Card") {
      value = "Rationcard";
    } else {
      value = "Pancard";
    }
    return value;
  }

  static String getDocTypeForDevice(String type) {
    String value = "";
    if (type == "Pancard") {
      value = "Pan Card";
    } else if (type == "AadharCard") {
      value = "Aadhar Card";
    } else if (type == "Drivinglicense") {
      value = "Driving license";
    } else if (type == "Voterid") {
      value = "Voter Id";
    } else if (type == "Passport") {
      value = "Passport";
    } else if (type == "Rationcard") {
      value = "Ration Card";
    } else {
      value = "Pan Card";
    }
    return value;
  }

  static String getLoanTypeImagePath(String type) {
    String image = "";
    if (type.contains(AppStrings.creditCard)) {
      image = ImageAsset.creditCard;
    } else if (type.contains(AppStrings.housingLoan)) {
      image = ImageAsset.homeLoan;
    } else if (type.contains(AppStrings.personalLoan)) {
      image = ImageAsset.persoalLoan;
    } else if (type.contains(AppStrings.propertyLoan)) {
      image = ImageAsset.homeLoan;
    } else if (type.contains(AppStrings.autoLoan)) {
      image = ImageAsset.auto;
    } else if (type.contains(AppStrings.consumerLoan)) {
      image = ImageAsset.consumer;
    } else if (type.contains(AppStrings.businessLoan)) {
      image = ImageAsset.businessLoan;
    } else if (type.contains(AppStrings.twoWheelerLoan)) {
      image = ImageAsset.auto;
    } else if (type.contains(AppStrings.goldLoan)) {
      image = ImageAsset.goldLoan;
    } else if (type.contains(AppStrings.overdraft)) {
      image = ImageAsset.overdraft;
    } else {
      image = ImageAsset.homeLoan;
    }

    return image;
  }

  static String formatAmountToIndianCurrency(int amount) {
    var format = NumberFormat.currency(locale: 'HI');
    final data = format.format(amount);
    String value = data.replaceAll("INR", "");
    value = value.substring(0, value.lastIndexOf("."));
    //myPrint(format.format(amount)); //10,00,00,000.00
    return value;
  }

  static String loanDetailsType(String text) {
    final textList = text.split(" ");
    if (textList.length > 1) {
      String value = "";
      for (String s in textList) {
        if (value.isEmpty) {
          value = value + s[0].toLowerCase() + s.substring(1);
        } else {
          value = value + "_" + s[0].toLowerCase() + s.substring(1);
        }
      }
      return value;
    } else {
      return text[0].toLowerCase() + text.substring(1);
    }
  }

  static Future pushToNext(final page, BuildContext context) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => page,
          settings: RouteSettings(name: '${page.runtimeType}')),
    );
  }

  static showSnackBar(BuildContext context,String data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
  }

  static Future pushToDashboard(int position) async {
    final _navigationService = locator<NavigationService>();
    return await _navigationService.clearTillFirstAndShowView(HomePage(
      position: position,
    ));
  }

  static Future replaceWith(final page, BuildContext context) {
    return Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
          builder: (context) => page,
          settings: RouteSettings(name: '${page.runtimeType}')),
    );
  }

  static String formattedDeviceDate(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String formattedDeviceMonthDate(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String formattedServerDate(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static DateTime parseServerDate(String dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('yyyy-MM-dd').parse(dateTime);
  }

  static DateTime parseDeviceDate(String dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('dd/MM/yyyy').parse(dateTime);
  }

  static String moneyFormatter(String amount) {
    final formatCurrency =
        new NumberFormat.currency(locale: "en_US", symbol: "");
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return formatCurrency.format(amount);
  }

  final formatCurrency = new NumberFormat.simpleCurrency();

  static String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return "$age";
  }
}
