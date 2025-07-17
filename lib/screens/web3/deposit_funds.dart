import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/web3/web3_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class DepositFundsWeb3 extends StatefulWidget {
  const DepositFundsWeb3({super.key, required this.walletAddress});
  final String walletAddress;
  @override
  State<DepositFundsWeb3> createState() => _DepositFundsWeb3State();
}

class _DepositFundsWeb3State extends State<DepositFundsWeb3> {
  static List<Shadow> shodow = [
    Shadow(blurRadius: 1, offset: Offset(0.3, 0.3))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color(0xfff5f5f0),
        appBar: AppBar(
          // backgroundColor: Color(0xfff5f5f0),
          title: Text(
            translate(context, 'receive_eth')!,
            style: TextStyle(
              shadows: shodow,
              // color: Colors.black
            ),
          ),
          leadingWidth: 30,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              // color: Colors.black,
              shadows: shodow,
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            Share.share(widget.walletAddress);
          },
          child: Container(
            height: 50,
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text(
              translate(context, 'share_address')!,
              style: TextStyle(shadows: shodow),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: QrImageView(
                data: widget.walletAddress,
                version: QrVersions.auto,
                size: 200.0,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey[400]!.withOpacity(0.4)),
                color: Colors.black,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.walletAddress.substring(0, 10)}...${widget.walletAddress.substring(widget.walletAddress.length - 8)}",
                    style: TextStyle(color: Colors.white, shadows: shodow),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Provider.of<Web3Provider>(context, listen: false)
                          .copyText(text: widget.walletAddress);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Text(
                            translate(context, 'copy')!,
                            style:
                                TextStyle(color: Colors.black, shadows: shodow),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.copy_rounded,
                              size: 14, color: Colors.black, shadows: shodow),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          ],
        ));
  }
}
