import 'package:flutter/material.dart';
import 'package:moneypros/pages/credit_scrore/credit_score.dart';
import 'package:moneypros/style/app_colors.dart';

class CrifHistoryPage extends StatefulWidget {
  final String date;

  const CrifHistoryPage({Key key, this.date}) : super(key: key);
  @override
  _CrifHistoryPageState createState() => _CrifHistoryPageState();
}

class _CrifHistoryPageState extends State<CrifHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("CRIF History",
              style: TextStyle(color: AppColors.blackGrey))),
      body: Container(
        child: CreditScoreWidget(historyDate: widget.date,),
      ),
    );
  }
}
