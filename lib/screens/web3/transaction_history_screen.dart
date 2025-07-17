import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/other_chains_transaction_model.dart';
import 'package:link_on/models/sonic_transaction_model.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/web3/web3_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    final pro = Provider.of<Web3Provider>(context, listen: false);
    pro.sonicTransactionListMainScreen.clear();
    pro.otherChainsTransactionListMainScreen.clear();
    _fetchTransactions(pro);
    // Pagination
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final scrollPosition = _scrollController.position.pixels;
      double scrollPercentage = (scrollPosition / maxScrollExtent) * 100;

      if (scrollPercentage >= 70 && pro.checkData == false) {
        _currentPage++;
        _fetchTransactions(pro);
      }
    });
    super.initState();
  }

  void _fetchTransactions(Web3Provider pro) {
    bool isSonicChain = pro.selectedChain == "Sonic Mainnet" ||
        pro.selectedChain == "Sonic Blaze Testnet";
    if (isSonicChain) {
      pro.getSonicChainTransactionHistory(
        page: _currentPage,
        maxCount: "15",
        isTransactionHistoryScreen: true,
      );
    } else {
      pro.getOtherChainsTransactionHistory(
        page: _currentPage,
        maxCount: "15",
        isTransactionHistoryScreen: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: Text(
            "Transaction History",
          ),
        ),
        body: Consumer<Web3Provider>(builder: (context, value, child) {
          bool isSonicChain = value.selectedChain == "Sonic Mainnet" ||
              value.selectedChain == "Sonic Blaze Testnet";
          return value.checkData == true &&
                  (isSonicChain
                      ? value.sonicTransactionListMainScreen.isEmpty
                      : value.otherChainsTransactionListMainScreen.isEmpty)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : value.checkData == false &&
                      (isSonicChain
                          ? value.sonicTransactionListMainScreen.isEmpty
                          : value.otherChainsTransactionListMainScreen.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          loading(),
                          Text(translate(
                              context, 'no_transactions_to_display')!),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: isSonicChain
                          ? value.sonicTransactionListMainScreen.length
                          : value.otherChainsTransactionListMainScreen.length,
                      itemBuilder: (context, index) => TransactionListItem(
                        isSonicTransaction: isSonicChain,
                        provider: value,
                        transaction: isSonicChain
                            ? value.sonicTransactionListMainScreen[index]
                            : value.otherChainsTransactionListMainScreen[index],
                      ),
                    );
        }));
  }
}

class TransactionListItem extends StatelessWidget {
  final bool isSonicTransaction;
  final dynamic transaction;
  final Web3Provider provider;

  const TransactionListItem({
    Key? key,
    required this.isSonicTransaction,
    required this.transaction,
    required this.provider,
  }) : super(key: key);

  String convertTimeStampToDateFormate(int timeStamp) {
    // Convert the Unix timestamp to DateTime
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000, isUtc: true)
            .toLocal();

    // Format the DateTime as "Mar 1, 3:15 PM"
    String formattedDate = DateFormat("MMM d, h:mm a").format(dateTime);

    return formattedDate;
  }

  String calculateTotalGasFee({required int gas, required int gasPrice}) {
    BigInt totalGasFee = (BigInt.from(gas) * BigInt.from(gasPrice));
    final gasfee = totalGasFee / BigInt.from(10).pow(18);
    return gasfee.toString();
  }

  String calculateTotalTransactionCost(
      {required BigInt amount, required BigInt gasFee}) {
    BigInt totalGasFee = amount + gasFee;
    final gasfee = totalGasFee / BigInt.from(10).pow(18);
    return gasfee.toString();
  }

  Widget _transactionRow(String title, String value,
      {FontWeight fontWeight = FontWeight.normal}) {
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
              )),
        ],
      ),
    );
  }

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
          content: SingleChildScrollView(
            child: Container(
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
                          Provider.of<Web3Provider>(context, listen: false)
                              .copyText(
                            text: isSonicModel
                                ? sonicTransaction.hash.toString()
                                : otherTransaction.hash.toString(),
                          );
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
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<Web3Provider>(context, listen: false)
                                .copyText(
                              text: isSonicModel
                                  ? sonicTransaction.from.toString()
                                  : otherTransaction.from.toString(),
                            );
                          },
                          child: Text(
                            isSonicModel
                                ? "${sonicTransaction.from?.substring(0, 4) ?? 'xxxx'}...${sonicTransaction.from?.substring(sonicTransaction.from!.length - 4) ?? 'xxxx'}"
                                : "${otherTransaction.from?.substring(0, 4) ?? 'xxxx'}...${otherTransaction.from?.substring(otherTransaction.from!.length - 4) ?? 'xxxx'}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                      GestureDetector(
                        onTap: () {
                          Provider.of<Web3Provider>(context, listen: false)
                              .copyText(
                            text: isSonicModel
                                ? sonicTransaction.to.toString()
                                : otherTransaction.to.toString(),
                          );
                        },
                        child: Text(
                            isSonicModel
                                ? "${sonicTransaction.to?.substring(0, 4) ?? 'xxxx'}...${sonicTransaction.to?.substring(sonicTransaction.to!.length - 4) ?? 'xxxx'}"
                                : "${otherTransaction.to?.substring(0, 4) ?? 'xxxx'}...${otherTransaction.to?.substring(otherTransaction.to!.length - 4) ?? 'xxxx'}",
                            style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Transaction details
                  Text("Transaction",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 8),

                  _transactionRow(
                    "Nonce",
                    isSonicModel
                        ? sonicTransaction.nonce.toString()
                        // : otherTransaction.nonce.toString(),
                        : "",
                  ),
                  _transactionRow(
                      "Amount",
                      isSonicModel
                          ? (BigInt.parse(sonicTransaction.value.toString()) /
                                  BigInt.from(10).pow(18))
                              .toString()
                          : otherTransaction.value.toString()),

                  if (isSonicModel) ...[
                    _transactionRow(
                        "Gas Limit (Units)", sonicTransaction.gas.toString()),
                    _transactionRow(
                      "Gas Used (Units)",
                      sonicTransaction.gasUsed.toString(),
                    ),
                    _transactionRow(
                      "Gas Price (WEI)",
                      sonicTransaction.gasPrice.toString(),
                    ),
                    Divider(),
                    _transactionRow(
                        "Total gas fee",
                        calculateTotalGasFee(
                            gas: int.parse(sonicTransaction.gasUsed ?? "21620"),
                            gasPrice: int.parse(
                                sonicTransaction.gasPrice ?? "2500000000"))),
                    Divider(),

                     // Total
                    _transactionRow(
                      "Total",
                      isSonicModel
                          ? calculateTotalTransactionCost(
                              amount:
                                  BigInt.parse(sonicTransaction.value ?? "0"),
                              gasFee: BigInt.parse(
                                      sonicTransaction.gasUsed ?? '21620') *
                                  BigInt.parse(sonicTransaction.gasPrice ??
                                      '2500000000'))
                          : "444444444",
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSender = transaction.from.toString().toLowerCase() == provider.getUserData!.walletAddress.toString().toLowerCase();
    String title = isSender ? "Transfer" : "Deposit";
    String formattedDate = isSonicTransaction
        ? convertTimeStampToDateFormate(
            int.tryParse(transaction.timeStamp.toString()) ?? 0)
        : DateFormat("MMM d, h:mm a")
            .format(transaction.metadata!.blockTimestamp!);
    String amount = isSonicTransaction
        ? (BigInt.parse(transaction.value.toString()) / BigInt.from(10).pow(18))
            .toString()
        : transaction.value.toString();

    return ListTile(
      onTap: () {
        showTransactionDialog(
          context,
          isSonicModel: isSonicTransaction,
          sonicTransaction:
              isSonicTransaction ? transaction : SonicTransactionModel(),
          otherTransaction:
              isSonicTransaction ? OtherChainsTransactionModel() : transaction,
        );
      },
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isSender ? Colors.blue[100] : Colors.yellow[100],
        ),
        child: Icon(
          isSender
              ? Icons.keyboard_double_arrow_up_outlined
              : Icons.keyboard_double_arrow_down_outlined,
          size: 20,
          color: isSender ? Colors.blue[800] : Colors.yellow[800],
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        formattedDate,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Text(
        amount,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
