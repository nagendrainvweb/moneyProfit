import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/app_widegt/app_neumorpic_text_feild.dart';
import 'package:moneypros/model/login_data.dart';
import 'package:moneypros/pages/basic_profile/basic_info_page.dart';
import 'package:moneypros/pages/forgot_password/forgotPassword.dart';
import 'package:moneypros/pages/login/componenet/reset_password.dart';
import 'package:moneypros/pages/login/login_viewmodel.dart';
import 'package:moneypros/pages/otp/otp_page.dart';
import 'package:moneypros/pages/subscription/subscription_page.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class LoginPage extends StatefulWidget {
  final bool showClose;

  const LoginPage({Key key, this.showClose = false}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepo>(context,listen: false);
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) {
        model.checkUpdate(context);
        model.initData(userRepo);
        model.notificationToken();
      },
      builder: (_, model, child) => Scaffold(
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        appBar: AppBar(
          toolbarHeight: (widget.showClose) ? kToolbarHeight : 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
        ),
        body: Container(
          // padding: const EdgeInsets.symmetric(
          //     horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
          child: Center(
            child: ListView(
              //mainAxisSize: MainAxisSize.min,
              shrinkWrap: true,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15,
                      vertical: Spacing.defaultMargin),
                  child: SvgPicture.asset(ImageAsset.moneyProsLogo),
                ),
                // SizedBox(height:20),
                AppTextFeildOutlineWidget(
                  controller: model.emailController,
                  hintText: "Mobile Number",
                  fillColor: AppColors.white,
                  //textAlign: TextAlign.center,
                  textInputType: TextInputType.emailAddress,
                  //removeLeftContentPadding: true,
                  onChanged: model.setEmail,
                  onSubmit: (e) {},
                ),
                // SizedBox(height: 20),
                AppTextFeildOutlineWidget(
                  controller: model.passwordController,
                  obscureText: model.hidePassword,
                  hintText: "Password",
                  //textAlign: TextAlign.center,
                  onChanged: model.setPassword,
                  //leftPadding: 50.0,
                  onSubmit: (e) {},
                  //removeLeftContentPadding: true,
                  fillColor: AppColors.white,
                  suffix: IconButton(
                      icon: Icon((model.hidePassword)
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        model.showHidePassword();
                      }),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.bigMargin,
                  ),
                  child: AppButtonWidget(
                      text: "Login",
                      // width: MediaQuery.of(context).size.width * 0.5,
                      onPressed: () {
                        if (model.validForm) {
                          model.loginClicked(context);
                        } else {
                          model.showSnackBar(
                              "Please provide valid Username & Password");
                        }
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.bigMargin,
                  ),
                  child: AppButtonWidget(
                    text: "Don't have account? Sign up",
                    // width: MediaQuery.of(context).size.width * 0.5,
                    onPressed: () {
                      model.signupClicked();
                      //Utility.pushToNext(SubscriptionPage(), context);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      _showMobileNumberSheet(model);
                    },
                    child: Text("Forgot Password ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.grey600))),

                SizedBox(height: 10),
                Visibility(
                  visible: !widget.showClose,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          model.skipClicked();
                        },
                        label: Text(
                          "SKIP",
                          style: TextStyle(
                            color: AppColors.grey600,
                          ),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showMobileNumberSheet(LoginViewModel model) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (_) =>
            ForgotPasswordWidget(onNumberValidateSucess: (String number) {
              _onNumberValidationDone(number, model);
            }));
  }

  _onNumberValidationDone(String number, LoginViewModel model) async {
    myPrint("number is $number");
    final data = await model.validateNumberOnServer(number);
    if (data != null) {
      final value = await _showOtpSheet(number);
      if (value) {
        _showResetPasswordSheet(data.userdetails, model);
      }
    }
    // final value = await _showOtpSheet(number);
    // if (value) {
    //   _showResetPasswordSheet();
    // }
  }

  _showResetPasswordSheet(Userdetails userdetails, LoginViewModel model) async {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (_) => ResetPassword(
              onResetPasswordClicked: (String password) {
                model.resetPassword(userdetails, password);
              },
            ));
  }

  _showOtpSheet(String number) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OtpWidget(
              number: number,
              type: "2",
            ));
  }
}
