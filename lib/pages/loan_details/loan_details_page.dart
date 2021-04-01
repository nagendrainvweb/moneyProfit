import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moneypros/app_widegt/AppErrorWidget.dart';
import 'package:moneypros/app_widegt/app_tile.dart';
import 'package:moneypros/model/loan_data.dart';
import 'package:moneypros/pages/loan_details/loan_details_view_model.dart';
import 'package:moneypros/pages/webview_page/webview_page.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/urlList.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';

class LoanDetailsPage extends StatefulWidget {
  final String type;

  const LoanDetailsPage({Key key, this.type}) : super(key: key);
  @override
  _LoanDetailsPageState createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage> {
  _getTypeRowWidget(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 9,
                color: AppColors.grey600,
                fontWeight: FontWeight.normal)),
        SizedBox(height: 2),
        Text(desc,
            style: TextStyle(
                fontSize: 11,
                color: AppColors.grey600,
                fontWeight: FontWeight.normal)),
      ],
    );
  }

  _getLoanBanks(LoanDetailsViewModel model) {
    return Visibility(
      visible: model.comparisonList.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: Spacing.mediumMargin, vertical: Spacing.mediumMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Comparison",
                style: TextStyle(
                    color: AppColors.blackGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                separatorBuilder: (_, index) => Container(
                      height: 10,
                    ),
                itemBuilder: (_, index) {
                  final comprison = model.comparisonList[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.grey300, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.bigMargin,
                              vertical: Spacing.defaultMargin),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    child: CircleAvatar(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            child: Image.network(
                                              "${comprison.bankImg}",
                                              height: 30,
                                              width: 30,
                                              fit: (comprison.bankName ==
                                                      "indiabulls")
                                                  ? BoxFit.contain
                                                  : BoxFit.cover,
                                            )),
                                        backgroundColor: AppColors.grey200),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      comprison.bankName.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackGrey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: _getTypeRowWidget(
                                          "Interest Rate", comprison.intRate)),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  // Expanded(
                                  //     child: _getTypeRowWidget("Processing Fee",
                                  //         "${AppStrings.rupee}0.25 to ${AppStrings.rupee}1.00 + GST")),
                                  // SizedBox(
                                  //   width: 8,
                                  // ),
                                  Expanded(
                                      child: _getTypeRowWidget(
                                          "Loan Amount", comprison.loanAmt)),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                      child: _getTypeRowWidget(
                                          "Tenure Range", comprison.tenure)),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: _getTypeRowWidget("Processing Fee",
                                          comprison.procFees)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: AppColors.grey200,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: AppColors.grey200))),
                                child: TextButton(
                                    onPressed: () {
                                      _showEligibleDocumentSheet(model);
                                    },
                                    child: Text(
                                      "Eligible Documents",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10, color: AppColors.green),
                                    )),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    Utility.pushToNext(AppBrowserPage(
                                      url:UrlList.APPLY_NOW_LINK,
                                    ), context);
                                  },
                                  child: Text(
                                    "Apply Now",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10, color: AppColors.green),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: model.comparisonList.length),
          ],
        ),
      ),
    );
  }

  _showEligibleDocumentSheet(LoanDetailsViewModel model) {
    // myPrint("dats is " + model.eligibleDocData.salaried.length.toString());
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (_) =>
            EligibleDocumentWidget(eligibleDocData: model.eligibleDocData));
  }

  _getFAQ(LoanDetailsViewModel model) {
    return Visibility(
      visible: model.faqList.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: Spacing.mediumMargin, vertical: Spacing.mediumMargin),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "FAQ",
                style: TextStyle(
                    color: AppColors.blackGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
                children: List.generate(model.faqList.length, (index) {
              final faq = model.faqList[index];
              return Column(
                children: [
                  AppFAQListTile(
                    title: "Q. ${faq.question}",
                    answer: "${faq.answer}",
                    active: (index == model.selectedQuestion),
                    onTap: () {
                      model.setQuestionOpen(index);
                    },
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              );
            })),
          ],
        ),
      ),
    );
  }

  _getOverview(LoanDetailsViewModel model) {
    return Visibility(
      visible: model.overViewList.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: Spacing.mediumMargin, vertical: Spacing.mediumMargin),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Overview",
                style: TextStyle(
                    color: AppColors.blackGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
                children: List.generate(model.overViewList.length, (index) {
              final overview = model.overViewList[index];
              return Column(
                children: [
                  AppListTile(
                    title: overview.title,
                    onTap: () {
                      _showBottomSheet(overview);
                    },
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              );
            })),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(Overview overView) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (_) => Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppListTile(
                    title: overView.title,
                    trilingIcon: Icons.close,
                    onTrailingIconClicked: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    height: 1,
                    color: AppColors.grey200,
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        AppListTile(
                          titleFontSize: 12,
                          showTrailing: false,
                          title: overView.desc,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoanDetailsViewModel>.reactive(
      viewModelBuilder: () => LoanDetailsViewModel(),
      onModelReady: (model) {
        myPrint("type is ${widget.type}");
        model.initData(widget.type);
      },
      builder: (_, model, child) => Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title:
              Text(widget.type, style: TextStyle(color: AppColors.blackGrey)),
        ),
        body: (model.loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (model.hasError)
                ? AppErrorWidget(
                    message: SOMETHING_WRONG_TEXT,
                    onRetryCliked: () {
                      model.fetchLoanDetails();
                    })
                : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _getLoanBanks(model),
                          _getOverview(model),
                          _getFAQ(model),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

class EligibleDocumentWidget extends StatefulWidget {
  final EligibleDocData eligibleDocData;
  const EligibleDocumentWidget({
    Key key,
    this.eligibleDocData,
  }) : super(key: key);

  @override
  _EligibleDocumentWidgetState createState() => _EligibleDocumentWidgetState();
}

class _EligibleDocumentWidgetState extends State<EligibleDocumentWidget> {
  int _selectedTab = 0;

  _getTabView(List<DocData> list) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              list.length,
              (index) => Container(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[index].title,
                          style: TextStyle(
                              color: AppColors.blackGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          list[index].desc,
                          style: TextStyle(
                              color: AppColors.grey700,
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.defaultMargin, vertical: Spacing.smallMargin),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTabController(
                length: 2,
                child: TabBar(
                  labelColor: AppColors.grey700,
                  isScrollable: true,
                  onTap: (int value) {
                    setState(() {
                      _selectedTab = value;
                    });
                  },
                  tabs: [
                    Tab(
                      child: Text("Salaried"),
                    ),
                    Tab(
                      child: Text("Self Employed"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  child: (_selectedTab == 0)
                      ? _getTabView(widget.eligibleDocData.salaried)
                      : _getTabView(widget.eligibleDocData.selfEmployed),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              child: IconButton(
                icon: Icon(Icons.close, color: AppColors.grey700),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
