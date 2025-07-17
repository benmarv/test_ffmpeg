import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/withdraw/withdraw_history_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';

class PaypalTextField extends StatefulWidget {
  const PaypalTextField({super.key});

  @override
  State<PaypalTextField> createState() => _PaypalTextFieldState();
}

class _PaypalTextFieldState extends State<PaypalTextField> {
  TextEditingController emailContoller = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailContoller.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: CustomTextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailContoller,
                hinttext: translate(context, 'paypal_email'),
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return translate(context, 'enter_email');
                  }
                  // Regular expression for validating an email address
                  Pattern pattern =
                      r'^([a-zA-Z0-9_\.\-])+\@([a-zA-Z0-9\-]+\.)+([a-zA-Z0-9]{2,4})+$';
                  RegExp regex = RegExp(pattern as String);
                  if (!regex.hasMatch(val.trim())) {
                    return translate(context, 'valid_email');
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: CustomTextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                hinttext: translate(context, 'amount'),
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return translate(context, 'enter_amount');
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 50,
              child: CupertinoButton(
                minSize: MediaQuery.sizeOf(context).width,
                color: AppColors.primaryColor,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    dynamic mapData = {
                      "type": 'Paypal',
                      "amount": amountController.text,
                      "paypal_email": emailContoller.text,
                    };
                    context
                        .read<WithdrawHistoryProvider>()
                        .requestWithdraw(context, mapData);
                  }
                },
                child: Text(
                  translate(context, 'request_withdrawal')!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget banner(error) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: PhysicalModel(
        color: Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            error.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
