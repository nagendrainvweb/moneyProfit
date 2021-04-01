import 'package:flutter/material.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/app_widegt/app_neumorpic_text_feild.dart';
import 'package:moneypros/pages/forgot_password/forgot_password_view_model.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordWidget extends StatefulWidget {
  final Function onNumberValidateSucess;

  const ForgotPasswordWidget({Key key, this.onNumberValidateSucess})
      : super(key: key);
  @override
  _ForgotPasswordWidgetState createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordViewModel(),
      builder: (_, model, child) => Container(
        height: MediaQuery.of(context).size.height / 2 +
                MediaQuery.of(context).viewInsets.bottom,
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
                      "",
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
              // Divider(
              //   color: AppColors.blackLight,
              // ),
              Container(
               // padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                    'Please Enter Your Registered Mobile Number'),
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
                      controller: model.numberController,
                      hintText: "Mobile Number",
                      fillColor: AppColors.white,
                      errorText: (model.numberError)
                          ? "Please enter valid number"
                          : null,
                      textInputType: TextInputType.name,
                      onChanged: model.onNumberChanged,
                      onSubmit: (value) {
                        if (model.numberController.text.isNotEmpty &&
                            !model.numberError) {
                          model.goBack();
                          widget.onNumberValidateSucess(
                              model.numberController.text);
                        }else{
                          
                        }
                      },
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: FlatButton(
                          onPressed: () {
                            if (model.numberController.text.isNotEmpty &&
                                !model.numberError) {
                                  model.goBack();
                              widget.onNumberValidateSucess(
                                  model.numberController.text);
                            }
                          },
                          textColor: Colors.white,
                          color: AppColors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Text('Send OTP')),
                    ),
                    SizedBox(height: 20),
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
