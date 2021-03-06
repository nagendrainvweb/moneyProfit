import 'package:flutter/material.dart';
import 'package:moneypros/pages/otp/otp_view_model.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class OtpWidget extends StatefulWidget {
  final number;

  const OtpWidget({Key key, this.number}) : super(key: key);
  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OtpViewModel>.reactive(
        viewModelBuilder: () => OtpViewModel(),
        onModelReady: (model) {
          model.initData(widget.number);
          model.sendOtp();
        },
        builder: (_, model, child) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 5, left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "VERIFY OTP ",
                            style: TextStyle(color: AppColors.blackLight),
                          )),
                          GestureDetector(
                            onTap: () {
                              model.goBack();
                            },
                            child: Icon(
                              Icons.close,
                              color: AppColors.blackLight,
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.blackLight,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                    //letterSpacing: 0.6,
                                    fontSize: 15,
                                    color: Colors.grey.shade700),
                                //text: 'can',
                                children: <TextSpan>[
                                  new TextSpan(
                                      text: 'Enter below OTP Sent to '),
                                  new TextSpan(
                                      text: "+91${model.mobile}",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                OtpTextFeildWidget(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    (!model.isLoading)
                                        ? FlatButton(
                                            onPressed: () {
                                              model.otpSubmitPressed();
                                            },
                                            textColor: Colors.white,
                                            color: AppColors.orange,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                            child: Text('SUBMIT'))
                                        : CircularProgressIndicator(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          (model.timer != 0)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Resend OTP code after ${model.timer} sec',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.blackLight),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          model.sendOtp();
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.refresh,
                                              color: AppColors.orange,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Text("Resend"),
                                          ],
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        textColor: AppColors.orange),
                                  ],
                                ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

class OtpTextFeildWidget extends HookViewModelWidget<OtpViewModel> {
  const OtpTextFeildWidget({
    Key key,
  }) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, OtpViewModel model) {
    return Container(
      width: 150,
      child: TextField(
        controller: model.otpController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          model.setOtp(value);
          if (value.length == 6) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        decoration: InputDecoration(
          labelText: "Enter OTP",
          errorText: (model.isOtpError) ? "Enter valid OTP" : null,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
