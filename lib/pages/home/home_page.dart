import 'package:flutter/material.dart';
import 'package:moneypros/pages/home/component/credit_meter.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MoneyPros"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            height: 250,
            //width: 100,
            child: CreditMeterWidget(
              creditScore: 810,
            ),
          ),
        ),
      ),
    );
  }


}

