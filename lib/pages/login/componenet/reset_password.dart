import 'package:flutter/material.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/pages/login/componenet/reset_password_view_model.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:stacked/stacked.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResetPasswordViewModel>.reactive(
      viewModelBuilder: () => ResetPasswordViewModel(),
      builder: (_, model, child) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 20, bottom: 5, left: 15, right: 15),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "RESET PASSWORD ",
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
                                text:
                                    'Password Must have Minimum 5 Alpanumeric Characters'),
                            // new TextSpan(
                            //     text: "After OTP verification you can update your password",
                            //     style: new TextStyle(
                            //         fontWeight: FontWeight.normal,
                            //         color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    AppTextFeildOutlineWidget(
                      controller: model.passwordController,
                      hintText: "Password",
                      obscureText: model.hidePassword,
                      fillColor: AppColors.white,
                      textInputType: TextInputType.emailAddress,
                      //onChanged: model.onChanged,
                      suffix: IconButton(
                          icon: Icon((model.hidePassword)
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            model.showHidePassword();
                          }),
                    ),
                    SizedBox(height: 20),
                    AppTextFeildOutlineWidget(
                      controller: model.confirmPasswordTextController,
                      hintText: "Confirm Password",
                      obscureText: model.hideConfirmPassword,
                      fillColor: AppColors.white,
                      textInputType: TextInputType.emailAddress,
                      //onChanged: model.onChanged,
                      suffix: IconButton(
                          icon: Icon((model.hideConfirmPassword)
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            model.showConfirmHidePassword();
                          }),
                    ),

                    Visibility(
                      visible: model.formError,
                      child: Column(
                       children: [
                         SizedBox(height: 10),
                         Text("Please enter valid password",style: TextStyle(color: Colors.red),)
                       ], 
                      ),
                    ),
                    SizedBox(height: 40),
                    FlatButton(
                        onPressed: () {
                          model.submitClicked();
                        },
                        textColor: Colors.white,
                        color: AppColors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text('SUBMIT')),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
