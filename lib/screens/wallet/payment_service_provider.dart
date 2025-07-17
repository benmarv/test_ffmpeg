import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/withdraw/withdraw_history_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/wallet/verify_transaction_response.dart'
    as transaction_response;
import 'package:link_on/screens/wallet/wallet.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:uuid/uuid.dart' as uuid;

class PaymentServiceProvider extends ChangeNotifier {
  late BuildContext ctx;
  PaystackPlugin paystackPlugin = PaystackPlugin();
  num totalAmount = 0;
  int bookingId = 0;
  bool isLoading = false;
  late Function(Map<String, dynamic>) onComplete;
  late Function(bool) loderOnOFF;
  Map<String, dynamic>? paymentIntent;
  String paystackCurrency = 'ZAR';
  final Razorpay _razorpay = Razorpay(); //Instance of razor pay
  final razorPayKey = dotenv.get("RAZOR_KEY");
  final razorPaySecret = dotenv.get("RAZOR_SECRET");

/////// verify transaction and topup ///////////

  Future verifyTransactionAndTopUp({
    required String gateway_id,
    required String transaction_id,
    required String amount,
    required BuildContext context,
  }) async {
    String accessToken = getStringAsync("access_token");
    Map<String, dynamic> mapData = {
      'gateway_id': gateway_id,
      'amount': amount,
      'transaction_id': transaction_id
    };

    FormData form = FormData.fromMap(mapData);

    var response = await dioService.dio.post(
      'deposite/add-fund',
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );
    log('add-fund response : ${response.data['message']}');
    if (response.data['status'] == '200') {
      Provider.of<WithdrawHistoryProvider>(context, listen: false)
          .getUserBlance(context: context);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Wallet(),
        ),
      );
      toast('Amount successfully deposited into your wallet');
    } else {
      log('add fund api response ${response.data['message']}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

/////// Stripe ///////////

  Future<void> makePayment({
    required String amount,
    required BuildContext context,
    required String paymentMethodType,
    required Function(Map) onComplete,
  }) async {
    try {
      customDialogueLoader(context: context);

      paymentIntent = await createPaymentIntent(
          amount: '$amount',
          currency: 'USD',
          paymentMethodType: paymentMethodType);

      //STEP 2: Initialize Payment Sheet
      await stripe.Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              paymentIntentClientSecret:
                  paymentIntent!['client_secret'], //Gotten from payment intent
              style: ThemeMode.system,
              merchantDisplayName: 'Ikay',
            ),
          )
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(
          onComplete: onComplete,
          transactionId: paymentIntent!['id'],
          amount: amount,
          context: context);
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet(
      {required String transactionId,
      required BuildContext context,
      required Function(Map) onComplete,
      required String amount}) async {
    try {
      Navigator.pop(context);
      await stripe.Stripe.instance.presentPaymentSheet().then((value) async {
        paymentIntent = null;
        log('transaction id $transactionId');
        onComplete.call({
          'transaction_id': transactionId,
        });
      }).onError((error, stackTrace) {
        log('Error is:--->$error $stackTrace');
      });
    } on stripe.StripeException catch (e) {
      log('Error is:---> $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(
            translate(context, 'cancelled')!,
          ),
        ),
      );
    }
  }

  createPaymentIntent({
    required String amount,
    required String currency,
    required String paymentMethodType,
  }) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': paymentMethodType
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${getStringAsync('stripeSecretKey')}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_log
      log('err charging user: ${err.toString()}');
    }
  }

/////// PayStack ///////////

  init(
      {required BuildContext context,
      required num totalAmount,
      required int bookingId,
      required Function(Map<String, dynamic>) onComplete,
      required Function(bool) loderOnOFF}) {
    ctx = context;
    this.totalAmount = totalAmount;
    this.bookingId = bookingId;
    this.onComplete = onComplete;
    this.loderOnOFF = loderOnOFF;
  }

  Future payStackCheckout({
    required String email,
  }) async {
    String payStackKey = await getStringAsync('paystackPublicKey');

    isLoading = true;
    int price = totalAmount.toInt() * 100;
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now().millisecondsSinceEpoch}'
      ..email = email
      ..currency = paystackCurrency;

    String publicKey = payStackKey.validate();

    paystackPlugin.initialize(publicKey: publicKey);
    Future.delayed(
      Duration(seconds: 3),
      () async {
        CheckoutResponse response = await paystackPlugin.checkout(
          ctx,
          method: CheckoutMethod.card,
          charge: charge,
        );

        log('Response: $response');

        if (response.status == true) {
          log('Response $response');
          onComplete.call({
            'transaction_id': response.reference.validate(value: "#$bookingId"),
          });
          isLoading = false;
          log('Payment was successful. Ref: ${response.reference}');
        } else {
          isLoading = false;
          toast(response.message, print: true);
        }
      },
    );

    notifyListeners();
  }

/////// RazorPay ///////////

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log('Success Response: $response');
    toast("SUCCESS: ${response.paymentId!}", length: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('Error Response: $response');
    toast("ERROR: ${response.code} - ${response.message!}",
        length: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('External SDK Response: $response');
    toast("EXTERNAL_WALLET: ${response.walletName!}",
        length: Toast.LENGTH_SHORT);
  }

  void openSession({required String amount}) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    createOrder(amount: amount).then((orderId) {
      print("order id : $orderId");
      // if (orderId.isNotEmpty) {
      var options = {
        'key': razorPayKey, //Razor pay API Key
        'amount': amount, //in the smallest currency sub-unit.
        'name': 'DigitalU',
        'order_id': orderId, // Generate order_id using Orders API
        'description':
            'Top-up', //Order Description to be shown in razor pay page
        'timeout': 60, // in seconds
        'prefill': {
          'contact': '9123456789',
          'email': 'shanzayiqbal2005@gmail.com'
        }
      };
      _razorpay.open(options);
      // } else {
      //   print("Order id is empty.");
      // }
    });
  }

  Future<String> createOrder({required String amount}) async {
    final myData = await apiClient.razorPayApi(amount, "rcp_id_1");
    if (myData["status"] == "success") {
      print(myData);
      return myData["body"]["id"];
    } else {
      return "";
    }
  }

/////// FlutterWave ///////////

  void flutterWavecheckout({
    required num totalAmount,
    required String email,
    required Function(Map) onComplete,
  }) async {
    String flutterWavePublicKey = await getStringAsync('flutterwavePublicKey');
    String flutterWaveSecretKey = await getStringAsync('flutterwaveSecretKey');
    String transactionId = uuid.Uuid().v1();
    Flutterwave flutterWave = Flutterwave(
      context: getContext,
      publicKey: flutterWavePublicKey,
      currency: 'usd',
      redirectUrl: 'https://linkon.social/api/',
      txRef: transactionId,
      amount: totalAmount.validate().toStringAsFixed(2),
      customer: Customer(
        name: 'Abdul Rauf',
        phoneNumber: '+923155189866',
        email: email,
      ),
      paymentOptions: "card, payattitude, barter",
      customization: Customization(
          title: 'Pay With Flutterwave', logo: getStringAsync("appLogo")),
      isTestMode: true,
    );

    await flutterWave.charge().then((value) {
      log("Value is ===>${value.toJson()}");
      if (value.success.validate()) {
        isLoading = true;

        verifyPayment(
                transactionId: value.transactionId.validate(),
                flutterWaveSecretKey: flutterWaveSecretKey)
            .then((v) {
          if (v.status == "success") {
            onComplete.call({
              'transaction_id': value.transactionId.validate(),
            });
          } else {
            isLoading = false;

            toast('Transaction Failed');
          }
        }).catchError((e) {
          isLoading = false;

          toast(e.toString());
        });
      } else {
        toast('Transaction cancelled');
        isLoading = false;
      }
    });
    notifyListeners();
  }

  // FlutterWave Verify Transaction API
  Future<transaction_response.VerifyTransactionResponse> verifyPayment(
      {required String transactionId,
      required String flutterWaveSecretKey}) async {
    // Directly build the headers for the request
    Map<String, String> headers = {
      'Authorization': 'Bearer $flutterWaveSecretKey',
      'Content-Type': 'application/json',
    };

    // Send the HTTP request to verify the payment
    final response = await http.get(
      Uri.parse(
          "https://api.flutterwave.com/v3/transactions/$transactionId/verify"),
      headers: headers,
    );
    var body = jsonDecode(response.body);

    return transaction_response.VerifyTransactionResponse.fromJson(body);
  }
}
