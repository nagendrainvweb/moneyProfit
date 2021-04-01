import 'package:flutter/material.dart';
import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app_regex/appRegex.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/dialog_helper.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPage createState() => _ContactUsPage();
}

class _ContactUsPage extends State<ContactUsPage> with AppHelper {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Contact Us",
        style: TextStyle(color: AppColors.blackGrey),
      )),
      body: Container(
          color: Colors.grey.shade100,
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _getHeading('MoneyPros Office'),
                  SizedBox(
                    height: 1.5,
                  ),
                  _getContactDetails,
                  //_getRegionalOffice,
                  SizedBox(
                    height: 8,
                  ),
                  _getHeading('Online Support'),
                  SizedBox(
                    height: 1.5,
                  ),
                  _getOnlineDetails,
                  // SizedBox(
                  //   height: 8,
                  // ),
                  // _getHeading('Connect to us'),
                  // SizedBox(
                  //   height: 1.5,
                  // ),
                  // _socialMediaView(),
                  SizedBox(
                    height: 24,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _showContactUsSheet();
                    },
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: AppColors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                    textColor: AppColors.white,
                    child: Text('Write us'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          )),
    );
  }

  _showContactUsSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) => ContactUsForm(
              onSubmitCliked: (name, email, number, desc) {
                //myPrint("$name and $number");
                _sendQuery(name, email, number, desc);
              },
            ));
  }

  _sendQuery(String name, String email, String number, String desc) async {
    try {
      showProgressDialogService("Please wait...");
      final response =
          await locator<ApiService>().sendQuery(name, email, number, desc);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
      } else {
        DialogHelper.showErrorDialog(context, "Error", response.message);
      }
    } catch (e) {
       hideProgressDialogService();
      DialogHelper.showErrorDialog(context, "Error", e.toString());
    }
  }

  //   _socialMediaView() {
  //   var size = 18.0;
  //   var color = Colors.grey[700];
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //     color: AppColors.white,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: <Widget>[
  //         IconButton(
  //           icon: Icon(
  //             Icons.youtube_play,
  //             size: size,
  //             color: color,
  //           ),
  //           onPressed: () {
  //             _launchURL(
  //                 'https://www.youtube.com/channel/UCfib-HxpT6c4pfziUopjWnA');
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(
  //             MyFlutterApp.twitter,
  //             size: size,
  //             color: color,
  //           ),
  //           onPressed: () {
  //             _launchURL('https://twitter.com/bikajifoodsbkn');
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(
  //             MyFlutterApp.facebook,
  //             size: size,
  //             color: color,
  //           ),
  //           onPressed: () {
  //             _launchURL('https://www.facebook.com/bikaji');
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(
  //             MyFlutterApp.instagram,
  //             size: size,
  //             color: color,
  //           ),
  //           onPressed: () {
  //             _launchURL('https://www.instagram.com/bikajifoods/');
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  get _getOnlineDetails {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.mail_outline,
                size: 14,
                color: Colors.grey.shade700,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _bottomCallSheet(
                              'Are you sure, you want to mail to info@moneypro-s.com ?',
                              'mailto:info@moneypro-s.com?subject=MoneyPros contact&body=New%20Text',
                              'MAIL');
                        });
                  },
                  child: Text('info@moneypro-s.com',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      )),
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: 12,
          // ),

          //Text('(11:00 AM - 6:00 PM, Mon-Sat Only)', style: smallTextStyle),
        ],
      ),
    );
  }

  Widget _getHeading(data) {
    return Container(
      color: AppColors.white,
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              data,
              style: TextStyle(
                  color: AppColors.blackGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  get _getContactDetails {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Text(
                  'Branch:',
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                onPressed: () async {
                  var mapSchema = 'geo:19.2187985,72.8634694';
                  if (await canLaunch(mapSchema)) {
                    await launch(mapSchema);
                  } else {
                    throw 'Could not launch $mapSchema';
                  }
                },
                icon: Icon(
                  Icons.directions_outlined,
                  color: AppColors.grey700,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Office No.14,\nBlueRose Industrial Estate,\nWestern Express Highway beside Metro Mall,\nBorivali East, Mumbai 400 066',
            style: TextStyle(
                color: Colors.grey.shade700, fontSize: 13, height: 1.5),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.phone,
                size: 14,
                color: Colors.grey.shade700,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _bottomCallSheet(
                              'Are you sure, you want to call to 022 2854-0366 ?',
                              'tel:022 2854-0366',
                              'CALL');
                        });
                  },
                  child: Text('022 2854-0366',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      )),
                ),
              ),
              // InkWell(
              //   onTap: () {},
              //   child: Container(
              //       padding: EdgeInsets.all(2),
              //       child: Icon(Icons.content_copy, color: AppColors.green, size: 16)),
              // ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.phone,
                size: 14,
                color: Colors.grey.shade700,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _bottomCallSheet(
                              'Are you sure, you want to call to 022 2854-0365 ?',
                              'tel:022 2854-0365',
                              'CALL');
                        });
                  },
                  child: Text('022 2854-0365',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.phone,
                size: 14,
                color: Colors.grey.shade700,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _bottomCallSheet(
                              'Are you sure, you want to call to 022 2854-0364 ?',
                              'tel:022 2854-0364',
                              'CALL');
                        });
                  },
                  child: Text('022 2854-0364',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      )),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  get _getRegionalOffice {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Regional Office:',
            style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Plot No. 39/40/41, Aroon Industrial Estate, Ramchandra Lane, Malad (West) Mumbai -400 064.India.',
            style: TextStyle(
                color: Colors.grey.shade700, fontSize: 13, height: 1.5),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.phone,
                size: 14,
                color: Colors.grey.shade700,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // _launchURL('tel:2228836701');
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _bottomCallSheet(
                              'Are you sure, you want to call to +91 2228836701 ?',
                              'tel:+91 2228836701',
                              'CALL');
                        });
                  },
                  child: Text('+91 2228836701',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      )),
                ),
              ),
              // InkWell(
              //   onTap: () {},
              //   child: Container(
              //       padding: EdgeInsets.all(2),
              //       child: Icon(Icons.content_copy, color: AppColors.green, size: 16)),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  _bottomCallSheet(var title, var text, buttonText) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.grey.shade400,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Colors.grey.shade300, width: 0.6))),
                      child: Text(
                        'CANCEL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      //_launchURL(text);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: Colors.grey.shade300, width: 0.6))),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        buttonText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ContactUsForm extends StatefulWidget {
  const ContactUsForm({
    Key key,
    this.onSubmitCliked,
  }) : super(key: key);
  final Function onSubmitCliked;

  @override
  _ContactUsFormState createState() => _ContactUsFormState();
}

class _ContactUsFormState extends State<ContactUsForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _descController = TextEditingController();
  bool _isNameError = false;
  bool _isEmailError = false;
  bool _isNumberError = false;
  bool _isDescError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    'Send us a note and we’ll get back to you as quickly as possible.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  )),
                  IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
            SizedBox(height: 20),
            _formData('Name', TextInputType.text, Icons.person_outline_outlined,
                _nameController, _isNameError, "Please enter valid first name"),
            SizedBox(height: 12),
            _formData('Email', TextInputType.emailAddress, Icons.email_outlined,
                _emailController, _isEmailError, "Please enter valid Email Id"),
            SizedBox(height: 12),
            _formData(
                'Mobile Number',
                TextInputType.number,
                Icons.person_outline_outlined,
                _numberController,
                _isNumberError,
                "Please enter valid Mobile Number"),
            SizedBox(height: 12),
            TextField(
              controller: _descController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              decoration: InputDecoration(
                  labelText: "What's on your mind?",
                  errorText: _isDescError ? "Please enter something" : null,
                  errorStyle: TextStyle(fontSize: 11, color: AppColors.green),
                  border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.grey700, width: 0.5)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.grey700, width: 0.5)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.green, width: 0.5)),
                  contentPadding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
                  icon: Container(
                      child: Text(
                    "abc",
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold),
                  ))),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    bool isValid = _validateForm();
                    if (isValid) {
                      Navigator.pop(context);
                      final name = _nameController.text;
                      final email = _emailController.text;
                      final number = _numberController.text;
                      final desc = _descController.text;
                      widget.onSubmitCliked(name, email, number, desc);
                      //_sendQuery();
                      // send details to server
                    }
                  },
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  color: AppColors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textColor: AppColors.white,
                  child: Text('SUBMIT'),
                ),
              ],
            ),
            SizedBox(height: 8),
            //),
          ],
        ),
      ),
    );
  }

  _validateForm() {
    setState(() {
      _isNameError = _nameController.text.isEmpty;
      _isEmailError =
          !RegExp(AppRegex.email_regex).hasMatch(_emailController.text);
      _isNumberError =
          !RegExp(AppRegex.mobile_regex).hasMatch(_numberController.text);
      _isDescError = _descController.text.isEmpty;
    });

    if (!_isNameError && !_isEmailError && !_isNumberError && !_isDescError) {
      return true;
    } else {
      return false;
    }
  }

  Widget _formData(
      var text, var type, var icons, var controller, var error, var errorText) {
    var style = TextStyle(fontSize: 13, color: Colors.grey.shade700);
    var errorStyle = TextStyle(fontSize: 11, color: AppColors.green);

    var textFeild = TextField(
        controller: controller,
        keyboardType: type,
        textAlign: TextAlign.start,
        style: style,
        decoration: InputDecoration(
          //hintText: text,
          errorText: error ? errorText : null,
          errorStyle: errorStyle,
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey700, width: 0.5)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey700, width: 0.5)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.green, width: 0.5)),
          labelText: text,
          contentPadding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
        ));
    return Container(
      child: Row(
        children: <Widget>[
          (text != 'Mobile Number')
              ? Icon(
                  icons,
                  color: Colors.grey.shade500,
                  size: (text == "Name") ? 18 : 20,
                )
              : Text(
                  '+91',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                ),
          SizedBox(
            width: (text == "Name") ? 17 : 15,
          ),
          Expanded(child: textFeild)
        ],
      ),
    );
  }
}
