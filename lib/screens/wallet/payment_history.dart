import 'package:flutter/material.dart';
import 'package:link_on/controllers/withdraw/withdraw_history_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  void initState() {
    super.initState();
    context.read<WithdrawHistoryProvider>().getHistory();
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
          translate(context, 'payment_history')!,
        ),
      ),
      body: Consumer<WithdrawHistoryProvider>(
        builder: (context, value, child) => value.isLoading == true &&
                value.withdrawhistory.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading(),
                    Text(translate(context, 'no_transactions_to_display')!),
                  ],
                ),
              )
            : value.isLoading == false && value.withdrawhistory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading(),
                        Text(translate(context, 'no_transactions_to_display')!),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: value.withdrawhistory.length,
                    itemBuilder: (context, index) => SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: (value.withdrawhistory[index].type ==
                                          'Paypal')
                                      ? Colors.blue[100]
                                      : Colors.yellow[100]),
                              child: Icon(
                                (value.withdrawhistory[index].type == 'Paypal')
                                    ? Icons.paypal_outlined
                                    : Icons.payment_outlined,
                                size: 20,
                                color: (value.withdrawhistory[index].type ==
                                        'Paypal')
                                    ? Colors.blue[800]
                                    : Colors.yellow[800],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${value.withdrawhistory[index].type}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  value.withdrawhistory[index].createdAt!
                                      .timeAgo,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  "\$${value.withdrawhistory[index].amount}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                value.withdrawhistory[index].status == "Approve"
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.green[100]),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 4),
                                        child: Center(
                                          child: Text(
                                            translate(context, 'complete')!,
                                            style: TextStyle(
                                                color: Colors.green[400],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )
                                    : value.withdrawhistory[index].status ==
                                            "Pending"
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.red[100]),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 4),
                                            child: Center(
                                              child: Text(
                                                translate(context, 'pending')!,
                                                style: TextStyle(
                                                    color: Colors.red[400],
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.purple[100]),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 4),
                                            child: Center(
                                              child: Text(
                                                translate(context, 'rejected')!,
                                                style: TextStyle(
                                                    color: Colors.purple[400],
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
