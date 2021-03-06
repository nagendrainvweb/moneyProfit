import 'package:flutter/material.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/pages/subscription/subscription_view_model.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:stacked/stacked.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionViewModel>.reactive(
      viewModelBuilder: () => SubscriptionViewModel(),
      builder: (_, model, chils) => Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              brightness: Brightness.light,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                "Subscription",
                style: TextStyle(color: AppColors.blackLight),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: AppColors.blackLight,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            preferredSize: Size.fromHeight(45)),
        body: Container(
          child: Center(
            child: AppButtonWidget(
              text: "PAY",
              onPressed: () {
                model.payClicked();
              },
            ),
          ),
        ),
      ),
    );
  }
}
