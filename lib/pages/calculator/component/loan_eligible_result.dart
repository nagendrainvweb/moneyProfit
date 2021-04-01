import 'package:flutter/material.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';

class LoanEligibleResultWidget extends StatelessWidget {
  const LoanEligibleResultWidget({
    Key key, this.text1, this.text2, this.text3, this.suceess,
  }) : super(key: key);

  final String text1, text2, text3;
  final bool suceess;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Text(
              //     "How much loan you are eligible for?",
              //     textAlign: TextAlign.left,
              //     textScaleFactor: 1.1,
              //     style: TextStyle(color: AppColors.blackLight),
              //   ),
              //   SizedBox(height: 5),
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.blackGrey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: (suceess) ? AppColors.green : AppColors.redAccent,
                      width: 2)),
              padding: const EdgeInsets.all(8),
              child: Icon(
                (suceess) ? Icons.check_outlined : Icons.close,
                color: (suceess) ? AppColors.green : AppColors.redAccent,
                size: 30,
              )),
          Padding(
            padding: const EdgeInsets.all(Spacing.defaultMargin),
            child: Column(
              children: [
                
                Text(
                  text1,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.1,
                  style: TextStyle(color: AppColors.blackLight),
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: text2.isNotEmpty,
                  child: Column(
                    children: [
                      Text(text2,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.3,
                          style: TextStyle(color: AppColors.blue)),
                      SizedBox(height: 16),
                    ],
                  ),
                ),

                Text(text3,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.1,
                    style: TextStyle(color: AppColors.blackGrey)),
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}