import 'package:flutter/material.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/withdraw/withdraw_history_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class BankWithDrawalTextField extends StatefulWidget {
  const BankWithDrawalTextField({super.key});

  @override
  State<BankWithDrawalTextField> createState() =>
      _BankWithDrawalTextFieldState();
}

class _BankWithDrawalTextFieldState extends State<BankWithDrawalTextField> {
  TextEditingController amountController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    ibanController.dispose();
    amountController.dispose();
    countryController.dispose();
    fullNameController.dispose();
    swiftCodeController.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Container(
              height: 40,
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: CustomTextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                hinttext: translate(context, 'amount'),
              )),
          const SizedBox(
            height: 10.0,
          ),
          Container(
              height: 40,
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: CustomTextField(
                keyboardType: TextInputType.text,
                controller: ibanController,
                hinttext: translate(context, 'iban'),
              )),
          const SizedBox(
            height: 10.0,
          ),
          Container(
              height: 40,
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: CustomTextField(
                keyboardType: TextInputType.text,
                controller: countryController,
                hinttext: translate(context, 'country'),
              )),
          const SizedBox(
            height: 10.0,
          ),
          Container(
              height: 40,
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: CustomTextField(
                keyboardType: TextInputType.text,
                controller: fullNameController,
                hinttext: translate(context, 'full_name'),
              )),
          const SizedBox(
            height: 10.0,
          ),
          Container(
              height: 40,
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: CustomTextField(
                keyboardType: TextInputType.text,
                controller: swiftCodeController,
                hinttext: translate(context, 'swift_code'),
              )),
          const SizedBox(
            height: 10.0,
          ),
          Container(
              height: 40,
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: CustomTextField(
                keyboardType: TextInputType.multiline,
                controller: addressController,
                hinttext: translate(context, 'address'),
              )),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 35,
            width: MediaQuery.of(context).size.width,
            child: MaterialButton(
              shape: StadiumBorder(),
              color: AppColors.primaryColor,
              onPressed: () {
                if (amountController.text.isEmpty) {
                  toast(translate(context, 'enter_withdrawal_amount'));
                } else if (ibanController.text.isEmpty) {
                  toast(translate(context, 'enter_iban_number'));
                } else if (countryController.text.isEmpty) {
                  toast(translate(context, 'enter_country_name'));
                } else if (fullNameController.text.isEmpty) {
                  toast(translate(context, 'enter_your_full_name'));
                } else if (swiftCodeController.text.isEmpty) {
                  toast(translate(context, 'enter_bank_swift_code'));
                } else if (addressController.text.isEmpty) {
                  toast(translate(context, 'enter_your_address'));
                } else {
                  dynamic mapData = {
                    "type": "Bank",
                    "amount": amountController.text,
                    "iban": ibanController.text,
                    "country": countryController.text,
                    "full_name": fullNameController.text,
                    "swift_code": swiftCodeController.text,
                    "address": addressController.text,
                  };
                  print('Bank withdraw mapdata $mapData');

                  context
                      .read<WithdrawHistoryProvider>()
                      .requestWithdraw(context, mapData);
                }
              },
              child: Text(
                translate(context, 'request_withdrawal')!,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          )
        ],
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
