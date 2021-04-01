import 'package:flutter/material.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({
    Key key,
    this.onPressed,
    this.width,
    this.borderRadius = 6.0,
    this.text,
    this.color = AppColors.blue,
    this.isBig = true,
  }) : super(key: key);
  final Function onPressed;
  final double width;
  final double borderRadius;
  final String text;
  final Color color;
  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
         gradient:(color == AppColors.blue)? LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.kBlueDarkColor, AppColors.blue]):null
      ),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: width,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        padding: EdgeInsets.symmetric(
            vertical: (isBig) ? Spacing.defaultMargin : Spacing.mediumMargin),
        textColor: AppColors.white,
        color: (color == AppColors.blue)?null:color,
        child: Text(text),
      ),
    );
  }
}
