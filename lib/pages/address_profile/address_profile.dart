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
import 'package:moneypros/utils/dialog_helper.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class AddressProfile extends StatefulWidget {
  final bool editable;
  final String from;

  const AddressProfile({Key key, this.editable = true, this.from})
      : super(key: key);
  @override
  _AddressProfileState createState() => _AddressProfileState();
}

class _AddressProfileState extends State<AddressProfile> {
  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepo>(context);
    return ViewModelBuilder<ProfileEditViewModel>.reactive(
      viewModelBuilder: () => ProfileEditViewModel(),
      onModelReady: (ProfileEditViewModel model) {
        model.initAddress(userRepo, widget.editable, widget.from);
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          actions: [
            Visibility(
              visible: !model.addressEditable,
              child: TextButton(
                  onPressed: () {
                    model.setAddressEditable(true);
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
                  text1: "Address",
                  text2: "Details",
                ),
                AppTextFeildOutlineWidget(
                  controller: model.addressController,
                  hintText: "Address *",
                  maxLines: 2,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.multiline,
                  enabled: model.addressEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                // SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.villageController,
                  hintText: "Area *",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                  enabled: model.addressEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                // SizedBox(height: 10),

                // SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    if (model.addressEditable) {
                      _showBottonSheet(
                          "Please Select State",
                          userRepo.stateList.map((e) => e.name).toList(),
                          model.stateController.text, (index) {
                        model.stateController.text =
                            userRepo.stateList[index].name;
                        model.setStateId(userRepo.stateList[index].id);
                      });
                    }
                  },
                  child: AppTextFeildOutlineWidget(
                    controller: model.stateController,
                    textCapitalization: TextCapitalization.sentences,
                    fillColor: AppColors.white,
                    hintText: "State *",
                    textInputType: TextInputType.name,
                    enabled: false,
                    onSubmit: (e) {},
                    onChanged: (e) {},
                  ),
                ),
                //SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    if (model.addressEditable) {
                      if (model.stateId.isNotEmpty) {
                        _showBottonSheet(
                            "Please Select City",
                            model.cityList.map((e) => e.name).toList(),
                            model.cityController.text, (index) {
                          model.cityController.text =
                              model.cityList[index].name;
                        });
                      } else {
                        DialogHelper.showErrorDialog(
                            context, "Error", "Please select state");
                      }
                    }
                  },
                  child: AppTextFeildOutlineWidget(
                    controller: model.cityController,
                    hintText: "City *",
                    textCapitalization: TextCapitalization.sentences,
                    fillColor: AppColors.white,
                    enabled: false,
                    textInputType: TextInputType.name,
                    onSubmit: (e) {},
                    onChanged: (e) {},
                  ),
                ),
                //SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.pincodeController,
                  hintText: "Pin Code *",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                  enabled: model.addressEditable,
                  onSubmit: (e) {},
                  onChanged: (e) {},
                ),
                //  SizedBox(height: 8),
                Visibility(
                  visible: widget.editable,
                  //visible: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.defaultMargin,
                        vertical: Spacing.defaultMargin),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                                value: model.checkBoxValue,
                                onChanged: (value) {
                                  model.onCheckBoxChanged(value);
                                }),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Do you concent to moneyPros saving your information ?",
                                    style: TextStyle(
                                        color: AppColors.grey600, fontSize: 11),
                                  ),
                                  // Text(
                                  //   "We fetch your credit score and liabilities data from CRIF High Mark/Experian based on your explicit consent. If there are any disputes/discrepancies, please write to customerservice@crifhighmark.com or info@moneypro-s.com. You also have the option to opt out/unsubscribe from the service by writing to us at info@moneypro-s.com. Please note that your loans and liabilities related data is secure and confidential with MoneyPros",
                                  //   style: TextStyle(
                                  //       color: AppColors.grey600, fontSize: 10),
                                  // )
                                ],
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height:3),
                      ],
                    ),
                    // Text("By clicking update you are agree to save your information with MoneyPros ",
                    // style: TextStyle(color:AppColors.grey600,fontSize: 12),
                    // ),
                  ),
                ),
                Visibility(
                  visible: model.addressEditable,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.defaultMargin),
                    child: AppButtonWidget(
                      text: "Update Address Details",
                      width: double.maxFinite,
                      onPressed: () {
                        model.updateAddressClicked();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
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
}
