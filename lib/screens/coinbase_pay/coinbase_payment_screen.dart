// ignore_for_file: unused_import, unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:link_on/screens/coinbase_pay/coinbase_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  final CoinbasePaymentService _coinbaseService = CoinbasePaymentService();
  String _paymentUrl = '';

  Future<void> _createPayment() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid amount',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _coinbaseService.createCharge(amount);

    setState(() {
      _isLoading = false;
    });

    if (response.isNotEmpty) {
      // Get the hosted URL from the response to open in WebView
      setState(() {
        _paymentUrl = response['data']['hosted_url'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create payment request')),
      );
    }
  }

  WebViewController controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Coinbase Payment')),
      body: SafeArea(
        child: Scaffold(
          body: WebViewWidget(
              controller: controller
                ..loadRequest(Uri.parse('$_paymentUrl'))
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(NavigationDelegate(
                  onNavigationRequest: (NavigationRequest request) {
                    // if (request.url.contains(returnURL)) {
                    //   final uri = Uri.parse(request.url);
                    //   final payerID = uri.queryParameters['PayerID'];
                    //   if (payerID != null) {
                    //     // services
                    //     //     .executePayment(executeUrl, payerID, accessToken)
                    //     //     .then((id) {
                    //     //   widget.onFinish!(id, payerID);
                    //     //   toast("✔️ Payment done Successfully",
                    //     //       bgColor: Colors.black, textColor: Colors.white);
                    //     // });
                    //   } else {
                    //     Navigator.pop(context);
                    //   }
                    //   // Navigator.pop(context);
                    // }
                    // if (request.url.contains(cancelURL)) {
                    //   Navigator.pop(context);
                    // }
                    return NavigationDecision.navigate;
                  },
                ))),
        ),
      ),
    );
  }
}
