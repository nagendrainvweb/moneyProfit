import 'package:flutter/material.dart';
import 'package:moneypros/model/crif_loan_data.dart';
import 'package:moneypros/pages/card_type_view/card_type_details_viewModel.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';

class CardTypeListPage extends StatefulWidget {
  final List<CrifLoanData> loanList;
  final String type;
  final int totalAmount;
  final int head;

  const CardTypeListPage(
      {Key key, this.loanList, this.type, this.totalAmount, this.head})
      : super(key: key);
  @override
  _CardTypeListPageState createState() => _CardTypeListPageState();
}

class _CardTypeListPageState extends State<CardTypeListPage> {
  _getTypeRowWidget(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 11,
                color: AppColors.grey600,
                fontWeight: FontWeight.normal)),
        Text(desc,
            style: TextStyle(
                fontSize: 11,
                 fontFamily: "",
                color: AppColors.grey600,
                fontWeight: FontWeight.normal)),
      ],
    );
  }

  _getTopView(CardTypeListViewModel model) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.blueLightColor, AppColors.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: AppColors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.bigMargin, vertical: Spacing.mediumMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.type,
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (widget.head == 2)
                                ? "Total Outstanding Balance"
                                : "Total Current Balance",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            "${AppStrings.rupee} ${Utility.formatAmountToIndianCurrency( widget.totalAmount)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: "",
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_getHead()} Cards",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            "${widget.loanList.length}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                // CouponWidget(
                //   text: "Enter Coupon Code",
                //   onApplyClicked: model.applyClicked,
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getHead() {
    String head = "";
    switch (widget.head) {
      case 0:
        head = "Active";
        break;
      case 1:
        head = "Closed";
        break;
      case 2:
        head = "Overdue";
        break;
    }
    return head;
  }

  _getEncodedAccountNo(String text) {
    final length = text.length;
    String textx = "";
    for (int i = 1; i < length - 3; i++) {
      textx = textx + "x";
      if (i % 4 == 0) {
        textx = textx + " ";
      }
    }

    return text.replaceRange(0, text.length - 4, textx);
  }

  _getFormatedDate(String text) {
    final dateTime = Utility.parseServerDate(text);
    return Utility.formattedDeviceMonthDate(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CardTypeListViewModel>.reactive(
      viewModelBuilder: () => CardTypeListViewModel(),
      builder: (_, model, child) => Scaffold(
        body: Container(
          child: Column(
            children: [
              _getTopView(model),
              SizedBox(height: 10),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.mediumMargin,
                ),
                child: MediaQuery.removeViewPadding(
                  context: context,
                  removeTop: true,
                  child: ListView.separated(
                      separatorBuilder: (_, index) => Container(
                            height: 10,
                          ),
                      itemBuilder: (_, index) {
                        final CrifLoanData data = widget.loanList[index];
                        return GestureDetector(
                          onTap: () {
                            _showBottomSheetDetails(data);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.bigMargin,
                                vertical: Spacing.bigMargin),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.grey300, width: 1),
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.loanList[index].creditGuarantor
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.blackGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  _getEncodedAccountNo(data.accountNo),
                                  // "xxxx xxxxx xxxxx xx"+widget.loanList[index].accountNo.substring(widget.loanList[index].accountNo.length - 4),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.grey600,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: _getTypeRowWidget(
                                            "Current Balance",
                                            "${AppStrings.rupee} ${data.currentBalance}")),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: _getTypeRowWidget("Credit Limit",
                                            "${AppStrings.rupee} ${data.creditLimit.isEmpty ? "0" : data.creditLimit}")),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: _getTypeRowWidget(
                                            "Last Reported",
                                            _getFormatedDate(
                                                data.reportedDate))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: widget.loanList.length),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheetDetails(CrifLoanData data) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        builder: (_) => CardDetailsSheet(data: data));
  }
}

class CardDetailsSheet extends StatelessWidget {
  const CardDetailsSheet({
    Key key,
    @required this.data,
  }) : super(key: key);

  final CrifLoanData data;

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      icon: Icon(Icons.close, color: AppColors.grey800),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom:Spacing.bigMargin,
                      left:Spacing.bigMargin,
                      right: Spacing.bigMargin,
                        ),
                    child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.creditGuarantor.toUpperCase(),
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.blackGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          _getEncodedAccountNo(data.accountNo),
                          // "xxxx xxxxx xxxxx xx"+widget.loanList[index].accountNo.substring(widget.loanList[index].accountNo.length - 4),
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey600,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: _getTypeRowWidget("Current Balance",
                                    "${AppStrings.rupee} ${data.currentBalance}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("Credit Limit",
                                    "${AppStrings.rupee} ${data.creditLimit.isEmpty ? "0" : data.creditLimit}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("Last Reported",
                                    _getFormatedDate(data.reportedDate))),
                          ],
                        ),
                        SizedBox(height:15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: _getTypeRowWidget("Disbursed Amount",
                                    "${AppStrings.rupee} ${data.disbursedAmount}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("Ownership",
                                    "${data.ownershipInd}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("Disbursed Date",
                                    _getFormatedDate(data.disbursedDate))),
                          ],
                        ),
                        SizedBox(height:15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: _getTypeRowWidget("Installment Amount",
                                    "${AppStrings.rupee} ${data.installmentAmount}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("Overdue Amount",
                                    "${AppStrings.rupee} ${data.overdueAmount}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("Write off Amount",
                                    "${AppStrings.rupee} ${data.writeOfAmount}")),
                          ],
                        ),
                        SizedBox(height:15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: _getTypeRowWidget("Linked Account",
                                    "${data.linkedAccounts}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("Account Remarks",
                                    "${data.accountRemarks}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("Security Details",
                                    data.securityDetails.trim() )),
                          ],
                        ),
                        SizedBox(height:15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: _getTypeRowWidget("Repayment\nTenure",
                                    "${data.paymentTenure}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("Status",
                                    "${data.accountStatus}")),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: _getTypeRowWidget("",
                                    "" )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }

    _getTypeRowWidget(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 11,
                color: AppColors.grey600,
                
                fontWeight: FontWeight.normal)),
        Text(desc,
            style: TextStyle(
                fontSize: 12,
                fontFamily: "",
                color: AppColors.grey700,
                fontWeight: FontWeight.normal)),
      ],
    );
  }

   _getFormatedDate(String text) {
    final dateTime = Utility.parseServerDate(text);
    return Utility.formattedDeviceMonthDate(dateTime);
  }

    _getEncodedAccountNo(String text) {
    final length = text.length;
    String textx = "";
    for (int i = 1; i < length - 3; i++) {
      textx = textx + "x";
      if (i % 4 == 0) {
        textx = textx + " ";
      }
    }

    return text.replaceRange(0, text.length - 4, textx);
  }
}
