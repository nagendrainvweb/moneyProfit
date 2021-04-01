import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppExpansionTileWidget.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/pages/calculator/calculator_view_model.dart';
import 'package:moneypros/pages/calculator/component/loan_eligible_result.dart';
import 'package:moneypros/pages/emi_details/emi_details_page.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/font.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CalculatorWidget extends StatefulWidget {
  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CalculatorViewModel>.reactive(
      viewModelBuilder: () => CalculatorViewModel(),
      onModelReady: (CalculatorViewModel model) {
        model.calculateEMI();
        model.calculateSIP();
      },
      builder: (_, model, child) => Container(
        child: ListView(
          children: [
            CheckEligibilityWidegt(),
            EMICalculatorWidget(),
            SPICalculatorWidget()
          ],
        ),
      ),
    );
  }
}

class SPICalculatorWidget extends ViewModelWidget<CalculatorViewModel> {
  const SPICalculatorWidget({
    Key key,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, CalculatorViewModel model) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.blue, borderRadius: BorderRadius.circular(6.0)),
      margin: const EdgeInsets.all(Spacing.smallMargin),
      child: AppExpansionTileWidget(
        title: "SIP Calculator",
        initiallyExpanded: false,
        active: model.sipOpen,
        onExpansionChanged: (bool value) {
          model.setSipOpen(value);
        },
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey400, width: 1.0),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(Spacing.mediumMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                AppTextFeildOutlineWidget(
                  controller: model.spiMonthlyInstallment,
                  hintText: "Monthly Installment",
                  fillColor: AppColors.white,
                  removeLeftPadding: true,
                  removeRightPadding: true,
                  textInputType: TextInputType.number,
                  onChanged: (e) {
                    model.calculateSIP();
                  },
                  onSubmit: (e) {},
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.spiPeriod,
                  hintText: "Investment Period (Years)",
                  removeLeftPadding: true,
                  removeRightPadding: true,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.number,
                  onChanged: (e) {
                    model.calculateSIP();
                  },
                  onSubmit: (e) {},
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.spiReturn,
                  hintText: "Annual Expected Return (%)",
                  textCapitalization: TextCapitalization.words,
                  fillColor: AppColors.white,
                  removeLeftPadding: true,
                  removeRightPadding: true,
                  textInputType: TextInputType.number,
                  onChanged: (e) {
                    model.calculateSIP();
                  },
                  onSubmit: (e) {},
                ),
                SizedBox(height: 10),
                // CustomSliderText(
                //   value: model.loanValue,
                //   min: model.loanMinValue,
                //   max: model.loanMaxValue,
                //   interval: model.loanInterval,
                //   onChanged: model.loanSliderChanged,
                //   title: "Loan Amount is :",
                // ),
                // Divider(),
                // SizedBox(height: 20),
                // CustomSliderText(
                //   value: model.monthValue,
                //   min: model.monthMinValue,
                //   max: model.monthMaxValue,
                //   interval: model.monthInterval,
                //   onChanged: model.monthSliderChanged,
                //   title: "No. of Month is :",
                // ),
                // Divider(),
                // CustomSliderText(
                //   value: model.rateValue,
                //   min: model.rateMinValue,
                //   max: model.rateMaxValue,
                //   interval: model.rateInterval,
                //   onChanged: model.rateSliderChanged,
                //   showDecimal: true,
                //   title: "Rate of Interest [ROI] is :",
                // ),
                // Divider(),

                Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Expected Amount",
                              style: TextStyle(color: AppColors.grey600)),
                          Text("${model.sipExpectedAmount.toStringAsFixed(2)}",
                              textScaleFactor: 1,
                              style: TextStyle(color: AppColors.blackGrey))
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount Invested",
                              style: TextStyle(color: AppColors.grey600)),
                          Text("${model.sipInvestedAmount.toStringAsFixed(2)}",
                              textScaleFactor: 1,
                              style: TextStyle(color: AppColors.blackGrey))
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Profit Amount",
                              style: TextStyle(color: AppColors.grey600)),
                          Text("${model.sipProfit.toStringAsFixed(2)}",
                              textScaleFactor: 1,
                              style: TextStyle(color: AppColors.blackGrey)),
                        ],
                      ),
                    ),
                    // ListTile(
                    //   title: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text("Interest Percentage",
                    //           style: TextStyle(color: AppColors.grey600)),
                    //       Text("${model.calInterest}",
                    //           textScaleFactor: 1,
                    //           style: TextStyle(color: AppColors.blackGrey)),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
                // SizedBox(height: 20),
                // AppButtonWidget(
                //   width: double.maxFinite,
                //   color: AppColors.green,
                //   text: "Show EMI Details",
                //   onPressed: () {
                //     myPrint("count is ${model.emiList.length}");
                //     Utility.pushToNext(
                //         EmiDetailsPage(emiList: model.emiList), context);
                //   },
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EMICalculatorWidget extends ViewModelWidget<CalculatorViewModel> {
  const EMICalculatorWidget({
    Key key,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, CalculatorViewModel model) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.blue, borderRadius: BorderRadius.circular(6.0)),
      margin: const EdgeInsets.all(Spacing.smallMargin),
      child: AppExpansionTileWidget(
        title: "EMI Calculator",
        initiallyExpanded: false,
        active: model.emiOpen,
        onExpansionChanged: (bool value) {
          model.setEmiOpen(value);
        },
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey400, width: 1.0),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(Spacing.mediumMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                AppTextFeildOutlineWidget(
                  controller: model.emiLoanAmountController,
                  hintText: "Loan Amount",
                  removeLeftPadding: true,
                  removeRightPadding: true,
                  fillColor: AppColors.white,
                  textInputType: TextInputType.number,
                  onChanged: (e) {
                    model.loanSliderChanged(e);
                  },
                  onSubmit: (e) {},
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.emiNoOfMonthController,
                  hintText: "No of Months",
                  fillColor: AppColors.white,
                  removeLeftPadding: true,
                  removeRightPadding: true,
                  textInputType: TextInputType.number,
                  onChanged: (e) {
                    model.monthSliderChanged(e);
                  },
                  onSubmit: (e) {},
                ),
                SizedBox(height: 10),
                AppTextFeildOutlineWidget(
                  controller: model.emiROIControlller,
                  hintText: "Rate of Interest (ROI)",
                  textCapitalization: TextCapitalization.words,
                  fillColor: AppColors.white,
                  removeLeftPadding: true,
                  removeRightPadding: true,
                  textInputType: TextInputType.number,
                  onChanged: (e) {
                    model.rateSliderChanged(e);
                  },
                  onSubmit: (e) {},
                ),
                SizedBox(height: 10),
                // CustomSliderText(
                //   value: model.loanValue,
                //   min: model.loanMinValue,
                //   max: model.loanMaxValue,
                //   interval: model.loanInterval,
                //   onChanged: model.loanSliderChanged,
                //   title: "Loan Amount is :",
                // ),
                // Divider(),
                // SizedBox(height: 20),
                // CustomSliderText(
                //   value: model.monthValue,
                //   min: model.monthMinValue,
                //   max: model.monthMaxValue,
                //   interval: model.monthInterval,
                //   onChanged: model.monthSliderChanged,
                //   title: "No. of Month is :",
                // ),
                // Divider(),
                // CustomSliderText(
                //   value: model.rateValue,
                //   min: model.rateMinValue,
                //   max: model.rateMaxValue,
                //   interval: model.rateInterval,
                //   onChanged: model.rateSliderChanged,
                //   showDecimal: true,
                //   title: "Rate of Interest [ROI] is :",
                // ),
                // Divider(),

                Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Monthly EMI",
                              style: TextStyle(color: AppColors.grey600)),
                          Text("${model.calEmi}",
                              textScaleFactor: 1,
                              style: TextStyle(color: AppColors.blackGrey))
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Interest",
                              style: TextStyle(color: AppColors.grey600)),
                          Text("${model.calTotalIntrest}",
                              textScaleFactor: 1,
                              style: TextStyle(color: AppColors.blackGrey))
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payable Amount",
                              style: TextStyle(color: AppColors.grey600)),
                          Text("${model.calPayableAmount}",
                              textScaleFactor: 1,
                              style: TextStyle(color: AppColors.blackGrey)),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Interest Percentage",
                              style: TextStyle(color: AppColors.grey600)),
                          Text("${model.calInterest}",
                              textScaleFactor: 1,
                              style: TextStyle(color: AppColors.blackGrey)),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                AppButtonWidget(
                  width: double.maxFinite,
                  color: AppColors.green,
                  text: "Show EMI Details",
                  onPressed: () {
                    myPrint("count is ${model.emiList.length}");
                    Utility.pushToNext(
                        EmiDetailsPage(emiList: model.emiList), context);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomSliderText extends StatelessWidget {
  const CustomSliderText({
    Key key,
    @required double value,
    this.onChanged,
    this.min,
    this.max,
    this.interval,
    this.title,
    this.showDecimal = false,
  })  : _value = value,
        super(key: key);

  final double _value;
  final Function onChanged;
  final double min, max, interval;
  final String title;
  final bool showDecimal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfSlider(
          min: min,
          max: max,
          value: _value,
          interval: interval,
          showTicks: false,
          showLabels: false,
          enableTooltip: true,
          tooltipTextFormatterCallback: (actualvalue, value) {
            return (!showDecimal)
                ? double.parse(value).toStringAsFixed(0)
                : double.parse(value).toStringAsFixed(2);
          },
          tooltipShape: SfRectangularTooltipShape(),
          activeColor: AppColors.orange,
          inactiveColor: AppColors.blue,
          minorTicksPerInterval: 1,
          onChanged: (dynamic value) {
            onChanged(value);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$title",
                style: TextStyle(
                  color: AppColors.blackText,
                ),
              ),
              Text(
                (showDecimal)
                    ? "${_value.toStringAsFixed(2)}"
                    : "${_value.toStringAsFixed(0)}",
                style: TextStyle(
                    color: AppColors.blackText, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CheckEligibilityWidegt extends ViewModelWidget<CalculatorViewModel> {
  const CheckEligibilityWidegt({
    Key key,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, CalculatorViewModel model) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.blue, borderRadius: BorderRadius.circular(6.0)),
      margin: const EdgeInsets.all(Spacing.smallMargin),
      child: AppExpansionTileWidget(
        title: "Check Your eligibility for loans",
        initiallyExpanded: false,
        active: model.eligibleOpen,
        onExpansionChanged: (bool value) {
          model.setEligibilityOpen(value);
        },
        backgroundColor: AppColors.blue,
        children: [
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey400, width: 1.0),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(Spacing.mediumMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  AppTextFeildOutlineWidget(
                    controller: model.loanController,
                    hintText: "Loan Amount",
                    textCapitalization: TextCapitalization.words,
                    fillColor: AppColors.white,
                    removeLeftPadding: true,
                    removeRightPadding: true,
                    textInputType: TextInputType.number,
                    onChanged: (e) {},
                    onSubmit: (e) {},
                  ),
                  SizedBox(height: 10),
                  AppTextFeildOutlineWidget(
                    controller: model.incomeController,
                    hintText: "Net Income Per Month",
                    textCapitalization: TextCapitalization.words,
                    fillColor: AppColors.white,
                    removeLeftPadding: true,
                    removeRightPadding: true,
                    textInputType: TextInputType.number,
                    onChanged: (e) {},
                    onSubmit: (e) {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "(Excluding LTA and Medical allowance)",
                      style: TextStyle(
                          fontSize: FontSize.small, color: AppColors.blackGrey),
                    ),
                  ),
                  SizedBox(height: 14),
                  AppTextFeildOutlineWidget(
                    controller: model.loanCommitController,
                    hintText: "Existing Loan Commitments (Per Month)",
                    textCapitalization: TextCapitalization.words,
                    fillColor: AppColors.white,
                    removeLeftPadding: true,
                    removeRightPadding: true,
                    textInputType: TextInputType.number,
                    onChanged: (e) {},
                    onSubmit: (e) {},
                  ),
                  SizedBox(height: 10),
                  AppTextFeildOutlineWidget(
                    controller: model.loanTenureController,
                    hintText: "Loan Tenure (Per Year)",
                    textCapitalization: TextCapitalization.words,
                    fillColor: AppColors.white,
                    removeLeftPadding: true,
                    removeRightPadding: true,
                    textInputType: TextInputType.number,
                    onChanged: (e) {},
                    onSubmit: (e) {},
                  ),
                  SizedBox(height: 10),
                  AppTextFeildOutlineWidget(
                    controller: model.rateonInterestController,
                    hintText: "Rate of Interest (%)",
                    textCapitalization: TextCapitalization.words,
                    fillColor: AppColors.white,
                    removeLeftPadding: true,
                    removeRightPadding: true,
                    textInputType: TextInputType.number,
                    onChanged: (e) {},
                    onSubmit: (e) {},
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppButtonWidget(
                          text: "Reset All",
                          color: AppColors.green,
                          onPressed: () {
                            model.resetAllClicked();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: AppButtonWidget(
                          text: "Check Eligibility",
                          color: AppColors.green,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            model.checkEligibility(onResult: (String text1,
                                String text2, String text3, bool suceess) {
                              if (text1.isNotEmpty) {
                                _showLoanEligibleResult(context, model, text1,
                                    text2, text3, suceess);
                              } else {
                                model.showSnackbar(
                                    "Something went wrong,Please try again");
                              }
                            });
                            //
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  _showLoanEligibleResult(BuildContext context, CalculatorViewModel model,
      String text1, String text2, String text3, bool suceess) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (_) => LoanEligibleResultWidget(
              text1: text1,
              text2: text2,
              text3: text3,
              suceess: suceess,
            ));
  }
}
