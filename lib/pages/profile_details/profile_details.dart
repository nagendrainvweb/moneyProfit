import 'package:flutter/material.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/app_widegt/customBottomSelectorWidget.dart';
import 'package:moneypros/pages/profile_details/profile_details_view_model.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/font.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  _getBasicDetails(ProfileEditViewModel model) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.blue,
          // border: Border.on(color: AppColors.grey400, width: 1.0),
          borderRadius: BorderRadius.circular(6.0)),
      margin: const EdgeInsets.all(Spacing.smallMargin),
      child: ExpansionTile(
        initiallyExpanded: false,
        //backgroundColor: AppColors.blue,
        title: Text("Basic Details",
            style: TextStyle(fontSize: FontSize.title, color: AppColors.white)),
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey400, width: 1.0),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.all(Spacing.mediumMargin),
            child: Column(
              children: [
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.firstNameController,
                  hintText: "First Name *",
                  textCapitalization: TextCapitalization.words,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.middleNameController,
                  hintText: "Middle Name",
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.lastNameController,
                  hintText: " Last Name *",
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.fatherNameController,
                  hintText: "Father Name *",
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.motherNameController,
                  hintText: "Mother Name",
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.spouseNameController,
                  hintText: "Spouse Name *",
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.emailController,
                  hintText: "Email Address *",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.numberController,
                  hintText: "Mobile *",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showBottonSheet("Please Select Gender", model.genderList,
                        model.genderController.text, (index) {
                      model.genderController.text = model.genderList[index];
                    });
                  },
                  child: AppTextFeildOutlineWidget(
                    controller: model.genderController,
                    hintText: "Gender",
                    enableInteractiveSelection: false,
                    enabled: false,
                    fillColor: AppColors.white,
                    textInputType: TextInputType.name,
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showDatePicker(
                        onSetDate: model.setDOB,
                        selectedDate: model.dobController.text.isNotEmpty
                            ? Utility.parseDeviceDate(model.dobController.text)
                            : null);
                  },
                  child: AppTextFeildOutlineWidget(
                    controller: model.dobController,
                    hintText: "Date of Birth *",
                    fillColor: AppColors.white,
                    enableInteractiveSelection: false,
                    enabled: false,
                    textInputType: TextInputType.name,
                  ),
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.ageController,
                  hintText: "Age (in Years) *",
                  fillColor: AppColors.white,
                  enableInteractiveSelection: false,
                  enabled: false,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showBottonSheet(
                        "Please Select Marital Status",
                        model.martialStatusList,
                        model.marriedStatusController.text, (index) {
                      model.marriedStatusController.text =
                          model.martialStatusList[index];
                    });
                  },
                  child: AppTextFeildOutlineWidget(
                    controller: model.marriedStatusController,
                    hintText: "Marital Status",
                    fillColor: AppColors.white,
                    enableInteractiveSelection: false,
                    enabled: false,
                    textInputType: TextInputType.name,
                  ),
                ),
                SizedBox(height: 15),
                AppButtonWidget(
                  width: double.maxFinite,
                  text: "Update Basic Details",
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showDatePicker({Function onSetDate, DateTime selectedDate}) async {
    DateTime currentDate = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(1920),
      lastDate:
          DateTime(currentDate.year - 18, currentDate.month, currentDate.day),
      initialDate: selectedDate ??
          DateTime(currentDate.year - 18, currentDate.month, currentDate.day),
    );
    if (date != null) {
      print("date is ${date.day} + ${date.month} + ${date.year}");
      onSetDate(date);
    }
  }

  _showBottonSheet(String title, List<String> list, String selectedText,
      Function onItemClicked) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(Spacing.sheetRadius)
            ),
        builder: (_) => CustomSelectWidegt(
              title: title,
              list: list,
              selectedText: selectedText,
              onItemClicked: onItemClicked,
            ));
  }

  _getIdentityDetails(ProfileEditViewModel model) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.blue,
          //border: Border.all(color: AppColors.grey400, width: 1.0),
          borderRadius: BorderRadius.circular(6.0)),
      margin: const EdgeInsets.all(Spacing.smallMargin),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Text("Identity Details",
            style: TextStyle(fontSize: FontSize.title, color: AppColors.white)),
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey400, width: 1.0),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.all(Spacing.mediumMargin),
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  "** One of the field is mandatory from below document fields.",
                  style: TextStyle(
                      color: AppColors.blackLight, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                AppTextFeildOutlineWidget(
                  controller: model.panController,
                  hintText: "PAN Card Number **",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.drivingController,
                  hintText: "Driving License Number **",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.voterController,
                  hintText: "Voter ID Number **",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.passportController,
                  hintText: "Passport Number **",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.rationController,
                  hintText: "Ration Card Number **",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.aadharController,
                  hintText: "Aadhar UID Number **",
                  fillColor: AppColors.white,
                  textCapitalization: TextCapitalization.characters,
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 15),
                AppButtonWidget(
                  text: "Update Identity Details",
                  width: double.maxFinite,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getAddressDetails(ProfileEditViewModel model) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.blue,
          //border: Border.all(color: AppColors.grey400, width: 1.0),
          borderRadius: BorderRadius.circular(6.0)),
      margin: const EdgeInsets.all(Spacing.smallMargin),
      child: ExpansionTile(
        // childrenPadding: EdgeInsets.all(Spacing.mediumMargin),
        initiallyExpanded: false,
        title: Text("Address Details",
            style: TextStyle(fontSize: FontSize.title, color: AppColors.white)),
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey400, width: 1.0),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.all(Spacing.mediumMargin),
            child: Column(
              children: [
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.addressController,
                  hintText: "Address *",
                  maxLines: 2,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.multiline,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.villageController,
                  hintText: "Village *",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.countryController,
                  hintText: "Country *",
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.stateController,
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.cityController,
                  hintText: "City *",
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.pincodeController,
                  hintText: "Pin Code *",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 15),
                AppButtonWidget(
                  text: "Update Address Details",
                  width: double.maxFinite,
                  onPressed: () {
                    model.updateAddressClicked();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileEditViewModel>.reactive(
      viewModelBuilder: () => ProfileEditViewModel(),
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Profile Details"),
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(
                child: ListView(
                  children: [
                    _getBasicDetails(model),
                    _getIdentityDetails(model),
                    _getAddressDetails(model)
                  ],
                ),
              ),
              Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Spacing.defaultMargin,
                        horizontal: Spacing.defaultMargin),
                    child: AppButtonWidget(
                      text: "Go To Home",
                      width: double.maxFinite,
                      onPressed: () {
                        model.updateAddressClicked();
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
