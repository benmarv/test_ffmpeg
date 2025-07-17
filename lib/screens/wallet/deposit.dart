import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/wallet/paypal.dart';
import 'package:link_on/screens/wallet/payment_service_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/wallet/bank.dart';

class AddFunds extends StatefulWidget {
  final SiteSetting? site;
  const AddFunds({super.key, this.site});
  @override
  State<AddFunds> createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String accessToken = getStringAsync("access_token");
  String message = '';

// FlutterWave
  initFlutterWave() {
    final flutterWaveServiceNew =
        Provider.of<PaymentServiceProvider>(context, listen: false);
    flutterWaveServiceNew.flutterWavecheckout(
      totalAmount: amount.text.toDouble(),
      email: emailController.text,
      onComplete: (p0) async {
        log('flutterwave transaction id : ${p0['transaction_id']}');

        final pro = Provider.of<PaymentServiceProvider>(context, listen: false);
        pro.verifyTransactionAndTopUp(
            gateway_id: '4',
            transaction_id: p0['transaction_id'],
            amount: amount.text,
            context: context);
      },
    );
  }

// Paystack
  initPaystack() async {
    final paymentServices =
        Provider.of<PaymentServiceProvider>(context, listen: false);

    await paymentServices.init(
      context: context,
      loderOnOFF: (p0) {},
      totalAmount: amount.text.toDouble(),
      bookingId: 17634,
      onComplete: (res) async {
        log('paystack transaction id : ${res["transaction_id"]}');
        final pro = Provider.of<PaymentServiceProvider>(context, listen: false);
        pro.verifyTransactionAndTopUp(
            gateway_id: '3',
            transaction_id: res["transaction_id"],
            amount: amount.text,
            context: context);
      },
    );

    paymentServices.payStackCheckout(email: emailController.text);
  }

// Stripe
  initStripe() {
    final stripeServices =
        Provider.of<PaymentServiceProvider>(context, listen: false);
    stripeServices.makePayment(
      amount: amount.text,
      context: context,
      paymentMethodType: 'card',
      onComplete: (p0) {
        log('stripe transaction id : ${p0['transaction_id']}');
        final pro = Provider.of<PaymentServiceProvider>(context, listen: false);
        pro.verifyTransactionAndTopUp(
            gateway_id: '2',
            transaction_id: p0['transaction_id'],
            amount: amount.text,
            context: context);
      },
    );
  }

  @override
  void dispose() {
    amount.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  getStringAsync("appLogo"),
                ),
              ),
            ),
          ),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(context, 'add_funds')!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return translate(context, 'enter_your_email');
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(val.trim())) {
                          return translate(
                              context, 'enter_a_valid_email_address');
                        }
                        return null;
                      },
                      giveDefaultBorder: true,
                      controller: emailController,
                      labelText: translate(context, 'email'),
                      maxLines: 1,
                      hinttext: translate(context, 'enter_your_email'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      textinputformetter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return translate(context, 'enter_your_amount');
                        }
                        return null;
                      },
                      giveDefaultBorder: true,
                      controller: amount,
                      labelText: translate(context, 'your_amount'),
                      maxLines: 1,
                      hinttext: translate(context, 'enter_your_amount'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            paymentOption();
                          }
                        },
                        child: Text(
                          translate(context, 'add_funds')!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  paymentOption() {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5.0,
                width: MediaQuery.sizeOf(context).width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              const SizedBox(height: 5),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    final pro = Provider.of<PaymentServiceProvider>(context,
                        listen: false);
                    pro.openSession(amount: amount.text);
                  },
                  child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.35),
                            image: DecorationImage(
                              image: AssetImage('assets/images/razorpay.png'),
                              fit: BoxFit.contain,
                            )),
                      ),
                      title: Text(
                        "RazorPay",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor),
                      ))),
              if (widget.site!.chkPaypal == "1")
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaypalPayment(
                              amount: amount.text,
                              onFinish: (transactionId, payerId) async {
                                log('paypal transaction id is : $transactionId');
                                if (mounted) {
                                  final pro =
                                      Provider.of<PaymentServiceProvider>(
                                          context,
                                          listen: false);
                                  pro.verifyTransactionAndTopUp(
                                      gateway_id: '1',
                                      transaction_id: transactionId,
                                      amount: amount.text,
                                      context: context);
                                }
                              }),
                        ),
                      );
                    },
                    child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Image(
                          image: AssetImage('assets/images/paypal.png'),
                          fit: BoxFit.contain,
                          height: 30,
                          width: 30,
                        ),
                        title: Text(
                          "PayPal",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor),
                        ))),
              if (widget.site!.chkStripe == "1")
                InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      initStripe();
                    },
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: Image(
                          image: AssetImage('assets/images/stripe.png'),
                          fit: BoxFit.contain,
                          height: 30,
                          width: 30,
                        ),
                        title: Text(
                          "Stripe",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor),
                        ))),
              if (widget.site!.chkFlutterWave == "1")
                InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      initFlutterWave();
                    },
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: Image(
                          image: AssetImage('assets/images/flutterwave.png'),
                          fit: BoxFit.contain,
                          height: 30,
                          width: 30,
                        ),
                        title: Text(
                          "FlutterWave",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor),
                        ))),
              if (widget.site!.chkPaystack == "1")
                InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      initPaystack();
                    },
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: Image(
                          image: AssetImage('assets/images/paystack.png'),
                          fit: BoxFit.contain,
                          height: 30,
                          width: 30,
                        ),
                        title: Text(
                          translate(context, 'paystack')!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor),
                        ))),
              if (widget.site!.bankPayment == "1")
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Bank()));
                  },
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(LineIcons.piggy_bank,
                        color: AppColors.primaryColor),
                    title: Text(
                      translate(context, 'bank')!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
