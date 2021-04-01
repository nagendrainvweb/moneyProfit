import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/urlList.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewPage extends StatefulWidget {
  final List<String> images;
  final name;
  ImageViewPage({@required this.images, @required this.name});
  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  int currentPosition = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          elevation: 0,
         // backgroundColor: Colors.transparent,
          title: Text(
            '${widget.name}',
            style:TextStyle(color:AppColors.blackGrey)
          ),
          leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Stack(
          children: <Widget>[
            Container(
                child: (widget.images.length > 1)
                    ? CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        height: double.infinity,
                        onPageChanged: (position,value) {
                          setState(() {
                            currentPosition = position;
                          });
                        },
                      ),
                        
                        items: widget.images.map((image) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: PhotoView(
                                    backgroundDecoration:
                                        BoxDecoration(color: Colors.white),
                                    imageProvider: NetworkImage(Uri.encodeFull(UrlList.DOC_IMAGE_URL + image)),
                                    initialScale:
                                        PhotoViewComputedScale.contained * 1.0,
                                  ));
                            },
                          );
                        }).toList(),
                      )
                    : PhotoView(
                        backgroundDecoration:
                            BoxDecoration(color: Colors.white),
                        imageProvider: NetworkImage(Uri.encodeFull(UrlList.DOC_IMAGE_URL+ widget.images[0])),
                        initialScale: PhotoViewComputedScale.contained * 1,
                      )),
            (widget.images.length > 1)
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.transparent,
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                              (widget.images.length > 0)
                                  ? widget.images.length
                                  : 1, (position) {
                            return Container(
                              margin: const EdgeInsets.only(left: 2),
                              child: Text('•',
                                  style: TextStyle(
                                      fontSize: (currentPosition == position)
                                          ? 35
                                          : 35,
                                      fontWeight: FontWeight.bold,
                                      color: (currentPosition == position
                                          ? Colors.grey
                                          : Colors.grey.shade300))),
                            );
                          })),
                    ),
                  )
                : Container(),
          ],
        ),
    );
  }
}
