import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/app_widegt/app_neumorpic_text_feild.dart';
import 'package:moneypros/pages/otp/otp_page.dart';
import 'package:moneypros/pages/otp/otp_view_model.dart';
import 'package:moneypros/pages/register/register_viewmodel.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepo>(context, listen: false);
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(),
      onModelReady: (model) {
        model.initData(userRepo);
      },
      builder: (_, model, child) => Scaffold(
        backgroundColor: AppColors.tileColor,
        appBar: PreferredSize(
            child: AppBar(
              brightness: Brightness.light,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                "Register",
                style: TextStyle(color: AppColors.blackLight),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: AppColors.blackLight,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            preferredSize: Size.fromHeight(45)),
        body: Container(
          // padding: const EdgeInsets.symmetric(
          //     horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15,
                    vertical: Spacing.smallMargin),
                child: SvgPicture.asset(ImageAsset.moneyProsLogo),
              ),
              AppTextFeildOutlineWidget(
                controller: model.firstNameController,
                hintText: "First Name",
                fillColor: AppColors.white,
                textInputType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                onChanged: model.onChanged,
              ),
              // SizedBox(height: 20),
              AppTextFeildOutlineWidget(
                controller: model.lastNameController,
                hintText: "Last Name",
                fillColor: AppColors.white,
                textCapitalization: TextCapitalization.sentences,
                textInputType: TextInputType.name,
                onChanged: model.onChanged,
              ),
              //SizedBox(height: 20),
              AppTextFeildOutlineWidget(
                controller: model.emailController,
                hintText: "Email address",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
              ),
              //SizedBox(height: 20),
              AppTextFeildOutlineWidget(
                controller: model.numberController,
                hintText: "Mobile Number",
                fillColor: AppColors.white,
                textInputType: TextInputType.number,
                onChanged: model.onChanged,
              ),
              //SizedBox(height: 20),
              AppTextFeildOutlineWidget(
                controller: model.passwordController,
                hintText: "Password",
                obscureText: model.hidePassword,
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                suffix: IconButton(
                    icon: Icon((model.hidePassword)
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      model.showHidePassword();
                    }),
              ),
              //SizedBox(height: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                child: Text(
                  "(required minimum 5 alpanumeric characters)",
                  textScaleFactor: 0.9,
                  style: TextStyle(color: AppColors.green),
                ),
              ),
              SizedBox(height: 8),
              AppTextFeildOutlineWidget(
                controller: model.confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: model.hideConfirmPassword,
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                suffix: IconButton(
                    icon: Icon((model.hideConfirmPassword)
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      model.showConfirmHidePassword();
                    }),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.bigMargin,
                ),
                child: AppButtonWidget(
                    text: "REGISTER",
                    // width: MediaQuery.of(context).size.width * 0.5,
                    onPressed: () async {
                      if (model.validForm) {
                        final validUser = await model.verifyUser();
                        if (validUser) {
                          final value =
                              await _showOtpSheet(model.numberController.text);
                          if (value) {
                            model.registerUser(context);
                          }
                        }
                        //   final value =
                        //       await _showOtpSheet(model.numberController.text);
                        //   if (value) {
                        //     model.registerUser();
                        //   } else {}
                        // } else {
                        //   model.showFormError();
                      } else {
                        model.showFormError();
                      }
                      // model.registerClicked();
                    }),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  _showOtpSheet(String number) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => Container(
              child: OtpWidget(
                number: number,
              ),
            ));
  }
}
