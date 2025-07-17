// cc@rufusopdev
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/other_chains_transaction_model.dart';
import 'package:link_on/models/sonic_transaction_model.dart';
import 'package:link_on/screens/web3/database_helper.dart';
import 'package:link_on/screens/web3/token_model.dart';
import 'package:link_on/screens/web3/transaction_history_screen.dart';
import 'package:link_on/screens/web3/web3_wallet_setting_scree.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/screens/wallet/wallet.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:link_on/screens/web3/deposit_funds.dart';
import 'package:link_on/screens/web3/web3_provider.dart';
import 'package:link_on/screens/web3/send_eth_toaddress.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:intl/intl.dart';

enum BlockchainNetwork { sonic, bsc, opbnb, ethereum }

class Web3WalletScreen extends StatefulWidget {
  const Web3WalletScreen({super.key});
  @override
  State<Web3WalletScreen> createState() => _Web3WalletScreenState();
}

class _Web3WalletScreenState extends State<Web3WalletScreen> {
  late List<TokenModel> tokens;
  final TextEditingController _tokenContractAddressController =
      TextEditingController();

  final dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    final pro = Provider.of<Web3Provider>(context, listen: false);
    // pro.changeChain(chain: "Ethereum Sepolia");
    pro.getUserDataFuncWallet(
        userid: getStringAsync("user_id"), isFirstTime: true);
    getTokens();
    super.initState();
  }

  void getTokens() async {
    final pro = Provider.of<Web3Provider>(context, listen: false);
    tokens = await pro.getTokens();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tokenContractAddressController.dispose();
    super.dispose();
  }

  static List<Shadow> shodow = [
    Shadow(blurRadius: 1, offset: Offset(0.3, 0.3))
  ];

  void showTransactionDialog(BuildContext context,
      {required bool isSonicModel,
      required SonicTransactionModel sonicTransaction,
      required OtherChainsTransactionModel otherTransaction}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          contentPadding: EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            width: MediaQuery.sizeOf(context).width * 0.95,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Confirmed",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    GestureDetector(
                      onTap: () {
                        // Copy transaction logic
                      },
                      child: Text(
                        "Copy transaction ID",
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // From -> To
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 14,
                      child: Icon(Icons.account_circle, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "0x287...fd5",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 18),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 14,
                      child: Icon(Icons.account_circle, color: Colors.white),
                    ),
                    SizedBox(width: 4),
                    Text("0xjkd...sg8", style: TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(height: 12),

                // Transaction details
                Text("Transaction",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 8),

                _transactionRow("Nonce", "53",
                    textColor: Theme.of(context).colorScheme.onSurface),
                _transactionRow("Amount", "-6 \$", textColor: Colors.red),
                _transactionRow("Gas Limit (Units)", "21000",
                    textColor: Theme.of(context).colorScheme.onSurface),
                _transactionRow("Gas Used (Units)", "21000",
                    textColor: Theme.of(context).colorScheme.onSurface),
                _transactionRow("Base fee (GWEI)", "1",
                    textColor: Theme.of(context).colorScheme.onSurface),
                _transactionRow("Priority fee (GWEI)", "0.1",
                    textColor: Theme.of(context).colorScheme.onSurface),

                Divider(),
                _transactionRow("Total gas fee", "0.0000231 \$",
                    textColor: Theme.of(context).colorScheme.onSurface),
                _transactionRow("Max fee per gas", "0.00000001 \$",
                    textColor: Theme.of(context).colorScheme.onSurface),
                Divider(),

                // Total
                _transactionRow("Total", "6.0000231 \$",
                    fontWeight: FontWeight.bold,
                    textColor: Theme.of(context).colorScheme.onSurface),
                _transactionRow("", "\$3.32 USD",
                    fontWeight: FontWeight.bold,
                    textColor: Theme.of(context).colorScheme.onSurface),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _transactionRow(String title, String value,
      {Color? textColor = Colors.black,
      FontWeight fontWeight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14)),
          Text(value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: fontWeight,
                color: textColor,
              )),
        ],
      ),
    );
  }

  BlockchainNetwork getBlockchainNetwork(String selectedChain) {
    switch (selectedChain) {
      case 'Sonic Mainnet':
      case 'Sonic Blaze Testnet':
        return BlockchainNetwork.sonic;
      case 'BSC Mainnet':
      case 'BSC Testnet':
        return BlockchainNetwork.bsc;
      case 'opBNB Mainnet':
      case 'opBNB Testnet':
        return BlockchainNetwork.opbnb;
      default:
        return BlockchainNetwork.ethereum;
    }
  }

  Map<String, String> getChainData(BlockchainNetwork network) {
    switch (network) {
      case BlockchainNetwork.sonic:
        return {
          'text': ' S',
          'title': 'Sonic',
          'assetPath': 'assets/images/sonic.png',
          'currency': 'S'
        };
      case BlockchainNetwork.bsc:
      case BlockchainNetwork.opbnb:
        return {
          'text': ' BNB',
          'title': 'BNB',
          'assetPath': 'assets/images/bnb.png',
          'currency': 'BNB'
        };
      case BlockchainNetwork.ethereum:
      default:
        return {
          'text': ' Eth',
          'title': 'Ethereum',
          'assetPath': 'assets/images/ethereum.png',
          'currency': 'Eth'
        };
    }
  }

  String convertTimeStampToDateFormate(String timeStamp) {
    // Convert the timeStamp to an integer
    int time = int.parse(timeStamp);
    // Convert the Unix timestamp to DateTime
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true).toLocal();

    // Format the DateTime as "Mar 1, 3:15 PM"
    String formattedDate = DateFormat("MMM d, h:mm a").format(dateTime);

    return formattedDate;
  }

  Widget _buildNetworkSelectorBottomSheet(BuildContext context) {
    final pro = Provider.of<Web3Provider>(context, listen: false);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Title
            const Center(
                child: Text("Networks",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            const SizedBox(height: 16),
            // Mainnet Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Mainnet Networks",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...pro.mainnetNetworks.map((network) => ListTile(
                  title: Text(network["name"]!),
                  onTap: () {
                    Navigator.pop(context);
                    pro.changeChain(chain: network["name"]!);
                    toast("Selected: ${network["name"]}");
                  },
                )),
            // Divider between sections
            const Divider(),
            // Testnet Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Testnet Networks",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...pro.testnetNetworks.map((network) => ListTile(
                  title: Text(network["name"]!),
                  onTap: () {
                    Navigator.pop(context);
                    pro.changeChain(chain: network["name"]!);
                    toast("Selected: ${network["name"]}");
                  },
                )),
          ],
        ),
      ),
    );
  }

  Color? getTransactionColor({
    required bool isSonicChain,
    required String transactionFrom,
    required String userWalletAddress,
    required int colorIntensity,
  }) {
    bool isSender =
        transactionFrom.toLowerCase() == userWalletAddress.toLowerCase();
    if (isSonicChain) {
      return isSender
          ? Colors.blue[colorIntensity]
          : Colors.yellow[colorIntensity];
    } else {
      return isSender
          ? Colors.blue[colorIntensity]
          : Colors.yellow[colorIntensity];
    }
  }

  IconData getTransactionIcon({
    required bool isSonicChain,
    required String transactionFrom,
    required String userWalletAddress,
  }) {
    bool isSender =
        transactionFrom.toLowerCase() == userWalletAddress.toLowerCase();
    return isSender
        ? Icons.keyboard_double_arrow_up_outlined
        : Icons.keyboard_double_arrow_down_outlined;
  }

  String getTransactionType({
    required String transactionFrom,
    required String userWalletAddress,
  }) {
    return transactionFrom.toLowerCase() == userWalletAddress.toLowerCase()
        ? "Transfer"
        : "Deposit";
  }

  String? _errorText;

  bool _isValidAddress(String address) {
    // Check if the address matches the standard Ethereum address pattern
    final RegExp addressRegExp = RegExp(r'^0x[a-fA-F0-9]{40}$');
    if (!addressRegExp.hasMatch(address)) {
      return false;
    }

    // Check if the address has a valid checksum
    return true;
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
             backgroundColor:
                              Theme.of(context).colorScheme.secondary,
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Consumer<Web3Provider>(
                builder: (context, web3Provider, child) => Container(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Import tokens',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.blue[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Token detection is not available on this network yet. Please import token manually and make sure you trust it. Learn about scams and security risks.',
                              style:
                                  TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Token contract address',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _errorText = _isValidAddress(text)
                                ? null
                                : 'Invalid Ethereum address';
                          });
                          if (_errorText == null) {
                            web3Provider.importToken(
                                context: context,
                                tokenAddress: _tokenContractAddressController
                                    .text
                                    .trim());
                          } else {
                            web3Provider.changeIsImportingBool(value: true);
                          }
                        },
                        controller: _tokenContractAddressController,
                        validator: (value) {
                          final RegExp addressRegExp =
                              RegExp(r'^0x[a-fA-F0-9]{40}$');
                          if (!addressRegExp.hasMatch(value!)) {
                            return "Invalid Ethereum address";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorText: _errorText,
                          border: OutlineInputBorder(),
                          hintText: 'Enter token contract address',
                        ),
                      ),
                      if (_tokenContractAddressController.text.isNotEmpty &&
                          !web3Provider.isImporting) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Token symbol',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: _tokenContractAddressController
                                        .text.isNotEmpty &&
                                    web3Provider.responseData != null
                                ? web3Provider.responseData["symbol"]
                                : '',
                            border: OutlineInputBorder(),
                            hintText: 'Enter token symbol',
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Token decimal',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: _tokenContractAddressController
                                        .text.isNotEmpty &&
                                    web3Provider.responseData != null
                                ? web3Provider.responseData["decimals"]
                                    .toString()
                                : '',
                            hintText: 'Enter token decimals',
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                web3Provider.responseData != null &&
                                        !web3Provider.isImporting
                                    ? AppColors.primaryColor
                                    : Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: web3Provider.responseData != null &&
                                  !web3Provider.isImporting
                              ? () {
                                  // import token
                                  web3Provider
                                      .addTokenToLocalDb(
                                          context: context,
                                          responseData:
                                              web3Provider.responseData,
                                          tokenAddress:
                                              _tokenContractAddressController
                                                  .text
                                                  .trim())
                                      .then(
                                    (value) async {
                                      tokens = await web3Provider.getTokens();
                                      Navigator.pop(context);
                                      _tokenContractAddressController.clear();
                                    },
                                  );
                                }
                              : () {},
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Web3Provider>(builder: (context, value, child) {
      bool isSonicChain = value.selectedChain == "Sonic Mainnet" ||
          value.selectedChain == "Sonic Blaze Testnet";
      final selectedChain = value.selectedChain;
      final network = getBlockchainNetwork(selectedChain);
      final chainData = getChainData(network);
      return WillPopScope(
        onWillPop: () async {
          print('return to wallet screen');
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Wallet()),
          );
          return false;
        },
        child: Scaffold(
          // backgroundColor: Color(0xfff5f5f0),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                if (isSonicChain) {
                  value.fetchSonicTokenBalance();
                  value.getSonicChainTransactionHistory(
                      page: 1,
                      maxCount: "6",
                      isTransactionHistoryScreen: false);
                } else {
                  value.queryBalance();
                  value.getOtherChainsTransactionHistory(
                      page: 1,
                      maxCount: "6",
                      isTransactionHistoryScreen: false);
                }
                await value.getTokens();
              },
              child: ListView(
                padding: const EdgeInsets.all(10.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Wallet()),
                            );
                          },
                          child: Icon(Icons.arrow_back, shadows: shodow)),
                      InkWell(
                          onTap: () {
                            value.copyText(
                                text: value.getUserData!.walletAddress ??
                                    "xxxxx...xxxx");
                          },
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    value.getUserData == null
                                        ? "xxxxx...xxxxx"
                                        : "${value.getUserData?.walletAddress?.substring(0, 5) ?? 'xxxxx'}...${value.getUserData?.walletAddress?.substring(value.getUserData!.walletAddress!.length - 4) ?? 'xxxx'}",
                                    style: TextStyle(
                                      shadows: shodow,
                                    )),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.copy_rounded,
                                  size: 18,
                                  shadows: shodow,
                                )
                              ])),
                      Row(
                        children: [
                          InkWell(
                              onTap: () => Navigator.of(context)
                                      .push(createRoute(DepositFundsWeb3(
                                    walletAddress:
                                        value.getUserData!.walletAddress ??
                                            "xxxxxxxx",
                                  ))),
                              child: Icon(
                                Icons.qr_code_2_rounded,
                              )),
                          if (value.getUserData != null) ...[
                            if (value.getUserData!.hex ==
                                value.getUserData!.walletAddress) ...[
                              const SizedBox(width: 10),
                              InkWell(
                                  onTap: () => Navigator.of(context).push(
                                          createRoute(Web3WalletSettingScreen(
                                        encrypedPrivateKey: value
                                            .getUserData!.addressBytes
                                            .toString(),
                                        userId:
                                            value.getUserData!.id.toString(),
                                      ))),
                                  child: Icon(
                                    Icons.settings,
                                  )),
                            ],
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                          ),
                          builder: (context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: _buildNetworkSelectorBottomSheet(context),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${value.selectedChain}",
                            style: TextStyle(
                              fontSize: 14,
                              shadows: shodow,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.change_circle_outlined,
                            size: 22,
                          )
                        ],
                      )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          intl.NumberFormat.compact()
                              .format(value.walletBalanceInDouble),
                          style: TextStyle(
                            fontSize: 40,
                            shadows: shodow,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chainData['text']!,
                        style: TextStyle(
                          fontSize: 20,
                          shadows: shodow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(createRoute(DepositFundsWeb3(
                            walletAddress:
                                value.getUserData!.walletAddress ?? "xxxxxxx",
                          )));
                        },
                        child: Container(
                          height: 70,
                          width: 75,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                  "assets/icons/qr-code.png",
                                ),
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 25,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                translate(context, 'receive')!,
                                style: TextStyle(
                                  fontSize: 14,
                                  shadows: shodow,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(createRoute(SendEthToaddress(
                            tokenName: "",
                            isCustomTokenTransfer: false,
                            tokenAddress: "",
                            walletAddress:
                                value.getUserData!.walletAddress ?? "xxxxxx",
                          )));
                        },
                        child: Container(
                          height: 70,
                          width: 75,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                  "assets/icons/send.png",
                                ),
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 25,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                translate(context, 'send')!,
                                style: TextStyle(
                                  fontSize: 14,
                                  shadows: shodow,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // if (getStringAsync("buy_credit_with_crypto") ==
                      //     "1")
                      //   InkWell(
                      //     onTap: () {
                      //       Navigator.of(context).push(
                      //         createRoute(
                      //           BuyAppCredit(

                      //             walletAddress: value
                      //                 .getUserData!.walletAddress
                      //                 .toString(),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //     child: Container(
                      //       height: 70,
                      //       width: 75,
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(5),
                      //       ),
                      //       alignment: Alignment.center,
                      //       child: Column(
                      //         mainAxisAlignment:
                      //             MainAxisAlignment.center,
                      //         children: [
                      //           Icon(
                      //             LineIcons.dollar_sign,
                      //             color: Colors.black,
                      //             size: 28,
                      //           ),
                      //           Text(
                      //             translate(context, 'buy')!,
                      //             style: TextStyle(
                      //               fontSize: 14,
                      //               shadows: shodow,
                      //               fontWeight: FontWeight.w400,
                      //               color: Colors.black,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    // height: MediaQuery.sizeOf(context).height * 0.1,
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10.0, top: 10.0),
                                child: PopupMenuButton<String>(
                                  menuPadding: EdgeInsets.zero,
                                  onSelected: (String selectedValue) {
                                    if (selectedValue == "Refresh list") {
                                      if (isSonicChain) {
                                        value.fetchSonicTokenBalance();
                                        value.getSonicChainTransactionHistory(
                                            page: 1,
                                            maxCount: "6",
                                            isTransactionHistoryScreen: false);
                                      } else {
                                        value.queryBalance();
                                        value.getOtherChainsTransactionHistory(
                                            page: 1,
                                            maxCount: "6",
                                            isTransactionHistoryScreen: false);
                                      }
                                      value.getTokens();
                                    } else {
                                      _showCustomDialog(context);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return {'Import token', 'Refresh list'}
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                  child: const Icon(Icons.more_vert),
                                ),
                              ),
                            ]),
                        ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(createRoute(SendEthToaddress(
                              isCustomTokenTransfer: false,
                              tokenAddress: "",
                              tokenName: "",
                              walletAddress:
                                  value.getUserData!.walletAddress ?? "xxxxxx",
                            )));
                          },
                          leading: Image(
                            image: AssetImage(
                              chainData['assetPath']!,
                            ),
                            height: 35,
                            width: 35,
                          ),
                          title: Text(
                            chainData['title']!,
                            style: TextStyle(
                              fontSize: 14,
                              shadows: shodow,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${value.walletBalanceInDouble} ${chainData['currency']}',
                            style: TextStyle(
                              fontSize: 12,
                              shadows: shodow,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        // if (value.selectedChain == "Sonic Mainnet") ...[
                        //   ListTile(
                        //     onTap: () {
                        //       Navigator.of(context)
                        //           .push(createRoute(SendEthToaddress(
                        //         isCustomTokenTransfer: true,
                        //         tokenName: "WEB3 BTC",
                        //         tokenAddress:
                        //             "0xf845583f71b525c41b19c628d1e62a4bb76939e5",
                        //         walletAddress:
                        //             value.getUserData!.walletAddress ??
                        //                 "xxxxxx",
                        //       )));
                        //     },
                        //     leading: Image(
                        //       image:
                        //           AssetImage("assets/images/empty-token.png"),
                        //       height: 35,
                        //       width: 35,
                        //     ),
                        //     title: Text(
                        //       "WEB3 BTC",
                        //       style: TextStyle(
                        //         fontSize: 14,
                        //         shadows: shodow,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //     subtitle: Text(
                        //       "${value.walletCustomTokenBalanceInDouble} WEB3 BTC",
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         shadows: shodow,
                        //         fontWeight: FontWeight.w400,
                        //       ),
                        //     ),
                        //   ),
                        // ],
                        FutureBuilder<List<TokenModel>>(
                          future: dbHelper
                              .fetchTokensByNetwork(value.selectedChain),
                          builder: (context, snapshot) {
                            final tokenList = snapshot.data!;
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: tokenList.length,
                              itemBuilder: (context, index) {
                                final token = tokenList[index];
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(createRoute(SendEthToaddress(
                                      tokenName: token.symbol,
                                      isCustomTokenTransfer: true,
                                      tokenAddress: token.address,
                                      walletAddress:
                                          value.getUserData!.walletAddress ??
                                              "xxxxxx",
                                    )));
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  title: Text(
                                    token.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      shadows: shodow,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${token.balance} ${token.symbol}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      shadows: shodow,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(5)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              " Recent Transactions",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    createRoute(TransactionHistoryScreen()));
                              },
                              child: Text(
                                "See all ",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        value.checkData == true &&
                                (isSonicChain
                                    ? value.sonicTransactionList.isEmpty
                                    : value.otherChainsTransactionList.isEmpty)
                            ? Center(child: CircularProgressIndicator())
                            : value.checkData == false &&
                                    (isSonicChain
                                        ? value.sonicTransactionList.isEmpty
                                        : value
                                            .otherChainsTransactionList.isEmpty)
                                ? Center(
                                    child: Text(
                                      translate(
                                              context,
                                              AppString
                                                  .there_are_no_transactions_to_display)
                                          .toString(),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: isSonicChain
                                        ? value.sonicTransactionList.length > 6
                                            ? 6
                                            : value.sonicTransactionList.length
                                        : value.otherChainsTransactionList
                                                    .length >
                                                6
                                            ? 6
                                            : value.otherChainsTransactionList
                                                .length,
                                    itemBuilder: (context, index) {
                                      final sonicChainTransaction = isSonicChain
                                          ? value.sonicTransactionList[index]
                                          : SonicTransactionModel();
                                      final otherChainTransaction = isSonicChain
                                          ? OtherChainsTransactionModel()
                                          : value.otherChainsTransactionList[
                                              index];
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(4.0),
                                          // decoration: BoxDecoration(
                                          // border: Border(
                                          //     bottom: BorderSide(
                                          //         color: Colors.black12
                                          //             .withOpacity(.1))),
                                          // ),
                                          width: double.infinity,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color:
                                                          getTransactionColor(
                                                        colorIntensity: 100,
                                                        isSonicChain:
                                                            isSonicChain,
                                                        transactionFrom: isSonicChain
                                                            ? sonicChainTransaction
                                                                .from
                                                                .toString()
                                                            : otherChainTransaction
                                                                .from
                                                                .toString(),
                                                        userWalletAddress: value
                                                            .getUserData!
                                                            .walletAddress
                                                            .toString(),
                                                      )),
                                                  child: Icon(
                                                      getTransactionIcon(
                                                        isSonicChain:
                                                            isSonicChain,
                                                        transactionFrom: isSonicChain
                                                            ? sonicChainTransaction
                                                                .from
                                                                .toString()
                                                            : otherChainTransaction
                                                                .from
                                                                .toString(),
                                                        userWalletAddress: value
                                                            .getUserData!
                                                            .walletAddress
                                                            .toString(),
                                                      ),
                                                      size: 20,
                                                      color:
                                                          getTransactionColor(
                                                        colorIntensity: 800,
                                                        isSonicChain:
                                                            isSonicChain,
                                                        transactionFrom: isSonicChain
                                                            ? sonicChainTransaction
                                                                .from
                                                                .toString()
                                                            : otherChainTransaction
                                                                .from
                                                                .toString(),
                                                        userWalletAddress: value
                                                            .getUserData!
                                                            .walletAddress
                                                            .toString(),
                                                      ))),
                                              const SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTransactionType(
                                                      transactionFrom: isSonicChain
                                                          ? sonicChainTransaction
                                                              .from
                                                              .toString()
                                                          : otherChainTransaction
                                                              .from
                                                              .toString(),
                                                      userWalletAddress: value
                                                          .getUserData!
                                                          .walletAddress
                                                          .toString(),
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    isSonicChain
                                                        ? convertTimeStampToDateFormate(
                                                            sonicChainTransaction
                                                                    .timeStamp ??
                                                                "1740809234")
                                                        : DateFormat(
                                                                "MMM d, h:mm a")
                                                            .format(otherChainTransaction
                                                                .metadata!
                                                                .blockTimestamp!),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 10),
                                              const Spacer(),
                                              Column(
                                                children: [
                                                  Text(
                                                    isSonicChain
                                                        ? (BigInt.parse(sonicChainTransaction
                                                                    .value
                                                                    .toString()) /
                                                                BigInt.from(10)
                                                                    .pow(18))
                                                            .toString()
                                                        : otherChainTransaction
                                                            .value
                                                            .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         Navigator.of(context)
                  //             .push(createRoute(TransactionHistoryScreen()));
                  //       },
                  //       child: Text(
                  //         "See all ",
                  //         style: TextStyle(
                  //           color: AppColors.primaryColor,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
