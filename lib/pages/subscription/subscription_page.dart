import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppErrorWidget.dart';
import 'package:moneypros/pages/subscription/subscription_view_model.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    final userRepo = Provider.of<UserRepo>(context);
    return ViewModelBuilder<SubscriptionViewModel>.reactive(
      viewModelBuilder: () => SubscriptionViewModel(),
      onModelReady: (model) {
        model.init(userRepo);
        model.fetchSubscriptionPlan();
      },
      builder: (_, model, chils) => Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              brightness: Brightness.light,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.close),
                color: AppColors.blackGrey,
                onPressed: () {
                  model.backClicked();
                },
              ),
            ),
            preferredSize: Size.fromHeight(45)),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: (model.loading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (model.hasError)
                  ? AppErrorWidget(
                      message: SOMETHING_WRONG_TEXT,
                      onRetryCliked: () {
                        //model.fetchCrifData();
                      })
                  : Column(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Go Premium",
                              style: TextStyle(
                                  color: AppColors.blackText, fontSize: 30),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Unlimited Access",
                              style: TextStyle(
                                  color: AppColors.grey500, fontSize: 15),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 350,
                              width: double.maxFinite,
                              child: CarouselSlider(
                              options: CarouselOptions(
                                  autoPlay: false,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.7,
                                  enableInfiniteScroll: false,
                                  aspectRatio: (itemWidth / itemHeight),
                                  initialPage: 0,
                                  autoPlayCurve: Curves.easeIn,
                                  onPageChanged: (index, reason) {
                                    model.selectPackage(index);
                                  }),
                              items: List.generate(
                                  model.subscriptionPlans.length,
                                  (index) => Container(
                                   
                                    child: SubscriptionPlanTile(
                                          selected: (model.selectedPackage ==
                                              index),
                                          // onTap: () =>
                                          //     model.selectPackage(index),
                                          image: ImageAsset.diamond,
                                          title: model
                                              .subscriptionPlans[index].name,
                                          amount: model
                                              .subscriptionPlans[index].price,
                                          desc: model.subscriptionPlans[index]
                                              .benifitList,
                                        ),
                                  ))),
                            )
                          ],
                        )),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.mediumMargin,
                              vertical: Spacing.defaultMargin),
                          child: Column(
                            children: [
                              // Row(
                              //   children: [
                              //     Checkbox(
                              //         value: model.checkBoxValue,
                              //         onChanged: (value) {
                              //           model.onCheckBoxChanged(value);
                              //         }),
                              //     Expanded(
                              //       child: Text(
                              //         "Do you concent to moneyPros saving your information ?",
                              //         style: TextStyle(
                              //             color: AppColors.grey600, fontSize: 11),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                             // SizedBox(height: 10),
                              AppButtonWidget(
                                width: double.maxFinite,
                                text: "Subscribe Now",
                                color: AppColors.green,
                                onPressed: () {
                                  model.onPayClicked(onPaymentDone:
                                      (String status, String message) {
                                    if (status == "Successful") {
                                      _showPaymentErrorDialog(
                                          "Transaction of ${AppStrings.rupee} ${model.subscriptionPlans[model.selectedPackage].price} has been done Successfully",
                                          "Thank you for Activating Subscription plan, now your can acess your Crif Credit score and more.",
                                          Icons.check,
                                          'Retry',
                                          'View Credit Score',
                                          onSecondButtonCliked: () async {
                                        Navigator.pop(context);
                                        model.updateUserTable(context);
                                      });
                                    } else if (status == "Hold") {
                                      _showPaymentErrorDialog(
                                          "Transaction of ${AppStrings.rupee} ${model.subscriptionPlans[model.selectedPackage].price} has been put on hold!",
                                          "It will be take 4-5 working days to relfect transaction with us,if it's takes more time then please contact to MoneyPros helpline number.",
                                          Icons.info,
                                          'Retry',
                                          'Close',
                                          color: Colors.redAccent,
                                          onSecondButtonCliked: () {
                                        Navigator.pop(context);
                                      });
                                    } else if (status == "Pending") {
                                      _showPaymentErrorDialog(
                                          "Transaction of ${AppStrings.rupee} ${model.subscriptionPlans[model.selectedPackage].price} has showing pending!",
                                          "It will be take 4-5 working days to relfect transaction with us,if it's takes more time then please contact to MoneyPros helpline number.",
                                          Icons.info,
                                          'Retry',
                                          'Close',
                                          color: Colors.redAccent,
                                          onSecondButtonCliked: () {
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
        ),
      ),
    );
  }

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
            Text(title, textAlign: TextAlign.center, style: extraBigTextStyle.copyWith(fontFamily: "",)),
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
}

class SubscriptionPlanTile extends StatelessWidget {
  const SubscriptionPlanTile({
    Key key,
    this.selected,
    this.onTap,
    this.image,
    this.title,
    this.amount,
    this.desc,
  }) : super(key: key);

  final bool selected;
  final Function onTap;
  final String image, title, amount;
  final List<String> desc;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Neumorphic(
            margin: EdgeInsets.symmetric(
                horizontal:(!selected)?0: Spacing.smallMargin, vertical: Spacing.smallMargin),
            style: NeumorphicStyle(
              color: AppColors.white,
              intensity: (selected) ? 4 : 0,
              //intensity: 4,
              border: NeumorphicBorder(
                isEnabled: true,
                color: AppColors.blue,
              ),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(6)),
            ),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.extraBigMargin,
                  vertical: Spacing.bigMargin),
              decoration: BoxDecoration(
                  // gradient: (selected)
                  //     ? LinearGradient(
                  //         begin: Alignment.topRight,
                  //         end: Alignment.bottomLeft,
                  //         colors: [AppColors.kBlueDarkColor, AppColors.blue])
                  //     : null,
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [AppColors.kBlueDarkColor, AppColors.blue]),
                  border: Border.all(color: AppColors.blue, width: 0.8),
                  borderRadius: BorderRadius.circular(6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.white),
                    // color:
                    //     (selected) ? AppColors.white : AppColors.grey200),
                    child: SvgPicture.asset(
                      image,
                      color: AppColors.orange,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    title + "",
                    style: TextStyle(
                        color: AppColors.white,
                        // color:
                        //     (selected) ? AppColors.white : AppColors.blackText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${AppStrings.rupee} $amount",
                    style: TextStyle(
                        color: AppColors.white,
                        fontFamily: "",
                        // color:
                        //     (selected) ? AppColors.white : AppColors.blackText,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        desc.length,
                        (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "* " + desc[index],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white70,

                                      // color:
                                      //     (selected) ? Colors.white70 : AppColors.blackGrey,
                                      fontSize: 10),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                              ],
                            )),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: selected,
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration:
                  BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
              child: Icon(
                Icons.check,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
        )
      ],
    );
  }
}
