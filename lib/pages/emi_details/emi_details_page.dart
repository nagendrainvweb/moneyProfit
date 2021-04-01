import 'package:flutter/material.dart';
import 'package:moneypros/model/emi_data.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';

class EmiDetailsPage extends StatefulWidget {
  final List<EMIData> emiList;

  const EmiDetailsPage({Key key, this.emiList}) : super(key: key);
  @override
  _EmiDetailsPageState createState() => _EmiDetailsPageState();
}

class _EmiDetailsPageState extends State<EmiDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EMI Details",style: TextStyle(color: AppColors.blackGrey),),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                child: ListView.separated(
                    itemBuilder: (_, index) => Container(
                        decoration: BoxDecoration(
                            //color: Colors.grey.shade100,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.defaultMargin,
                            vertical: Spacing.defaultMargin),
                        margin: const EdgeInsets.symmetric(
                            horizontal: Spacing.smallMargin, vertical: 2),
                        child: Column(
                          children: [
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: EmiTile(
                                    title: "Payment No",
                                    value: "${index+1}",
                                  ),
                                ),
                                Expanded(
                                  child: EmiTile(
                                    title: "Begining Balance",
                                    value:
                                        "${widget.emiList[index].beggingBalance}",
                                  ),
                                ),
                                Expanded(
                                  child: EmiTile(
                                    title: "EMI",
                                    value: "${widget.emiList[index].emi}",
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                             
                              children: [
                                Expanded(
                                  child: EmiTile(
                                    title: "Principal",
                                    value: "${widget.emiList[index].principal}",
                                  ),
                                ),
                                Expanded(
                                  child: EmiTile(
                                    title: "Interest",
                                    value: "${widget.emiList[index].interest}",
                                  ),
                                ),
                                Expanded(
                                  child: EmiTile(
                                    title: "Ending Balance",
                                    value: "${widget.emiList[index].endingBalance}",
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                    separatorBuilder: (_, index) =>
                        Container(height: 1, color: AppColors.white),
                    itemCount: widget.emiList.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmiTile extends StatelessWidget {
  const EmiTile({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  final title, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$title",
           textScaleFactor: 0.8,
          style: TextStyle(color: AppColors.grey600),
        ),
        SizedBox(height: 8),
        Text(
          "$value",
          textScaleFactor: 0.9,
          style: TextStyle(color: AppColors.blackGrey),
        ),
      ],
    );
  }
}
