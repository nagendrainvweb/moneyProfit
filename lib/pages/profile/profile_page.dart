import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/model/crif_history_date_data.dart';
import 'package:moneypros/model/login_data.dart';
import 'package:moneypros/pages/address_profile/address_profile.dart';
import 'package:moneypros/pages/basic_profile/basic_info_page.dart';
import 'package:moneypros/pages/crif_history_page/crifHistoryPage.dart';
import 'package:moneypros/pages/document_page/document_page.dart';
import 'package:moneypros/pages/identity_profile/identity_profile.dart';
import 'package:moneypros/pages/profile/profile_view_model.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/dialog_helper.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String _tag = "profile";
  final _navigationService = locator<NavigationService>();

  _getLoginView(UserRepo userRepo) {
    return Column(
      children: [
        Text(
          userRepo.userDetails.firstName + " " + userRepo.userDetails.lastName,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepo>(context);
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (model) {
        model.initData(userRepo);
      },
      builder: (_, model, child) => Container(
          decoration: BoxDecoration(
              //  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16) ),
              gradient: LinearGradient(
                  colors: [AppColors.blueLightColor, AppColors.blue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  //flex: 5,
                  child: Container(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Neumorphic(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Spacing.defaultMargin),
                            style: NeumorphicStyle(
                                color: AppColors.tileColor,
                                intensity: 0.5,
                                boxShape: NeumorphicBoxShape.circle()),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CircleAvatar(
                                child: SvgPicture.asset(
                                  ImageAsset.avator,
                                  height: double.maxFinite,
                                  width: double.maxFinite,
                                ),
                                backgroundColor: AppColors.grey300,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _getLoginView(userRepo),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // flex: 8,
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.defaultMargin,
                        vertical: Spacing.bigMargin),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26)),
                    ),
                    child: Column(
                      //mainAxisSize: MainAxisSize.max,
                      children: [
                        //SizedBox(height: 20,),
                        ProfileListTile(
                          option: "Basic Details",
                          icon: Icons.person_outline,
                          onTap: () async {
                            final value = await Utility.pushToNext(
                                BasicInfoPage(
                                  editable: false,
                                  from: _tag,
                                ),
                                context);

                            if (value != null) {
                              _showSnackBar(value);
                            }
                          },
                        ),
                        //SizedBox(height: 10,),
                        ProfileListTile(
                          option: "Identity Details",
                          icon: Icons.contact_mail_outlined,
                          onTap: () async {
                            final value = await Utility.pushToNext(
                                IdentityProfile(
                                  editable: false,
                                  from: _tag,
                                ),
                                context);
                            if (value != null) {
                              _showSnackBar(value);
                            }
                          },
                        ),
                        ProfileListTile(
                          option: "Address Details",
                          icon: Icons.location_city_outlined,
                          onTap: () async {
                            final value = await Utility.pushToNext(
                                AddressProfile(
                                  editable: false,
                                  from: _tag,
                                ),
                                context);
                            if (value != null) {
                              _showSnackBar(value);
                            }
                          },
                        ),
                        ProfileListTile(
                            option: "Crif History",
                            onTap: () {
                              model.fetchCrifHistoryDates(onDateCallback:
                                  (List<CrifHistoryDateData> dates) {
                                if (dates.isNotEmpty) {
                                  _showBottomSheet(dates);
                                } else {
                                  _showSnackBar("No History Found");
                                }
                              });
                            },
                            icon: Icons.history_edu_outlined),
                        ProfileListTile(
                            option: "Documents",
                            onTap: () {
                              _navigationService.navigateToView(DocumentPage());
                            },
                            icon: Icons.receipt_long_outlined),
                        ProfileListTile(
                            option: "Subscription",
                            onTap: () {
                              if (userRepo.subscription != null) {
                                _showSubscriptionSheet(userRepo.subscription);
                              } else {
                                _showSnackBar(
                                    "Subscription Details are not found.");
                              }
                            },
                            icon: Icons.card_membership_outlined),
                        ProfileListTile(
                            onTap: () {
                              if (userRepo.transaction != null) {
                                _showTransactionSheet(userRepo.transaction);
                              } else {
                                _showSnackBar(
                                    "Transaction Details are not found.");
                              }
                            },
                            option: "Transaction",
                            icon: Icons.money_outlined),
                        ProfileListTile(
                            option: "Log out",
                            onTap: () {
                              DialogHelper.showLogoutDialog(context, () async {
                                await Prefs.clear();
                                //Prefs.setStateList("");
                                userRepo.clear();
                                locator<NavigationService>()
                                    .clearStackAndShow("/login");
                              });
                            },
                            icon: Icons.logout),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          )),
    );
  }

  _showTransactionSheet(Transaction transaction) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (_) => Container(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.grey700,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: Spacing.bigMargin),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:
                              _getDetailsRow("Order Id", transaction.orderId),
                        ),
                        Expanded(
                          child: _getDetailsRow(
                              "Mobile No.", transaction.userMobile),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _getDetailsRow(
                              "Transaction Date", transaction.transactionDate),
                        ),
                        Expanded(
                          child: _getDetailsRow("Amount", transaction.amount),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _getDetailsRow("Email", transaction.userEmail),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _getDetailsRow(
                              "Avantgarde Ref.", transaction.agRef),
                        ),
                        Expanded(
                          child: _getDetailsRow(
                              "Payment Gateway Ref. ", transaction.pgRef),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _getDetailsRow("Transaction Status",
                              transaction.transactionStatus),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ])));
  }

  _showSubscriptionSheet(Subscription subscription) async {
    final subscribe = await Prefs.subscription;
    final dateTime = Utility.parseServerDate(subscription.subscriptionDate);
    final endDateTime = Utility.parseServerDate(subscription.expiryDate);
    final date = Utility.formattedDeviceMonthDate(dateTime);
    final endDate = Utility.formattedDeviceMonthDate(endDateTime);
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (_) => Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: AppColors.grey700,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.bigMargin),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _getDetailsRow(
                                  "Subscription", "${subscribe}".toUpperCase()),
                            ),
                            Expanded(
                              child: _getDetailsRow(
                                  "Subscription Plan", subscription.name),
                            )
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _getDetailsRow(
                                  "Subscription Amount", subscription.amount),
                            ),
                            Expanded(
                              child: _getDetailsRow("Subscription Date", date),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _getDetailsRow("Expiry Date", endDate),
                            ),
                            Expanded(
                              child: _getDetailsRow("", ""),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  _getDetailsRow(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 12,
                color: AppColors.grey700,
                fontWeight: FontWeight.normal)),
        Text(desc,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.blackGrey,
                fontWeight: FontWeight.normal)),
      ],
    );
  }

  _showBottomSheet(List<CrifHistoryDateData> dates) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (context) => Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: AppColors.grey700,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Please select CRIF History Date",
                            style: TextStyle(color: AppColors.grey800),
                          ),
                        ),
                        Column(
                            children: List.generate(
                          dates.length,
                          (index) => Column(
                            children: [
                              ListTile(
                                title: Text(dates[index].entryDate,
                                    textAlign: TextAlign.center),
                                onTap: () {
                                  myPrint(dates[index].entryDate);
                                  Navigator.pop(context);
                                  locator<NavigationService>()
                                      .navigateToView(CrifHistoryPage(
                                    date: dates[index].entryDate,
                                  ));
                                },
                              ),
                              Container(height: 1, color: AppColors.grey200),
                            ],
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  _showSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
      behavior: SnackBarBehavior.floating,
    ));
  }
}

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    Key key,
    this.onTap,
    this.option,
    this.selected,
    this.icon,
  }) : super(key: key);

  final Function onTap;
  final String option;
  final bool selected;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Spacing.smallMargin),
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.bigMargin, vertical: Spacing.defaultMargin),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.grey700,
              size: 22,
            ),
            SizedBox(width: 14),
            Expanded(child: Text("$option")),
            Container(
              padding: const EdgeInsets.all(4),
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     border: Border.all(
              //         color: (selected) ? AppColors.green : AppColors.grey300,
              //         width: 1.5),
              //     color: (selected) ? AppColors.green : AppColors.white),
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 14,
                color: AppColors.blackGrey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
