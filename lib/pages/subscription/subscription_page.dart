import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppErrorWidget.dart';
import 'package:moneypros/model/subscription_data.dart';
import 'package:moneypros/pages/subscription/subscription_view_model.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/constants.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app_widegt/AppTextFeildOutlineWidget.dart';

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
                                              selected:
                                                  (model.selectedPackage ==
                                                      index),
                                              // onTap: () =>
                                              //     model.selectPackage(index),
                                              image: ImageAsset.diamond,
                                              title: model
                                                  .subscriptionPlans[index]
                                                  .name,
                                              amount: model
                                                  .subscriptionPlans[index]
                                                  .price,
                                              desc: model
                                                  .subscriptionPlans[index]
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
                                  _showBottomReferalSheet(
                                    model.subscriptionPlans[
                                        model.selectedPackage],
                                    model,
                                    onPayClick: (String code,
                                        String totalAmount,
                                        String discountAmount,
                                        String payingAmount) {
                                      // onPressed: () {
                                      model.onPayClicked(
                                          code,
                                          model
                                              .subscriptionPlans[
                                                  model.selectedPackage]
                                              .id,
                                          discountAmount,
                                          payingAmount, onPaymentDone:
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
                                        } else {}
                                      });
                                    },
                                  );
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

  _showBottomReferalSheet(
      SubscriptionData subscriptionData, SubscriptionViewModel model,
      {Function onPayClick}) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      context: context,
      builder: (BuildContext context) {
        return ReferalCodeWidget(
          subscriptionData: subscriptionData,
          onPayClick: onPayClick,
        );
      },
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
            Text(title,
                textAlign: TextAlign.center,
                style: extraBigTextStyle.copyWith(
                  fontFamily: "",
                )),
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

class ReferalCodeWidget extends StatefulWidget {
  const ReferalCodeWidget({
    Key key,
    @required this.subscriptionData,
    @required this.onPayClick,
  }) : super(key: key);
  final SubscriptionData subscriptionData;
  final Function(String code, String totalAmount, String discountAmount,
      String payingAmount) onPayClick;

  @override
  State<ReferalCodeWidget> createState() => _ReferalCodeWidgetState();
}

class _ReferalCodeWidgetState extends State<ReferalCodeWidget> with AppHelper {
  final referalCodeController = TextEditingController();
  final apiService = locator<ApiService>();
  String referalMessage = "";
  bool referalStatus = false;
  String _totalAmount, _discountAmount, _payingAmount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setData();
  }

  setData() {
    setState(() {
      _totalAmount = widget.subscriptionData.price;
      _discountAmount = "0";
      _payingAmount = widget.subscriptionData.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2 +
          MediaQuery.of(context).viewInsets.bottom,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "Payment Details",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close))
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.kBlueLightColor),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.kBlueLightColor,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    //  margin: EdgeInsets.symmetric(horizontal: 2,vertical: 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kBlueLightColor, width: 0),
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.white,
                    ),
                    child: TextField(
                      controller: referalCodeController,
                      enabled: !referalStatus, // false
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Referal Code",
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10)),
                    ),
                  )),
                  InkWell(
                      onTap: referalStatus ? removeCode : applyReferalCode,
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Text(
                          referalStatus ? "Remove" : "Apply",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text("$referalMessage",
                style: TextStyle(
                    fontSize: 12,
                    color: referalStatus ? Colors.green : Colors.red)),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("Total Amount")),
                      Text(Constants.RUPEE + _totalAmount),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Discount Amount")),
                      Text(Constants.RUPEE + _discountAmount),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.onPayClick(referalCodeController.text, _totalAmount,
                    _discountAmount, _payingAmount);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.green,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Pay",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                    Text(
                      Constants.RUPEE + _payingAmount,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  removeCode() {
    setState(() {
      referalMessage = "";
      referalStatus = false;
      referalCodeController.text = "";
    });
    setData();
  }

  applyReferalCode() async {
    if (referalCodeController.text.isEmpty) {
      return;
    }
    try {
      FocusScope.of(context).unfocus();
      progressDialog("Please Wait...", context);
      final response = await apiService.verifyReferalCode(
          referalCodeController.text, widget.subscriptionData.id);
      hideProgressDialog(context);
      print("Response .${response.data}");
      setState(() {
        referalMessage = response.message;
        referalStatus = true;
        _totalAmount = response.data.totalAmount;
        _discountAmount = response.data.discountPrice.toString();
        _payingAmount = response.data.amountWithDiscount.toString();
      });
      //Utility.showSnackBar(context, response.message);
    } catch (e) {
      hideProgressDialog(context);
      // Utility.showSnackBar(context, e.toString());
      setState(() {
        referalMessage = e.toString();
        referalStatus = false;
      });
      setData();
    }
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
                horizontal: (!selected) ? 0 : Spacing.smallMargin,
                vertical: Spacing.smallMargin),
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
