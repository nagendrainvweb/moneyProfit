import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/pages/otp/otp_view_model.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class OtpWidget extends StatefulWidget {
  final number;
  final type;

  const OtpWidget({Key key, this.number,@required this.type}) : super(key: key);
  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OtpViewModel>.reactive(
        viewModelBuilder: () => OtpViewModel(),
        onModelReady: (model) {
          model.initData(widget.number,widget.type);
          model.sendOtp();
        },
        builder: (_, model, child) => Container(
              height: MediaQuery.of(context).size.height / 2 +
                  MediaQuery.of(context).viewInsets.bottom,
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 5, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Expanded(
                          //     child: Text(
                          //   "VERIFY OTP ",
                          //   style: TextStyle(color: AppColors.blackLight),
                          // )),
                          GestureDetector(
                            onTap: () {
                              model.goBack();
                            },
                            child: Icon(
                              Icons.close,
                              color: AppColors.grey600,
                            ),
                          )
                        ],
                      ),
                    ),
                    // Divider(
                    //   color: AppColors.blackLight,
                    // ),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                          color: AppColors.orange)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                              child: Neumorphic(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: Spacing.mediumMargin,
                                      vertical: Spacing.mediumMargin),
                                  style: NeumorphicStyle(
                                      color: AppColors.white,
                                      intensity: 0.4,
                                      surfaceIntensity: 0.25,
                                      border: NeumorphicBorder(isEnabled: true),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(8))),
                                  child: Container(
                                      width: double.maxFinite,
                                      // padding:EdgeInsets.symmetric(
                                      //     horizontal: 60,
                                      //     ),
                                      child: Center(
                                          child: OtpTextFeildWidget())))),
                          SizedBox(height: 20),
                          (model.isLoading)
                              ? Center(child: CircularProgressIndicator())
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.mediumMargin,
                                  ),
                                  child: AppButtonWidget(
                                    text: "VERIFY OTP",
                                    width: double.maxFinite,
                                    isBig: false,
                                    color: AppColors.blue,
                                    onPressed: () {
                                      model.otpSubmitPressed();
                                    },
                                  ),
                                ),
                          // Center(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //     children: <Widget>[
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          //     (!model.isLoading)
                          //         ? FlatButton(
                          //             onPressed: () {
                          //               model.otpSubmitPressed();
                          //             },
                          //             textColor: Colors.white,
                          //             color: AppColors.orange,
                          //             shape: RoundedRectangleBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(6)),
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 20, vertical: 12),
                          //             child: Text('SUBMIT'))
                          //         : CircularProgressIndicator(),
                          //   ],
                          // ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          (model.timer != 0)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Spacing.defaultMargin),
                                      child: Text(
                                        'Resend OTP code after ${model.timer} sec',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.grey600),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          model.sendOtp();
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            // Icon(
                                            //   Icons.refresh,
                                            //   color: AppColors.grey600,
                                            //   size: 18,
                                            // ),
                                            // SizedBox(width: 5),
                                            Text("Resend"),
                                          ],
                                        ),
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //         BorderRadius.circular(5)),
                                        textColor: AppColors.grey600),
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
      width: 200,
      child: PinCodeTextField(
        length: 6,
        controller: model.otpController,
        obscureText: false,
        animationType: AnimationType.fade,
        textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        backgroundColor: Colors.transparent,
        pinTheme: PinTheme(
            // shape: PinCodeFieldShape.underline,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 40,
            fieldWidth: 30,
            inactiveFillColor: Colors.transparent,
            activeFillColor: Colors.transparent,
            inactiveColor: AppColors.grey400,
            activeColor: AppColors.grey400,
            selectedFillColor: Colors.transparent,
            borderWidth: 1),
        animationDuration: Duration(milliseconds: 300),
        //rbackgroundColor: Colors.blue.shade50,
        enableActiveFill: true,
        // errorAnimationController: errorController,
        // controller: textEditingController,
        onCompleted: (v) {
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
        appContext: context,
      ),
      // TextField(
      //   controller: model.otpController,
      //   keyboardType: TextInputType.number,
      //   onChanged: (value) {
      //     model.setOtp(value);
      //     if (value.length == 6) {
      //       FocusScope.of(context).requestFocus(FocusNode());
      //     }
      //   },
      //   decoration: InputDecoration(
      //     labelText: "Enter OTP",
      //     errorText: (model.isOtpError) ? "Enter valid OTP" : null,
      //     border: OutlineInputBorder(),
      //   ),
      // ),
    );
  }
}
