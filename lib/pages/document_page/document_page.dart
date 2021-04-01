import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppErrorWidget.dart';
import 'package:moneypros/model/user_doc_data.dart';
import 'package:moneypros/pages/document_page/document_view_model.dart';
import 'package:moneypros/pages/full_image/full_image_view.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/urlList.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'dart:math';

import 'package:stacked_services/stacked_services.dart';

class DocumentPage extends StatefulWidget {
  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    final userRepo = Provider.of<UserRepo>(context, listen: false);
    return ViewModelBuilder<DocumentViewModel>.reactive(
      viewModelBuilder: () => DocumentViewModel(),
      onModelReady: (model) {
        model.initData(userRepo);
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title:
              Text("Documents", style: TextStyle(color: AppColors.blackGrey)),
        ),
        body: (model.loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (model.hasError)
                ? AppErrorWidget(
                    message: SOMETHING_WRONG_TEXT,
                    onRetryCliked: () {
                      model.fetchUserDocuments();
                    })
                
                : Container(
                    child: Stack(
                      children: [
                       (model.docList.isEmpty)?
                  Container(
                    child:Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Center(
                        child:Text("You do not have any documents,\nPlease Click + button to upload documents",
                        textAlign: TextAlign.center,
                        style:TextStyle(color:AppColors.grey700,fontSize:18),
                        )
                      ),
                    )
                  ) :Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.smallMargin),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: itemWidth / 250),
                            itemCount: model.docList.length,
                            itemBuilder: (context, index) => DocWidget(
                              doc: model.docList[index],
                              // onMenuClicked: (TapDownDetails details) {
                              //   _showPopupMenu(details.globalPosition);
                              // },
                              onDocClicked: () {
                                _showActionSheet(index, model);
                              },
                            ),
                          ),
                        ),
                        ShortcutContactWidget(
                          isConatctOpen: model.addOpen,
                          onButtonClicked: () {
                            model.addButtonClicked();
                          },
                          onIdClicked: (String type) {
                            model.addButtonClicked();
                            _showGalleryDialog(model, type, context);
                          },
                        )
                      ],
                    ),
                  ),
      ),
    );
  }

  _showActionSheet(int index, DocumentViewModel model) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (_) => Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      // _showGalleryDialog(model,Utility.getDocTypeForDevice(model.docList[index].documentType), context);
                      locator<NavigationService>().navigateToView(ImageViewPage(images: [model.docList[index].documentImage], name: Utility.getDocTypeForDevice(
                              model.docList[index].documentType)));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.visibility_outlined,color: AppColors.grey800, ),
                        // SizedBox(width:8),
                        Text("View", style: TextStyle(color: AppColors.grey700))
                      ],
                    ),
                  ),
                  Container(height: 1, color: AppColors.grey200),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _showGalleryDialog(
                          model,
                          Utility.getDocTypeForDevice(
                              model.docList[index].documentType),
                          context);
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.delete_outline,color: AppColors.grey800,size:22 ),
                        // SizedBox(width:8),
                        Text("Update",
                            style: TextStyle(color: AppColors.grey700))
                      ],
                    ),
                  ),
                  Container(height: 1, color: AppColors.grey200),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      model.deleteDocument(index);
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.update_outlined,color: AppColors.grey800, ),
                        // SizedBox(width:8),
                        Text("Delete",
                            style: TextStyle(color: AppColors.grey700))
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: Text('View'),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text('Delete'),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text('Update'),
        ),
      ],
      elevation: 8.0,
    );
  }

  _showGalleryDialog(
      DocumentViewModel model, String type, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                    onTap: () async {
                      model.getImage(1, type, context);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.collections),
                    title: Text('Gallery'),
                    onTap: () {
                      model.getImage(2, type, context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ShortcutContactWidget extends StatelessWidget {
  const ShortcutContactWidget({
    Key key,
    this.isConatctOpen,
    this.onIdClicked,
    this.onButtonClicked,
  }) : super(key: key);

  final bool isConatctOpen;
  final Function onIdClicked;
  final Function onButtonClicked;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            (isConatctOpen) ? _contactWidget() : Container(),
            FloatingActionButton(
                elevation: 0,
                onPressed: () {
                  onButtonClicked();
                },
                child: Transform.rotate(
                    angle: (isConatctOpen) ? 180 * pi / 105 : 180 * pi / 90,
                    child: Icon(Icons.add))),
          ],
        ),
      ),
    );
  }

  _contactWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          _singleWidget(
              "Pan Card", Icons.image_rounded, Colors.brown, onIdClicked),
          SizedBox(height: 10),
          _singleWidget("Aadhar Card", Icons.image_rounded, Colors.redAccent,
              onIdClicked),
          SizedBox(height: 10),
          _singleWidget("Driving license", Icons.image_rounded,
              Colors.grey.shade800, onIdClicked),
          SizedBox(height: 10),
          _singleWidget(
              "Voter Id", Icons.image_rounded, Colors.orange, onIdClicked),
          SizedBox(height: 10),
          _singleWidget(
              "Passport", Icons.image_rounded, Colors.green, onIdClicked),
          SizedBox(height: 10),
          _singleWidget("Ration Card", Icons.image_rounded, Colors.blueAccent,
              onIdClicked),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  _singleWidget(var title, var icon, var color, Function onButtonCliked) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              onButtonCliked(title);
            },
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black54),
                child: Text(title, style: TextStyle(color: Colors.white))),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              onButtonCliked(title);
            },
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                padding: EdgeInsets.all(10),
                child: Icon(icon, color: Colors.white)),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }
}

class DocWidget extends StatelessWidget {
  final UserDocData doc;
  final onDocClicked;
  final String type;
  final Function onMenuClicked;

  const DocWidget(
      {Key key, this.doc, this.onDocClicked, this.type, this.onMenuClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type = Utility.getDocTypeForDevice(doc.documentType);
    return GestureDetector(
      onTap: onDocClicked,
      child: Neumorphic(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        style: NeumorphicStyle(
          intensity: 0.4,
          color: AppColors.grey200,
          border: NeumorphicBorder(isEnabled: true, color: AppColors.grey300),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child:
                            // Image.file(
                            //   doc,
                            //   fit: BoxFit.cover,
                            // ),
                            CachedNetworkImage(
                          imageUrl:
                              "${UrlList.DOC_IMAGE_URL}${doc.documentImage}",
                          placeholder: (context, data) {
                            return Container(
                              child: new Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: new CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorWidget: (context, value, data) => Container(
                            child: Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.redAccent.shade400,
                              ),
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${type}", textScaleFactor: 0.9),
                      ],
                    ),
                  )
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     padding: const EdgeInsets.all(8),
              //     decoration: BoxDecoration(
              //         color: Colors.black54,
              //         borderRadius: BorderRadius.only(
              //             topRight: Radius.circular(8))),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         //Text("Pan Card",style:TextStyle(color:AppColors.white) )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
