import 'package:flutter/material.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';

class AppProfileHeading extends StatelessWidget {
  const AppProfileHeading({
    Key key, this.text1, this.text2,
  }) : super(key: key);
  final text1, text2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.bigMargin, vertical: Spacing.defaultMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: TextStyle(
                color: AppColors.orange,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
          Text(
            text2,
            style: TextStyle(
                color: AppColors.blue,
                fontSize: 32,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}