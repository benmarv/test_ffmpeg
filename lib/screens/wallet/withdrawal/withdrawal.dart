import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'bankWithdrawl_text_field.dart';
import 'paypal_textFilds.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({super.key});

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  @override
  void initState() {
    super.initState();
  }

  List<String> paymentMethodList = [
    // "Paypal",
    "bank",
  ];
  String selectedMethod = "bank";
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 10, top: 10),
              child: Text(
                translate(context, 'withdrawal')!,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: size.height * 0.025),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    paymentMethodDropDown(),
                    if (selectedMethod == 'Paypal') ...[
                      const PaypalTextField(),
                    ] else if (selectedMethod == "bank") ...[
                      const BankWithDrawalTextField()
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentMethodDropDown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
        hint: Text(
          translate(context, selectedMethod)!,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey),
        ),
        isExpanded: true,
        value: selectedMethod,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        underline: const SizedBox.shrink(),
        items: paymentMethodList.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              translate(context, item)!,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedMethod = value!;
          });
        },
      ),
    );
  }
}
