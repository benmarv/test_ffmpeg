import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/web3/web3_provider.dart';
import 'package:provider/provider.dart';

class BuyAppCredit extends StatefulWidget {
  const BuyAppCredit({super.key, required this.walletAddress});
  final String walletAddress;

  @override
  State<BuyAppCredit> createState() => _BuyAppCreditState();
}

class _BuyAppCreditState extends State<BuyAppCredit> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  static List<Shadow> shodow = [
    Shadow(blurRadius: 1, offset: Offset(0.3, 0.3))
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Web3Provider>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff5f5f0),
        appBar: AppBar(
          backgroundColor: Color(0xfff5f5f0),
          title: Text(
            translate(context, 'buy_credit')!,
            style: TextStyle(color: Colors.black, shadows: shodow),
          ),
          centerTitle: true,
          leadingWidth: 30,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black, shadows: shodow),
          ),
        ),
        body: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              Image(
                image: AssetImage(
                  (provider.selectedChain == "Sonic Mainnet" ||
                          provider.selectedChain == "Sonic Blaze Testnet")
                      ? "assets/images/sonic.png"
                      : (provider.selectedChain == "BSC Mainnet" ||
                              provider.selectedChain == "opBNB Mainnet" ||
                              provider.selectedChain == "BSC Testnet" ||
                              provider.selectedChain == "opBNB Testnet")
                          ? "assets/images/bnb.png"
                          : "assets/images/ethereum.png",
                ),
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                  onTap: () =>
                      provider.copyText(text: "0x28740cc46d1e0fF4D800bc2F46985920fb0dA32b"),
                  child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.grey[400]!.withOpacity(0.4)),
                        color: Color(0xffe5e5d6),
                      ),
                      alignment: Alignment.center,
                      child: Text("0x28740cc46d1e0fF4D800bc2F46985920fb0dA32b",
                          style: TextStyle(
                              color: Colors.black,
                              shadows: shodow,
                              fontSize: 13)))),
              Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: Colors.grey[400]!.withOpacity(0.4)),
                    color: Color(0xffe5e5d6),
                  ),
                  alignment: Alignment.center,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black87),
                    validator: (val) {
                      return val!.isEmpty
                          ? translate(context, 'amount_required')
                          : null;
                    },
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    cursorColor: Color(0xff443cc7),
                    decoration: InputDecoration(
                      suffix: Text(
                        'ETH',
                        style: TextStyle(color: Colors.black87),
                      ),
                      border: InputBorder.none,
                      hintText: translate(context, 'amount'),
                      hintStyle: TextStyle(color: Colors.black87),
                    ),
                  )),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.45,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff252525),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        translate(context, 'cancel')!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_key.currentState!.validate()) {
                        if (provider.selectedChain == "Sonic Mainnet" ||
                            provider.selectedChain == "Sonic Blaze Testnet") {
                          provider.transferSonicNativeToken(
                            tokenAddress: "",
                              isCustomTokenTransfer: true,
                              context: context,
                              amount: double.parse(_amountController.text));
                        } else {
                          provider.transferETH(
                            context: context,
                              amount: double.parse(_amountController.text));
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.sizeOf(context).width * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffc5f277),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        translate(context, 'next')!,
                        style: TextStyle(color: Colors.black, shadows: shodow),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
