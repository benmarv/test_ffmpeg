import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'paypal_services.dart';

class PaypalPayment extends StatefulWidget {
  final Function? onFinish;

  final String? amount;
  const PaypalPayment({super.key, this.onFinish, required this.amount});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  final PaypalServices services = PaypalServices();
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };
  bool isEnableShipping = false;
  bool isEnableAddress = false;

  final String returnURL = 'return.example.com';
  final String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);

        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );
      }
    });
  }

  String itemName = 'Wallet Balance';
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": widget.amount,
        "currency": defaultCurrency["currency"]
      }
    ];

    String shippingCost = '0';
    int shippingDiscountCost = 0;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.amount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": widget.amount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  WebViewController controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return SafeArea(
        child: Scaffold(
          body: WebViewWidget(
              controller: controller
                ..loadRequest(Uri.parse('$checkoutUrl'))
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(NavigationDelegate(
                  onNavigationRequest: (NavigationRequest request) {
                    if (request.url.contains(returnURL)) {
                      final uri = Uri.parse(request.url);
                      final payerID = uri.queryParameters['PayerID'];
                      if (payerID != null) {
                        services
                            .executePayment(executeUrl, payerID, accessToken)
                            .then((id) {
                          widget.onFinish!(id, payerID);
                          toast("✔️ Payment done Successfully",
                              bgColor: Colors.black, textColor: Colors.white);
                        });
                      } else {
                        Navigator.pop(context);
                      }
                      // Navigator.pop(context);
                    }
                    if (request.url.contains(cancelURL)) {
                      Navigator.pop(context);
                    }
                    return NavigationDecision.navigate;
                  },
                ))),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: const Center(
            child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        )),
      );
    }
  }
}
