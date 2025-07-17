import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:link_on/screens/web3/web3_provider.dart';

class Web3WalletSettingScreen extends StatefulWidget {
  const Web3WalletSettingScreen({
    super.key,
    required this.encrypedPrivateKey,
    required this.userId,
  });
  final String encrypedPrivateKey;
  final String userId;

  @override
  State<Web3WalletSettingScreen> createState() =>
      _Web3WalletSettingScreenState();
}

class _Web3WalletSettingScreenState extends State<Web3WalletSettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static List<Shadow> shodow = [
    Shadow(blurRadius: 1, offset: Offset(0.3, 0.3))
  ];

  bool _isBlurred = true;
  String privKey = '';

  void _revealPrivateKey() async {
    privKey = await Provider.of<Web3Provider>(context, listen: false)
        .showPrivateKey(context: context);
    setState(() {
      _isBlurred = false;
    });
  }

  void _copyPrivateKey() {
    Provider.of<Web3Provider>(context, listen: false).copyText(text: privKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Wallet Settings",
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
      body: Consumer<Web3Provider>(
        builder: (context, value, child) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  privKey != ""
                      ? privKey
                      : '**************************************************************************',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isBlurred ? _revealPrivateKey : _copyPrivateKey,
                  child: Text(
                      _isBlurred ? 'Reveal Private Key' : 'Copy Private Key'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}