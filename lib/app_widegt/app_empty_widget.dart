import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/utils/utility.dart';


class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({
    Key key, this.msg,
  }) : super(key: key);

  final msg;
  @override
  Widget build(BuildContext context) {
    return Center(
     child: Container(
       padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
       children: [
           SvgPicture.asset(
             ImageAsset.missing,
             height: 300,
            ),
         SizedBox(height: 10,),
         Text(msg??'No Data Found',textScaleFactor: 1.2,style: TextStyle(color:CustomColor.blackGrey),)
       ], 
      ), 
     ), 
    );
  }
}