import 'package:flutter/material.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/font.dart';
import 'package:moneypros/style/spacing.dart';

class AppExpansionTileWidget extends StatelessWidget {
  final String title;
  final double fontSize;
  final backgroundColor;
  final bool initiallyExpanded;
  final List<Widget> children;
  final bool active;
  final Function onExpansionChanged;

  AppExpansionTileWidget(
      {Key key,
      this.title,
      this.fontSize = FontSize.normal,
      this.backgroundColor = AppColors.blue,
      this.initiallyExpanded,
      this.children, this.active, this.onExpansionChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          // border: Border.on(color: AppColors.grey400, width: 1.0),
          borderRadius: BorderRadius.circular(6.0)),
      // margin: const EdgeInsets.all(Spacing.smallMargin),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        trailing: Icon(
          (active)?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
          color: AppColors.white,
        ),
        onExpansionChanged: onExpansionChanged,
        title: Text(title,
            style: TextStyle(fontSize: fontSize, color: AppColors.white)),
        children: children,
      ),
    );
  }
}
