import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppErrorWidget.dart';
import 'package:moneypros/app_widegt/app_drawer.dart';
import 'package:moneypros/pages/calculator/calculator_widget.dart';
import 'package:moneypros/pages/credit_scrore/credit_score.dart';
import 'package:moneypros/pages/dashboard/dashboard_page.dart';
import 'package:moneypros/pages/home/component/credit_meter.dart';
import 'package:moneypros/pages/home/home_viewmodel.dart';
import 'package:moneypros/pages/notification/notification_page.dart';
import 'package:moneypros/pages/profile/profile_page.dart';
import 'package:moneypros/pages/question_page/question_page.dart';
import 'package:moneypros/pages/subscription/subscription_page.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class HomePage extends StatefulWidget {
  final position;

  const HomePage({Key key, this.position = 0}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _showPaymentErrorDialog(var title, var desc, IconData icon,
      var firstButtonTitle, var secondbuttonTitle,
      {Function onFirstButtonCliked,
      Function onSecondButtonCliked,
      Color color = AppColors.green}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.defaultMargin, vertical: Spacing.defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(
            //         icon: Icon(Icons.close),
            //         onPressed: () {
            //           Navigator.pop(context);
            //         })
            //   ],
            // ),
            Icon(icon, color: color, size: 80),
            SizedBox(height: 20),
            Text(title, textAlign: TextAlign.center, style: extraBigTextStyle),
            SizedBox(height: 5),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: smallTextStyle,
            ),
            SizedBox(height: 25),
            // FlatButton(
            //     onPressed: () {
            //       onFirstButtonCliked();
            //     },
            //     textColor: AppColors.white,
            //     color: AppColors.blackGrey,
            //     child: Text(firstButtonTitle)),
            // SizedBox(height: 10),
            FlatButton(
                onPressed: () {
                  onSecondButtonCliked();
                },
                textColor: color,
                child: Text(secondbuttonTitle)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepo>(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (HomeViewModel model) {
        model.checkUpdate(context);
        model.listenFirebase();
        model.initData(userRepo, widget.position);
      },
      builder: (_, model, child) => Scaffold(
        extendBodyBehindAppBar: (model.currentBottomIndex == 2),
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: (model.currentBottomIndex == 2)
                  ? AppColors.white
                  : AppColors.blue),
          actions: [
            Consumer<UserRepo>(
              builder: (_, model, child) => Visibility(
                visible: model.login ?? false,
                child: IconButton(
                    icon: Icon(Icons.notifications_outlined),
                    onPressed: () {
                      // show notifcation page
                      Utility.pushToNext(NotificationPage(), context);
                      // Utility.pushToNext(QuestionPage(
                      //   question: "What is your name?",
                      //   options: ["Shiv","Sagar","Chotu","Karan"],
                      //   questionCount: 1,
                      //   buttonType: "T",
                      // ), context);
                      // _showPaymentErrorDialog(
                      //     "Transaction of ${AppStrings.rupee} 3000 has showing pending!",
                      //     "It will be take 4-5 working days to relfect transaction with us,if it's takes more time then please contact to MoneyPros helpline number.",
                      //     Icons.info,
                      //     'Retry',
                      //     'Close',
                      //     color: Colors.redAccent,
                      //      onSecondButtonCliked: () {
                      //   Navigator.pop(context);
                      // });
                    }),
              ),
            )
          ],
          //title: Text("MoneyPros"),
        ),
        drawer: AppDrawer(
          homeCallback: (int value) {
            model.onBottomButtonClicked(value);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: AppColors.grey600,
            selectedItemColor: AppColors.orange,
            currentIndex: model.currentBottomIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 20,
            type: BottomNavigationBarType.fixed,
            onTap: model.onBottomButtonClicked,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Container(
                    child: SvgPicture.asset(
                      ImageAsset.moneyProsWallet,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    ImageAsset.meter,
                    height: 24,
                    width: 24,
                    color: (model.currentBottomIndex == 1)
                        ? AppColors.orange
                        : AppColors.grey600,
                  ),
                  label: "360 View"),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    ImageAsset.user,
                    height: 24,
                    width: 24,
                    color: (model.currentBottomIndex == 2)
                        ? AppColors.orange
                        : AppColors.grey600,
                  ),
                  label: "Profile"),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    ImageAsset.calculator,
                    height: 24,
                    width: 24,
                    color: (model.currentBottomIndex == 3)
                        ? AppColors.orange
                        : AppColors.grey600,
                  ),
                  label: "Calculator"),
            ]),
        body: _getWidget(model),
      ),
    );
  }

  _getWidget(HomeViewModel model) {
    Widget view;
    switch (model.currentBottomIndex) {
      case 0:
        view = DashboardWidget();
        break;
      case 1:
        view = CreditScoreWidget();
        break;
      case 2:
        view = ProfileWidget();
        break;
      case 3:
        view = CalculatorWidget();
        break;
      default:
        view = Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
          child: Center(
            child: AppErrorWidget(
                message: "Error",
                onRetryCliked: () {
                  model.retryClicked();
                }),
          ),
        );
    }
    return view;
  }
}
