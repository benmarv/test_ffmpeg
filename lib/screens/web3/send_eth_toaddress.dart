import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/web3/web3_provider.dart';
import 'package:provider/provider.dart';

class SendEthToaddress extends StatefulWidget {
  const SendEthToaddress({
    super.key,
    required this.walletAddress,
    required this.tokenAddress,
    required this.tokenName,
    required this.isCustomTokenTransfer,
  });
  final String walletAddress;
  final String tokenAddress;
  final String tokenName;
  final bool isCustomTokenTransfer;

  @override
  State<SendEthToaddress> createState() => _SendEthToaddressState();
}

class _SendEthToaddressState extends State<SendEthToaddress> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _recipientEthAddressController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _recipientEthAddressController.dispose();
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
      appBar: AppBar(
        title: Text(
          (provider.selectedChain == "Sonic Mainnet" ||
                  provider.selectedChain == "Sonic Blaze Testnet")
              ? widget.isCustomTokenTransfer
                  ? "Send ${widget.tokenName}"
                  : translate(context, 'send_sonic')!
              : (provider.selectedChain == "BSC Mainnet" ||
                      provider.selectedChain == "opBNB Mainnet" ||
                      provider.selectedChain == "BSC Testnet" ||
                      provider.selectedChain == "opBNB Testnet")
                  ? "Send BNB"
                  : translate(context, 'send_eth')!,
          style: TextStyle(shadows: shodow),
        ),
        centerTitle: true,
        leadingWidth: 30,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            shadows: shodow,
          ),
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
                    ? widget.isCustomTokenTransfer
                        ? "assets/images/empty-token.png"
                        : "assets/images/sonic.png"
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
            Container(
                width: MediaQuery.sizeOf(context).width,
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400]!.withOpacity(0.4)),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                alignment: Alignment.center,
                child: TextFormField(
              
                  validator: (val) {
                    return val!.isEmpty
                        ? (provider.selectedChain == "Sonic Mainnet" ||
                                provider.selectedChain == "Sonic Blaze Testnet")
                            ? translate(
                                context, 'recipient_sonic_address_required')
                            : translate(context,
                                'recipient_address_required') // Translated validation message
                        : null;
                  },
                  controller: _recipientEthAddressController,
                  cursorColor: Color(0xff443cc7),
                  decoration: InputDecoration(
                 
                    border: InputBorder.none,
                    hintText: (provider.selectedChain == "Sonic Mainnet" ||
                            provider.selectedChain == "Sonic Blaze Testnet")
                        ? translate(context, 'recipient__sonic_address')
                        : translate(context, 'recipient_ethereum_address'),
                   
                  ),
                )),
            Container(
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400]!.withOpacity(0.4)),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                alignment: Alignment.center,
                child: TextFormField(
              
                  validator: (val) {
                    return val!.isEmpty
                        ? translate(context,
                            'amount_required') // Translated validation message
                        : null;
                  },
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  cursorColor: Color(0xff443cc7),
                  decoration: InputDecoration(
                    suffix: Text((provider.selectedChain == "Sonic Mainnet" ||
                            provider.selectedChain == "Sonic Blaze Testnet")
                        ? widget.isCustomTokenTransfer
                            ? widget.tokenName
                            : 'Sonic'
                        : (provider.selectedChain == "BSC Mainnet" ||
                                provider.selectedChain == "opBNB Mainnet" ||
                                provider.selectedChain == "BSC Testnet" ||
                                provider.selectedChain == "opBNB Testnet")
                            ? "BNB"
                            : 'ETH'),
                    border: InputBorder.none,
                    hintText:
                        translate(context, 'enter_amount'), // Translated hint
                   
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                translate(context, 'address_warning')!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    // color: Colors.black,
                    shadows: shodow,
                    fontSize: 16),
              ),
            ),
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
                      translate(context, 'cancel')!, // Translated "Cancel"
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
                            isCustomTokenTransfer: widget.isCustomTokenTransfer,
                            tokenAddress:widget.tokenAddress,
                            context: context,
                            sendToSomeoneAddress:
                                _recipientEthAddressController.text,
                            amount: double.parse(_amountController.text));
                      } else {
                        provider.transferETH(
                            context: context,
                            sendToSomeoneAddress:
                                _recipientEthAddressController.text,
                            amount: double.parse(_amountController.text));
                      }
                    }
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      translate(context, 'next')!, // Translated "Next"
                      style: TextStyle(shadows: shodow),
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
      ),
    );
  }
}
