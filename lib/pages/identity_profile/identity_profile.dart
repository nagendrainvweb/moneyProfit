import 'package:flutter/material.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/app_widegt/app_neumorpic_text_feild.dart';
import 'package:moneypros/app_widegt/app_profile_heading.dart';
import 'package:moneypros/pages/profile_details/profile_details_view_model.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class IdentityProfile extends StatefulWidget {
  final bool editable;
  final String from;

  const IdentityProfile({Key key, this.editable = true, this.from}) : super(key: key);
  @override
  _IdentityProfileState createState() => _IdentityProfileState();
}

class _IdentityProfileState extends State<IdentityProfile> {
  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepo>(context);
    return ViewModelBuilder<ProfileEditViewModel>.reactive(
      viewModelBuilder: () => ProfileEditViewModel(),
      onModelReady: (ProfileEditViewModel model) {
        model.initIdentitiy(userRepo, widget.editable,widget.from);
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
           actions: [
            Visibility(
              visible: !model.identityEditable,
              child: TextButton(
                  onPressed: () {
                    model.setIdentityEditable(true);
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(color: AppColors.green),
                  )),
            )
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppProfileHeading(
                  text1: "Identity",
                  text2: "Details",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.bigMargin,
                      vertical: Spacing.mediumMargin),
                  child: Text(
                    "* One of the field is mandatory from below document fields.",
                    style: TextStyle(
                        color: AppColors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                //SizedBox(height: 12),
                AppTextFeildOutlineWidget(
                  controller: model.panController,
                  hintText: "PAN Card Number *",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.emailAddress,
                  enabled: model.identityEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                //SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.drivingController,
                  hintText: "Driving License Number *",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.name,
                  enabled: model.identityEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                //SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.voterController,
                  hintText: "Voter ID Number *",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                  enabled: model.identityEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                //SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.passportController,
                  hintText: "Passport Number *",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.name,
                  enabled: model.identityEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                // SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.rationController,
                  hintText: "Ration Card Number *",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.name,
                  enabled: model.identityEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                //SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.aadharController,
                  hintText: "Aadhar UID Number *",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.number,
                  enabled: model.identityEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                SizedBox(height: 15),
                Visibility(
                  visible: model.identityEditable,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.defaultMargin),
                    child: AppButtonWidget(
                      text: "Update Identity Details",
                      width: double.maxFinite,

                      onPressed: () {
                        model.onIdentityClicked();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
