import 'package:flutter/material.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppErrorWidget.dart';
import 'package:moneypros/model/crif_account_summery.dart';
import 'package:moneypros/model/crif_loan_data.dart';
import 'package:moneypros/pages/card_type_view/card_type_widget.dart';
import 'package:moneypros/pages/credit_scrore/credit_score_view_model.dart';
import 'package:moneypros/pages/home/component/credit_meter.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class CreditScoreWidget extends StatefulWidget {
  final String historyDate;

  const CreditScoreWidget({Key key, this.historyDate = ""}) : super(key: key);
  @override
  _CreditScoreWidgetState createState() => _CreditScoreWidgetState();
}

class _CreditScoreWidgetState extends State<CreditScoreWidget> {
  _getMeterWithScore(CreditScoreViewModel model) {
    return Container(
      height: 200,
      child: Stack(
        children: [
          CreditMeterWidget(
            creditScore: model.score.toDouble(),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder<int>(
                initialData: 0,
                stream: model.animateScore(),
                builder: (_, AsyncSnapshot<int> snapshot) => Text(
                    "${snapshot.data}",
                    textScaleFactor: 1.6,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.blackGrey,
                        fontWeight: FontWeight.bold)),
              ))
        ],
      ),
    );
  }

  _getDays(int daysLeft) {
    String leftDays = "";
    if (daysLeft <= 0) {
      leftDays = " Available now";
    } else {
      leftDays = "Available in $daysLeft days";
    }
    return leftDays;
  }

  _getDateRefreshButtonWidget(CreditScoreViewModel model) {
    return Container(
      child: Column(
        children: [
          Text("Details as on : ${model.asonDate}",
              style: TextStyle(color: AppColors.grey600, fontSize: 12)),
          Visibility(
            visible: widget.historyDate.isEmpty,
            child: Text(" ${_getDays(model.daysLeft)} ",
                style: TextStyle(color: AppColors.grey600, fontSize: 11)),
          ),
          Visibility(
            visible: widget.historyDate.isEmpty,
            child: IconButton(
                onPressed: (model.daysLeft <= 0)
                    ? () {
                        if (model.daysLeft <= 0) {
                          model.fetchCrifDataFromServer();
                        }
                      }
                    : null,
                color: AppColors.green,
                // textColor: AppColors.white,
                // elevation: 0,
                icon: Icon(Icons.refresh)),
          )
        ],
      ),
    );
  }

  _getCrifBalanceWidget(CreditScoreViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.defaultMargin),
      child: Row(
        children: [
          Expanded(
            child: CrifAmountCard(
              amount: model.crifData.accountSummary.primaryCurrentBalance,
              title: "Current Balance",
              image: ImageAsset.currentBalance,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: CrifAmountCard(
              amount: model.crifData.accountSummary.primaryDisbursedAmount,
              title: "Amount Disbursed",
              image: ImageAsset.amountDis,
            ),
          )
        ],
      ),
    );
  }

  _getTypeTabWidget(CreditScoreViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.defaultMargin, vertical: Spacing.defaultMargin),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: AccountType(
                active: (model.currentTab == 2),
                onTap: () {
                  model.onTabClicked(2);
                },
                title: "Overdue (${model.crifData.overdueTypeList.length})",
              )),
              SizedBox(
                width: 6,
              ),
              Expanded(
                  child: AccountType(
                active: (model.currentTab == 0),
                onTap: () {
                  model.onTabClicked(0);
                },
                title: "Active (${model.crifData.activeTypeList.length})",
              )),
              SizedBox(
                width: 6,
              ),
              Expanded(
                  child: AccountType(
                active: (model.currentTab == 1),
                onTap: () {
                  model.onTabClicked(1);
                },
                title: "Closed (${model.crifData.closeTypeList.length})",
              )),
            ],
          ),
        ],
      ),
    );
  }

  _getTypeTileWidget(CreditScoreViewModel model, List<String> typeList,
      List<CrifLoanData> loanList) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1;

    return (typeList.length > 0)
        ? Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.mediumMargin,
            ),
            child: GridView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: (itemWidth / 380)),
                itemCount: typeList.length,
                itemBuilder: (_, index) {
                  final type = typeList[index];
                  int amount = 0;
                  loanList.forEach((element) {
                    if (element.accountType == type) {
                      final balance =
                          int.parse(element.currentBalance.replaceAll(",", ""));
                      amount = amount + balance;
                    }
                  });

                  return CrifCardTypeTile(
                    title: type,
                    amount: Utility.formatAmountToIndianCurrency(amount),
                    date: model.asonDate,
                    image: Utility.getLoanTypeImagePath(type),
                    head: model.currentTab,
                    onTap: () {
                      final list = loanList
                          .where((element) => (element.accountType == type))
                          .toList();
                      Utility.pushToNext(
                          CardTypeListPage(
                            loanList: list,
                            type: type,
                            totalAmount: amount,
                            head: model.currentTab,
                          ),
                          context);
                    },
                  );
                }),
          )
        : Center(
            child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "No data found",
              style: TextStyle(color: AppColors.grey600),
            ),
          ));
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepo>(context);
    return ViewModelBuilder<CreditScoreViewModel>.reactive(
        viewModelBuilder: () => CreditScoreViewModel(),
        onModelReady: (CreditScoreViewModel model) {
          model.initData(userRepo, widget.historyDate);
          //  model.animateScore();
          //model.initData(userRepo);
        },
        builder: (_, model, child) => Container(
            child: (model.isBusy)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (model.hasError)
                    ? AppErrorWidget(
                        message: SOMETHING_WRONG_TEXT,
                        onRetryCliked: () {
                          model.fetchCrifData();
                        })
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "CRIF Score",
                              textScaleFactor: 2,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 3),
                            Text(
                                "${userRepo.userDetails.firstName} ${userRepo.userDetails.lastName}",
                                textScaleFactor: 1.2,
                                style: TextStyle(color: AppColors.grey600)),
                            SizedBox(height: 5),
                            _getMeterWithScore(model),
                            SizedBox(height: 5),
                            _getDateRefreshButtonWidget(model),
                            SizedBox(
                              height: 20,
                            ),
                            _getCrifBalanceWidget(model),
                            SizedBox(
                              height: 20,
                            ),
                            _getTypeTabWidget(model),
                            _getTypeTileWidget(model, _getTypeList(model),
                                _getLoanList(model)),
                          ],
                        ),
                      )));
  }

  List<String> _getTypeList(CreditScoreViewModel model) {
    List<String> list;
    switch (model.currentTab) {
      case 0:
        list = model.crifData.activeTypeList;
        break;
      case 1:
        list = model.crifData.closeTypeList;
        break;
      case 2:
        list = model.crifData.overdueTypeList;
        break;
    }
    return list;
  }
}

List<CrifLoanData> _getLoanList(CreditScoreViewModel model) {
  List<CrifLoanData> list;
  switch (model.currentTab) {
    case 0:
      list = model.crifData.activeList;
      break;
    case 1:
      list = model.crifData.closedList;
      break;
    case 2:
      list = model.crifData.overdueList;
      break;
  }
  return list;
}

class CrifCardTypeTile extends StatelessWidget {
  const CrifCardTypeTile({
    Key key,
    this.onTap,
    this.title,
    this.amount,
    this.date,
    this.head, this.image,
  }) : super(key: key);

  final Function onTap;
  final title;
  final amount;
  final date;
  final String image;
  final int head;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Spacing.halfSmallMargin,
                vertical: Spacing.halfSmallMargin),
            padding: const EdgeInsets.only(
              left: Spacing.defaultMargin,
              right: Spacing.smallMargin,
              top: Spacing.defaultMargin,
              bottom: Spacing.defaultMargin,
            ),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey300, width: 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                )),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Image.asset(
                      image,
                      height: 32,
                      width: 32,
                    ),
                    // Icon(
                    //   Icons.credit_card,
                    //   color: AppColors.green,
                    // ),
                    SizedBox(height: 4),
                    Text("$title",
                        style: TextStyle(
                            color: AppColors.blackGrey,
                            fontWeight: FontWeight.bold)),
                    Text(
                      "${AppStrings.rupee} $amount",
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        fontFamily: "",
                      ),
                    ),
                    Spacer(),
                    Text("as on $date",
                        style:
                            TextStyle(color: AppColors.grey400, fontSize: 11))
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    //padding: const EdgeInsets.all(3),
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   color: AppColors.grey200,
                    // ),
                    child: Icon(Icons.keyboard_arrow_right,
                        color: AppColors.grey700, size: 18),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                  color: (head == 0)
                      ? AppColors.green
                      : (head == 1)
                          ? Colors.yellow
                          : Colors.red,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6))),
              margin: const EdgeInsets.symmetric(
                  horizontal: 5, vertical: Spacing.halfSmallMargin),
              width: 2.5,
              height: double.maxFinite,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountType extends StatelessWidget {
  const AccountType({
    Key key,
    this.title,
    this.active,
    this.onTap,
  }) : super(key: key);

  final title;
  final bool active;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.mediumMargin, vertical: Spacing.smallMargin),
        decoration: BoxDecoration(
            color: (active) ? AppColors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Text(
              "$title",
              textScaleFactor: 0.8,
              style: TextStyle(
                color: (active) ? AppColors.white : AppColors.blackGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CrifAmountCard extends StatelessWidget {
  const CrifAmountCard({
    Key key,
    @required this.amount,
    this.title,
    this.image,
  }) : super(key: key);

  final String amount;
  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppColors.kBlueDarkColor, AppColors.blue])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
            child: Image.asset(image,
            height: 32,
            width: 32,
            )
            // Icon(
            //   Icons.credit_card,
            //   color: AppColors.orange,
            // ),
          ),
          SizedBox(height: 18),
          RichText(
            textScaleFactor: 1.3,
            text: TextSpan(text: AppStrings.rupee, children: [
              TextSpan(
                  text: "$amount",
                  style: TextStyle(
                      //// fontSize: 20,
                      fontFamily: "",
                      color: AppColors.white))
            ]),
          ),
          SizedBox(height: 8),
          Text(
            "$title",
            style: TextStyle(color: AppColors.white, fontSize: 11),
          )
        ],
      ),
    );
  }
}
