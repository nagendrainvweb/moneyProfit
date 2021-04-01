import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';

class AppNeumorpicTextFeild extends StatelessWidget {
  const AppNeumorpicTextFeild(
      {Key key,
      this.hintText,
      this.suffix,
      this.controller,
      this.textInputType,
      this.filled = true,
      this.obscureText = false,
      this.enableInteractiveSelection = true,
      this.enabled = true,
      this.maxLines = 1,
      this.style,
      this.textAlign = TextAlign.start,
      this.fillColor = AppColors.white,
      this.borderSide = const BorderSide(color: Colors.blue),
      this.borderRadius = 4.0,
      this.textCapitalization = TextCapitalization.none,
      this.focusNode,
      this.onChanged,
      this.validator,
      this.onSubmit,
      this.errorText,
      this.icon,
      this.removeLeftPadding = false,
      this.removeLeftContentPadding = false,
      this.showBorder = false, this.leftPadding=20.0})
      : super(key: key);

  final Widget suffix;
  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function(String) validator;
  final obscureText;
  final TextStyle style;
  final TextAlign textAlign;
  final Color fillColor;
  final bool filled;
  final TextCapitalization textCapitalization;
  final BorderSide borderSide;
  final double borderRadius;
  final Function(String) onChanged;
  final FocusNode focusNode;
  final Function(String) onSubmit;
  final int maxLines;
  final bool enabled;
  final bool enableInteractiveSelection;
  final IconData icon;
  final bool removeLeftPadding;
  final bool removeLeftContentPadding;
  final bool showBorder;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        margin: (!removeLeftPadding)
            ? EdgeInsets.symmetric(
                horizontal: Spacing.defaultMargin,
                vertical: Spacing.mediumMargin)
            : EdgeInsets.only(
                right: Spacing.defaultMargin,
                top: Spacing.mediumMargin,
                bottom: Spacing.mediumMargin,
              ),
        style: NeumorphicStyle(
            color: AppColors.white,
            intensity: 0.6,
            surfaceIntensity: 0.50,
            border: NeumorphicBorder(isEnabled: true),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
        child: Container(
            child: TextField(
          controller: controller,
          maxLines: maxLines,
          textAlign: textAlign,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          onSubmitted: onSubmit,
          obscureText: obscureText,
          keyboardType: textInputType,
          enableInteractiveSelection:
              enableInteractiveSelection, // will disable paste operation
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
            //labelText: (!showBorder)?null:hintText,
            border: InputBorder.none,
            //labelText:hintText,
            // :OutlineInputBorder(
            //   borderSide: BorderSide(color: AppColors.grey200),
            //   borderRadius: BorderRadius.circular(borderRadius)
            // ),
            //        focusedBorder: InputBorder.none,

            // errorBorder: InputBorder.none,
            // focusedErrorBorder: InputBorder.none,
            // enabledBorder: InputBorder.none,
            suffixIcon: suffix,
            contentPadding: EdgeInsets.only(
                left: (removeLeftContentPadding) ? 0 : leftPadding,
                top: 18,
                bottom: 18),
          ),
        ))
        //     ],
        //   ),
        // ),
        );
  }
}
