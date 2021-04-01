import 'package:flutter/material.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/app_widegt/app_neumorpic_text_feild.dart';
import 'package:moneypros/app_widegt/app_profile_heading.dart';
import 'package:moneypros/app_widegt/customBottomSelectorWidget.dart';
import 'package:moneypros/pages/profile_details/profile_details_view_model.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class BasicInfoPage extends StatefulWidget {
  final bool editable;
  final String from;

  const BasicInfoPage({Key key, this.editable = true, this.from = "register"})
      : super(key: key);
  @override
  _BasicInfoPageState createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
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

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserRepo>(context, listen: false);
    return ViewModelBuilder<ProfileEditViewModel>.reactive(
      viewModelBuilder: () => ProfileEditViewModel(),
      onModelReady: (ProfileEditViewModel model) {
        model.initPersonal(userData, widget.editable, widget.from);
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            color: AppColors.blackGrey,
            onPressed: () {
              if (model.basicFrom == "profile") {
                Navigator.pop(context);
              } else {
                model.backToHome();
              }
            },
          ),
          actions: [
            Visibility(
              visible: !model.basicEditable,
              child: TextButton(
                  onPressed: () {
                    model.setBasicEditable(true);
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
                  text1: "Basic",
                  text2: "Details",
                ),

                // SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFeildOutlineWidget(
                        controller: model.firstNameController,
                        hintText: "First Name *",
                        textCapitalization: TextCapitalization.words,
                        fillColor: AppColors.white,
                        textInputType: TextInputType.name,
                        enabled: model.basicEditable,
                        onSubmit: (e) {},
                        onChanged: (e) {},
                      ),
                    ),
                    Expanded(
                      child: AppTextFeildOutlineWidget(
                        controller: model.middleNameController,
                        hintText: "Middle Name",
                        textCapitalization: TextCapitalization.sentences,
                        fillColor: AppColors.white,
                        textInputType: TextInputType.name,
                        onSubmit: (e) {},
                        onChanged: (e) {},
                        removeLeftPadding: true,
                        enabled: model.basicEditable,
                        //showBorder: true,
                        //borderRadius: 12,
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 10),

                //SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.lastNameController,
                  hintText: " Last Name *",
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                  enabled: model.basicEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                //SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFeildOutlineWidget(
                        controller: model.fatherNameController,
                        hintText: "Father Name *",
                        textCapitalization: TextCapitalization.sentences,
                        fillColor: AppColors.white,
                        textInputType: TextInputType.name,
                        enabled: model.basicEditable,
                        onSubmit: (e) {},
                        onChanged: (e) {},
                      ),
                    ),
                    Expanded(
                      child: AppTextFeildOutlineWidget(
                        controller: model.motherNameController,
                        hintText: "Mother Name",
                        textCapitalization: TextCapitalization.sentences,
                        fillColor: AppColors.white,
                        textInputType: TextInputType.name,
                        enabled: model.basicEditable,
                        onSubmit: (e) {},
                        onChanged: (e) {},
                        removeLeftPadding: true,
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10),

                //SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (model.basicEditable) {
                            _showBottonSheet(
                                "Please Select Marital Status",
                                model.martialStatusList,
                                model.marriedStatusController.text, (index) {
                              model.marriedStatusController.text =
                                  model.martialStatusList[index];
                              model.notifyListeners();
                            });
                          }
                        },
                        child: AppTextFeildOutlineWidget(
                          controller: model.marriedStatusController,
                          hintText: "Marital Status *",
                          fillColor: AppColors.white,
                          enableInteractiveSelection: false,
                          enabled: false,
                          textInputType: TextInputType.name,
                          onSubmit: (e) {},
                          onChanged: (e) {},
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          (model.marriedStatusController.text == "Married"),
                      child: Expanded(
                        child: AppTextFeildOutlineWidget(
                          controller: model.spouseNameController,
                          hintText: "Spouse Name *",
                          textCapitalization: TextCapitalization.sentences,
                          fillColor: AppColors.white,
                          enabled: model.basicEditable,
                          textInputType: TextInputType.name,
                          onSubmit: (e) {},
                          onChanged: (e) {},
                          removeLeftPadding: true,
                        ),
                      ),
                    ),
                  ],
                ),

                // SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.emailController,
                  hintText: "Email Address *",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.emailAddress,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                  enabled: false,
                ),
                //SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.numberController,
                  hintText: "Mobile *",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.number,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                  enabled: false,
                ),
                //SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (model.basicEditable) {
                            _showDatePicker(
                                onSetDate: model.setDOB,
                                selectedDate:
                                    model.dobController.text.isNotEmpty
                                        ? Utility.parseDeviceDate(
                                            model.dobController.text)
                                        : null);
                          }
                        },
                        child: AppTextFeildOutlineWidget(
                          controller: model.dobController,
                          hintText: "Date of Birth *",
                          fillColor: AppColors.white,
                          enableInteractiveSelection: false,
                          enabled: false,
                          textInputType: TextInputType.name,
                          onSubmit: (e) {},
                          onChanged: (e) {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppTextFeildOutlineWidget(
                        controller: model.ageController,
                        hintText: "Age (in Years) *",
                        fillColor: AppColors.white,
                        enableInteractiveSelection: false,
                        enabled: false,
                        textInputType: TextInputType.name,
                        onSubmit: (e) {},
                        onChanged: (e) {},
                        removeLeftPadding: true,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (model.basicEditable) {
                      _showBottonSheet("Please Select Gender", model.genderList,
                          model.genderController.text, (index) {
                        model.genderController.text = model.genderList[index];
                      });
                    }
                  },
                  child: AppTextFeildOutlineWidget(
                    controller: model.genderController,
                    hintText: "Gender *",
                    enableInteractiveSelection: false,
                    enabled: false,
                    fillColor: AppColors.white,
                    textInputType: TextInputType.name,
                    onSubmit: (e) {},
                    onChanged: (e) {},
                  ),
                ),

                //SizedBox(height: 10),

                // SizedBox(height: 10),

                //SizedBox(height: 10),

                SizedBox(height: 15),
                Visibility(
                  visible: model.basicEditable,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.defaultMargin),
                    child: AppButtonWidget(
                      width: double.maxFinite,
                      text: "Update Basic Details",
                      onPressed: () async {
                        model.onUpdateBasicDetailsClicked();
                        //  userData.getUserDataFromTable("105");
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
