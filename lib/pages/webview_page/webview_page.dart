import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/utils/utility.dart';

class AppBrowserPage extends StatefulWidget {
  final String url;

  const AppBrowserPage({
    Key key,
    this.url,
  }) : super(key: key);
  @override
  _AppBrowserPageState createState() => _AppBrowserPageState();
}

class _AppBrowserPageState extends State<AppBrowserPage> {
  InAppWebViewController _webViewController;
  bool _loadingPayment = true;

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }

  // void getData() {
  //   _webViewController.evaluateJavascript(source: "document.body.innerText")
  //       //.evaluateJavascript(sou "document.body.innerText")
  //       .then((data) {
  //     //final decodedJson = jsonDecode(data);
  //     Navigator.pop(context, data);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
           color: AppColors.white
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: InAppWebView(
                  // initialUrlRequest:
                  //   URLRequest(url: Uri.parse("https://google.com")),
                  initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),

                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: false,
                      ),
                      android: AndroidInAppWebViewOptions(),
                      ios: IOSInAppWebViewOptions()),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, Uri page) {
                    if (!page.toString().contains(widget.url)) {
                      Navigator.pop(context);
                    }
                  },

                  onLoadStop:
                      (InAppWebViewController controller, Uri page) async {
                    myPrint(page.toString());
                    // getData();
                    // if (page.contains("/payment.php")) {
                    if (page.toString().contains(widget.url)) {
                      if (_loadingPayment) {
                        this.setState(() {
                          _loadingPayment = false;
                        });
                      }
                    }
                  },
                )),
            (_loadingPayment)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
