import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:moneypros/model/payment_data.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/urlList.dart';
import 'package:moneypros/utils/utility.dart';

class PaymentPage extends StatefulWidget {
  final String paymentUrl;
  final ReturnElements elements;

  const PaymentPage({Key key, this.paymentUrl, this.elements})
      : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  InAppWebViewController _webViewController;
  bool _loadingPayment = true;
  String _responseStatus = STATUS_LOADING;

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }

  String _loadHTML() {
    ReturnElements elements = widget.elements;
    String data = "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='${widget.paymentUrl}'>" +
        "<input type='hidden' name='me_id' value='${elements.meId}'/>" +
        "<input  type='hidden' name='txn_details' value='${elements.txnDetails}' />" +
        "<input  type='hidden' name='pg_details' value='${elements.pgDetails}' />" +
        "<input type='hidden' name='card_details' value='${elements.cardDetails}' />" +
        "<input type='hidden' name='cust_details' value='${elements.custDetails}' />" +
        "<input type='hidden' name='bill_details' value='${elements.billDetails}' />" +
        "<input type='hidden' name='ship_details' value='${elements.shipDetails}' />" +
        "<input type='hidden' name='item_details' value='${elements.itemDetails}' />" +
        "<input type='hidden' name='other_details' value='${elements.otherDetails}' />" +
        "</form> </body> </html>";

    return data;
  }

  void getData() {
    _webViewController.evaluateJavascript(source: "document.body.innerText")
        //.evaluateJavascript(sou "document.body.innerText")
        .then((data) {
      //final decodedJson = jsonDecode(data);
      Navigator.pop(context, data);
    });
  }

  Widget getResponseScreen() {
    switch (_responseStatus) {
      case STATUS_SUCESSFUL:
        return PaymentSuccessfulScreen();
      case STATUS_CHECKSUM_FAILED:
        return CheckSumFailedScreen();
      case STATUS_FAILED:
        return PaymentFailedScreen();
    }
    return PaymentSuccessfulScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(),
        body: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Stack(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: InAppWebView(
                    // initialUrlRequest:
                    //   URLRequest(url: Uri.parse("https://google.com")),
                    initialUrlRequest: URLRequest(
                        url: Uri.dataFromString(_loadHTML(),
                            mimeType: 'text/html')),
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

                    onLoadStop:
                        (InAppWebViewController controller, Uri page) async {
                      myPrint(page.toString());
                      // getData();
                      // if (page.contains("/payment.php")) {
                      if (page.toString().contains(
                          "https://www.avantgardepayments.com/agcore/payment")) {
                        if (_loadingPayment) {
                          this.setState(() {
                            _loadingPayment = false;
                          });
                        }
                      }
                      if (page.toString().contains(
                          "https://moneypro-s.com/webservices/response_payment")) {
                        getData();
                      }

                      if (page.toString().contains(
                          "https://www.avantgardepayments.com/agcore/redirectedUrlForError")) {
                        Navigator.pop(context);
                      }
                    },
                  )),
              (_loadingPayment)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(),
              (_responseStatus != STATUS_LOADING)
                  ? Center(child: getResponseScreen())
                  : Center()
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentSuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Great!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Thank you making the payment!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "OOPS!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Payment was not successful, Please try again Later!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CheckSumFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Oh Snap!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
