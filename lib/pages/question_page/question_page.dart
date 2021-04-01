import 'package:flutter/material.dart';
import 'package:moneypros/app_widegt/AppButton.dart';
import 'package:moneypros/app_widegt/AppTextFeildOutlineWidget.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';

class QuestionPage extends StatefulWidget {
  final String question;
  final List<String> options;
  final String buttonType;
  final int questionCount;

  const QuestionPage(
      {Key key,
      this.question,
      this.options,
      this.buttonType,
      this.questionCount})
      : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int selectedOption = -1;
  final _answerController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _getTopView() {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12) ),
            gradient: LinearGradient(
                colors: [AppColors.blueLightColor, AppColors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.bigMargin,
                  vertical: Spacing.mediumMargin),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Question  ${widget.questionCount}/3",
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getOptions() {
    return Column(
      children: List.generate(
        widget.options.length,
        (index) => OptionTile(
          // option: "The Botanical Gardens The Botanical",
          option: widget.options[index],
          selected: selectedOption == index,
          onTap: () {
            setState(() {
              selectedOption = index;
            });
          },
        ),
      ),
    );
  }

  _getTextFeild() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.defaultMargin,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: _answerController,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: "Answer",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      body: Container(
          child: Column(
        children: [
          _getTopView(),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // "What attraction in Mumbai is one of the largest in the world?",
                    "Q. ${widget.question}",
                    style: TextStyle(
                        color: AppColors.blackGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  (widget.buttonType == "R") ? _getOptions() : _getTextFeild(),
                  SizedBox(height: 15),
                  AppButtonWidget(
                    width: double.maxFinite,
                    text: "Submit",
                    color: AppColors.green,
                    onPressed: () {
                      if (widget.buttonType == "R") {
                        if (selectedOption == -1) {
                          showCustomSnackBar(context, "Please select answer");
                        } else {
                          Navigator.pop(context,widget.options[selectedOption]);
                        }
                      }else if(widget.buttonType == "T"){
                        if (_answerController.text.isEmpty) {
                          showCustomSnackBar(context, "Please write answer");
                        } else {
                          Navigator.pop(context,_answerController.text);
                        }
                      }else{
                         Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  showCustomSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content),behavior: SnackBarBehavior.floating, ), );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    Key key,
    this.onTap,
    this.option,
    this.selected,
  }) : super(key: key);

  final Function onTap;
  final String option;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Spacing.smallMargin),
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.bigMargin, vertical: Spacing.defaultMargin),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(child: Text("$option")),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: (selected) ? AppColors.green : AppColors.grey300,
                      width: 1.5),
                  color: (selected) ? AppColors.green : AppColors.white),
              child: Icon(
                Icons.check,
                size: 14,
                color: AppColors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
