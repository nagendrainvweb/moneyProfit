import 'package:flutter/material.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/pages/otp/otp_page.dart';
import 'package:moneypros/pages/otp/otp_view_model.dart';
import 'package:moneypros/pages/register/register_viewmodel.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(),
      builder: (_, model, child) => Scaffold(
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
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              AppTextFeildOutlineWidget(
                controller: model.firstNameController,
                hintText: "First Name",
                fillColor: AppColors.white,
                textInputType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                onChanged: model.onChanged,
              ),
              SizedBox(height: 20),
              AppTextFeildOutlineWidget(
                controller: model.lastNameController,
                hintText: "Last Name",
                fillColor: AppColors.white,
                textCapitalization: TextCapitalization.sentences,
                textInputType: TextInputType.name,
                onChanged: model.onChanged,
              ),
              SizedBox(height: 20),
              AppTextFeildOutlineWidget(
                controller: model.emailController,
                hintText: "Email address",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
              ),
              SizedBox(height: 20),
              AppTextFeildOutlineWidget(
                controller: model.numberController,
                hintText: "Mobile Number",
                fillColor: AppColors.white,
                textInputType: TextInputType.number,
                onChanged: model.onChanged,
              ),
              SizedBox(height: 20),
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
              Text(
                "(required minimum 5 alpanumeric characters)",
                textScaleFactor: 0.9,
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 40),
              AppButtonWidget(
                  text: "REGISTER",
                  // width: MediaQuery.of(context).size.width * 0.5,
                  onPressed: (model.validForm)
                      ? () async {
                          if (model.validForm) {
                            final value = await _showOtpSheet(
                                model.numberController.text);
                            if (value) {
                              model.registerUser();
                            } else {}
                          } else {
                            model.showFormError();
                          }
                          // model.registerClicked();
                        }
                      : null),
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
        builder: (_) => OtpWidget(
              number: number,
            ));
  }
}
