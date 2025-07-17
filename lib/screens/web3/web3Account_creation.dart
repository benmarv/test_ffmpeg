import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/web3/web3_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Web3AccoutCreationScreen extends StatelessWidget {
  const Web3AccoutCreationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.45,
                      width: MediaQuery.sizeOf(context).width * 0.75,
                      child: Lottie.asset('assets/anim/crypto-wallet.json',
                          alignment: Alignment.center, fit: BoxFit.contain)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    translate(context,
                        'wallet_instructions')!, // Translated instructions
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Provider.of<Web3Provider>(context, listen: false)
                        .createWallet(context: context);
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primaryColor),
                    alignment: Alignment.center,
                    child: Text(
                      translate(
                        context,
                        'create_wallet',
                      )!, // Translated 'Create Wallet'
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
