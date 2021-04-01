import 'package:flutter/material.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';

class AppListTile extends StatelessWidget {
  const AppListTile(
      {Key key,
      this.title,
      this.onTap,
      this.showTrailing = true,
      this.trilingIcon = Icons.chevron_right,
      this.onTrailingIconClicked,
      this.titleFontSize = 14})
      : super(key: key);

  final String title;
  final Function onTap, onTrailingIconClicked;
  final bool showTrailing;
  final IconData trilingIcon;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.white,
      onTap: onTap,
      minVerticalPadding: Spacing.defaultMargin,
      title: Text(
        title,
        style: TextStyle(color: AppColors.blackGrey, fontSize: titleFontSize),
      ),
      trailing: showTrailing
          ? GestureDetector(
              onTap: onTrailingIconClicked, child: Icon(trilingIcon))
          : null,
    );
  }
}

class AppFAQListTile extends StatelessWidget {
  const AppFAQListTile(
      {Key key, this.title, this.onTap, this.titleFontSize = 14, this.active, this.answer})
      : super(key: key);

  final String title;
  final String answer;
  final Function onTap;
  final double titleFontSize;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            tileColor: (active) ? AppColors.blue : AppColors.white,
            onTap: onTap,
            minVerticalPadding: Spacing.defaultMargin,
            title: Text(
              title,
              style: TextStyle(
                  color: (active) ? AppColors.white : AppColors.blackGrey,
                  fontSize: titleFontSize),
            ),
            trailing: Icon(
                (active) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: (active) ? AppColors.white : AppColors.grey600)),

        Visibility(visible: active, child: Container(
          color: AppColors.white,
          width: double.maxFinite,
          padding: const EdgeInsets.all(8.0),
          child: Text(answer,style: TextStyle(color:AppColors.grey800,fontSize: 12)),
        ))
      ],
    );
  }
}
