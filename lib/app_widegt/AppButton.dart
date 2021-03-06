import 'package:flutter/material.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({
    Key key, this.onPressed, this.width, this.borderRadius= 6.0, this.text,
  }) : super(key: key);
  final Function onPressed;
  final double width;
  final double borderRadius;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: width,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      padding: const EdgeInsets.symmetric(vertical: Spacing.defaultMargin),
      textColor: AppColors.white,
      color: AppColors.orange,
      child: Text(text),
    );
  }
}
