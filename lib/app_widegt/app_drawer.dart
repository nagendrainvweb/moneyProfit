import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/pages/contact_us/contact_us.dart';
import 'package:moneypros/pages/loan_details/loan_details_page.dart';
import 'package:moneypros/pages/login/login_page.dart';
import 'package:moneypros/pages/terms_page/terms_page.dart';
import 'package:moneypros/pages/webview_page/webview_page.dart';
import 'package:moneypros/prefrence_util/Prefs.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/dialog_helper.dart';
import 'package:moneypros/utils/urlList.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    Key key,
    this.homeCallback,
  }) : super(key: key);

  final Function homeCallback;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _currentMenu = -1;

  final _navigationService = locator<NavigationService>();

  List<String> _loanList = [
    AppStrings.homeLoan,
    AppStrings.businessLoan,
    AppStrings.loanAgaintsProperty,
    AppStrings.educationLoan,
    AppStrings.goldLoan,
  ];

  List<String> _smeloanList = [
    AppStrings.projectLoan,
    AppStrings.termLoan,
    AppStrings.workingCapital,
  ];
  List<String> _wealthList = [
    AppStrings.equityTrading,
    AppStrings.mutualFund,
    AppStrings.unlistedPreIPO,
    AppStrings.pmsAndAIFDistribution,
    AppStrings.financialGoal,
  ];
  List<String> _insuranceList = [
    AppStrings.healthInsurance,
    AppStrings.travelInsurance,
    AppStrings.autoInsurance,
    AppStrings.lifeInsurance,
  ];
  List<String> _calculatorList = [
    "Loan Eligiblity Calculator",
    "Emi Calculator",
    "SIP Calculator"
  ];
  List<String> _otherList = [
    "Terms Of Use",
    "Privacy Policy",
    "Refund Policy",
    "CRIF Terms",
    "Contact Us"
  ];

  _getLoginView(UserRepo userRepo) {
    return Column(
      children: [
        Text(
          userRepo.userDetails.firstName + " " + userRepo.userDetails.lastName,
          style: TextStyle(color: AppColors.grey600, fontSize: 16),
        ),
        // SizedBox(height: 10),
        // TextButton(
        //     onPressed: () {},
        //     child: Text(
        //       "Logout",
        //       textScaleFactor: 1.1,
        //       style: TextStyle(color: AppColors.blackGrey),
        //     )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepo>(context, listen: false);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                child: Column(children: [
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (userRepo.login) {
                      Navigator.pop(context);
                      Utility.pushToDashboard(2);
                    }
                  },
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
              ),
              (userRepo.login ?? false)
                  ? _getLoginView(userRepo)
                  : TextButton(
                      onPressed: () {
                        _navigationService.back();
                        _navigationService.navigateToView(LoginPage(
                          showClose: true,
                        ));
                      },
                      child: Text(
                        "Login",
                        textScaleFactor: 1.1,
                        style: TextStyle(color: AppColors.green),
                      )),
              // SizedBox(height: 20),
            ])),
            SizedBox(height: 18),
            MenuTile(
              title: "Loans",
              image: ImageAsset.loan,
              active: (_currentMenu == 0),
              options: _loanList,
              onHeadClick: () {
                setState(() {
                  _currentMenu = (_currentMenu == 0) ? -1 : 0;
                });
              },
              onOptionClick: (int index) {
                Navigator.pop(context);
                _navigationService.navigateToView(LoanDetailsPage(
                  type: _loanList[index],
                ));
              },
            ),
            MenuTile(
              title: "SME Loans",
              image: ImageAsset.smeLoan,
              active: (_currentMenu == 1),
              options: _smeloanList,
              onHeadClick: () {
                setState(() {
                  _currentMenu = (_currentMenu == 1) ? -1 : 1;
                });
              },
              onOptionClick: (int index) {
                Navigator.pop(context);
                _navigationService.navigateToView(LoanDetailsPage(
                  type: _smeloanList[index],
                ));
              },
            ),
            MenuTile(
              title: "Wealth Management",
              image: ImageAsset.walthManagement,
              active: (_currentMenu == 2),
              options: _wealthList,
              onHeadClick: () {
                setState(() {
                  _currentMenu = (_currentMenu == 2) ? -1 : 2;
                });
              },
              onOptionClick: (int index) {
                Navigator.pop(context);
                String url = "";
                if (index == 0) {
                  url = UrlList.EQUITY_TRADING_LINK;
                } else if (index == 1) {
                  url = UrlList.MUTUAL_FUND_LINK;
                } else if (index == 2) {
                  url = UrlList.PRE_IPO_LINK;
                } else if (index == 3) {
                  url = UrlList.PMS_AIF_LINK;
                } else if (index == 4) {
                  url = UrlList.FINANCIAL_GOALS_LINK;
                }
                _navigationService.navigateToView(AppBrowserPage(url: url));
                // _navigationService.navigateToView(LoanDetailsPage(
                //   type: _wealthList[index],
                // ));
              },
            ),
            MenuTile(
              title: "Insurance",
              image: ImageAsset.healthCare,
              active: (_currentMenu == 3),
              options: _insuranceList,
              onHeadClick: () {
                setState(() {
                  _currentMenu = (_currentMenu == 3) ? -1 : 3;
                });
              },
              onOptionClick: (int index) {
                Navigator.pop(context);
                _navigationService.navigateToView(LoanDetailsPage(
                  type: _insuranceList[index],
                ));
              },
            ),
            MenuTile(
              title: "Calculator",
              image: ImageAsset.calculator,
              active: (_currentMenu == 4),
              options: _calculatorList,
              onHeadClick: () {
                setState(() {
                  _currentMenu = (_currentMenu == 4) ? -1 : 4;
                });
              },
              onOptionClick: (int index) {
                Navigator.pop(context);
                widget.homeCallback(3);
              },
            ),
            ListTile(
              tileColor: AppColors.white,
              leading: SvgPicture.asset(
                ImageAsset.reactification,
                height: 24,
                width: 24,
                color: AppColors.grey700,
              ),
              onTap: () {
                // Navigator.pop(context);
                // _navigationService.navigateToView(LoanDetailsPage(
                //   type: "Credit Rectification",
                // ));
                Navigator.pop(context);
                _navigationService.navigateToView(
                    AppBrowserPage(url: UrlList.CREDIT_REACTIFICATION_LINK));
              },
              title: Text("Credit Rectification",
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 15,
                  )),
            ),
            Container(
              height: 1.5,
              color: AppColors.grey200,
            ),
            ListTile(
              tileColor: AppColors.white,
              leading: Icon(Icons.receipt_outlined),
              title: Text(AppStrings.termsOfUse,
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 15,
                  )),
              onTap: () {
                Navigator.pop(context);
                _navigationService.navigateToView(TermsPage(
                  title: AppStrings.termsOfUse,
                ));
              },
            ),
            Container(
              height: 1.5,
              color: AppColors.grey200,
            ),
            ListTile(
              tileColor: AppColors.white,
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text(AppStrings.privacyPolicy,
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 15,
                  )),
              onTap: () {
                Navigator.pop(context);
                _navigationService.navigateToView(TermsPage(
                  title: AppStrings.privacyPolicy,
                ));
              },
            ),
            Container(
              height: 1.5,
              color: AppColors.grey200,
            ),
            ListTile(
              tileColor: AppColors.white,
              leading: Icon(Icons.policy_outlined),
              title: Text(AppStrings.refundPolicy,
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 15,
                  )),
              onTap: () {
                Navigator.pop(context);
                _navigationService.navigateToView(TermsPage(
                  title: AppStrings.refundPolicy,
                ));
              },
            ),
            Container(
              height: 1.5,
              color: AppColors.grey200,
            ),
            ListTile(
              tileColor: AppColors.white,
              leading: Icon(Icons.receipt_long_outlined),
              title: Text(AppStrings.crifTerms,
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 15,
                  )),
              onTap: () {
                Navigator.pop(context);
                _navigationService.navigateToView(TermsPage(
                  title: AppStrings.crifTerms,
                ));
              },
            ),
            Container(
              height: 1.5,
              color: AppColors.grey200,
            ),
            ListTile(
              tileColor: AppColors.white,
              leading: Icon(Icons.support_agent_outlined),
              title: Text("Contact Us",
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 15,
                  )),
              onTap: () {
                Navigator.pop(context);
                _navigationService.navigateToView(ContactUsPage());
              },
            ),
            ListTile(
              tileColor: AppColors.white,
              leading: Icon(Icons.info_outline),
              title: Text("About Us",
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 15,
                  )),
              onTap: () {
                Navigator.pop(context);
                _navigationService
                    .navigateToView(AppBrowserPage(url: UrlList.ABOUT_US_LINK));
              },
            ),
            // Container(
            //   height: 1.5,
            //   color: AppColors.grey200,
            // ),
            // Visibility(
            //   visible: userRepo.login,
            //   child: ListTile(
            //     tileColor: AppColors.white,
            //     leading: Icon(Icons.logout),
            //     title: Text("Log out",
            //         style: TextStyle(
            //           color: AppColors.grey700,
            //           fontSize: 15,
            //         )),
            //     onTap: () async {
            //       DialogHelper.showLogoutDialog(context, () async {
            //         Navigator.pop(context);
            //         await Prefs.clear();
            //         locator<NavigationService>().clearStackAndShow("/login");
            //       });
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  const MenuTile({
    Key key,
    this.title,
    this.active,
    this.image,
    this.options,
    this.onHeadClick,
    this.onOptionClick,
  }) : super(key: key);

  final String title;
  final bool active;
  final String image;
  final List<String> options;
  final Function onHeadClick;
  final Function onOptionClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: (active) ? AppColors.blue : AppColors.white,
              border: Border(
                  top: BorderSide(color: AppColors.grey200, width: 0.8),
                  bottom: BorderSide(color: AppColors.grey200, width: 0.8)),
            ),
            child: ListTile(
              onTap: onHeadClick,
              title: Text(title,
                  style: TextStyle(
                    color: (active) ? AppColors.white : AppColors.grey700,
                    fontSize: 15,
                  )),
              leading: SvgPicture.asset(
                image,
                height: 24,
                width: 24,
                color: (active) ? AppColors.white : AppColors.grey700,
              ),
              trailing: Icon(
                  (active)
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: (active) ? AppColors.white : AppColors.grey700),
            ),
          ),
          Visibility(
            visible: active,
            child: Container(
              //color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    options.length,
                    (index) => InkWell(
                          onTap: () {
                            onOptionClick(index);
                          },
                          child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.only(
                                  top: Spacing.defaultMargin,
                                  left: Spacing.bigMargin,
                                  right: Spacing.defaultMargin,
                                  bottom: Spacing.smallMargin),
                              child: Row(
                                children: [
                                  // SvgPicture.asset(
                                  //   image,
                                  //   height: 24,
                                  //   width: 24,
                                  //   color: Colors.transparent
                                  // ),
                                  SizedBox(width: 50),
                                  Text(
                                    options[index],
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              )),
                        )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
