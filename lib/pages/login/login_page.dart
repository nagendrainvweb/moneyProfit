import 'package:flutter/material.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/pages/forgot_password/forgotPassword.dart';
import 'package:moneypros/pages/login/componenet/reset_password.dart';
import 'package:moneypros/pages/login/login_viewmodel.dart';
import 'package:moneypros/pages/otp/otp_page.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (_, model, child) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            model.skipClicked();
          },
          label: Text(
            "SKIP >",
            style: TextStyle(
                color: AppColors.blackLight,
                decoration: TextDecoration.underline),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
          child: Center(
            child: ListView(
              //mainAxisSize: MainAxisSize.min,
              shrinkWrap: true,
              children: [
                AppTextFeildOutlineWidget(
                  controller: model.emailController,
                  hintText: "Email address",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.emailAddress,
                  onChanged: model.setEmail,
                ),
                SizedBox(height: 20),
                AppTextFeildOutlineWidget(
                  controller: model.passwordController,
                  obscureText: model.hidePassword,
                  hintText: "Password",
                  onChanged: model.setPassword,
                  fillColor: AppColors.white,
                  suffix: IconButton(
                      icon: Icon((model.hidePassword)
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        model.showHidePassword();
                      }),
                ),
                SizedBox(height: 20),
                AppButtonWidget(
                  text: "LOGIN",
                  // width: MediaQuery.of(context).size.width * 0.5,
                  onPressed: model.validForm
                      ? () {
                          model.loginClicked();
                        }
                      : null,
                ),
                SizedBox(
                  height: 20,
                ),
                AppButtonWidget(
                  text: "Don't have account? Sign up",
                  // width: MediaQuery.of(context).size.width * 0.5,
                  onPressed: () {
                    model.signupClicked();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                    onPressed: () {
                      _showMobileNumberSheet();
                    },
                    child: Text("Forgot Password ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.blackText)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showMobileNumberSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (_) => ForgotPasswordWidget(
              onNumberValidateSucess: _onNumberValidationDone,
            ));
  }

  _onNumberValidationDone(String number) async {
    myPrint("number is $number");
    final value = await _showOtpSheet(number);
    if (value) {
      _showResetPasswordSheet();
    }
  }

  _showResetPasswordSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (_) => ResetPassword());
  }

  _showOtpSheet(String number) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (_) => OtpWidget(
              number: number,
            ));
  }
}
