import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:intl/intl.dart';
import 'package:link_on/screens/wallet/deposit.dart';
import 'package:link_on/screens/web3/web3Account_creation.dart';
import 'package:link_on/screens/web3/web3_wallet.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/withdraw/withdraw_history_provider.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/wallet/payment_history.dart';
import 'package:link_on/screens/wallet/withdrawal/withdrawal.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  SiteSetting? site;

  @override
  void initState() {
    super.initState();
    context.read<WithdrawHistoryProvider>().getUserBlance(context: context);
    context.read<WithdrawHistoryProvider>().getHistory();
    context
        .read<WithdrawHistoryProvider>()
        .getUserDataFunc(getStringAsync("user_id"));
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back)),
          title: Row(
            children: [
              SizedBox(
                height: 20,
                width: 100,
                child: Image(
                    image: NetworkImage(
                  getStringAsync("appLogo"),
                )),
              ),
              // Text(
              //   translate(context, AppString.wallet).toString(),
              //   style: TextStyle(
              //       fontStyle: FontStyle.italic,
              //       fontSize: 14,
              //       fontWeight: FontWeight.w400),
              // ),
            ],
          ),
        ),
        body: Consumer<WithdrawHistoryProvider>(
          builder: (context, userWalletValue, child) => userWalletValue
                      .checkUserData ==
                  true
              ? userWalletValue.isUserWalletDataLoaded == false
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Builder(builder: (context) {
                                String truncateDouble(
                                    double value, int decimalPlaces) {
                                  double multiplier =
                                      pow(10, decimalPlaces).toDouble();
                                  return ((value * multiplier).truncate() /
                                          multiplier)
                                      .toStringAsFixed(decimalPlaces);
                                }

                                String truncateString(
                                    String valueString, int decimalPlaces) {
                                  try {
                                    double value = double.parse(valueString);
                                    double multiplier =
                                        pow(10, decimalPlaces).toDouble();
                                    return ((value * multiplier).truncate() /
                                            multiplier)
                                        .toStringAsFixed(decimalPlaces);
                                  } catch (e) {
                                    return "Error: Invalid number format";
                                  }
                                }

                                final List<ChartData> chartData = [
                                  ChartData(
                                      translate(context, 'like')!,
                                      truncateString(
                                              userWalletValue.userWalletData!
                                                  .earning!.likeEarnings!,
                                              2)
                                          .toDouble(),
                                      const Color(0xffEF7765)),
                                  ChartData(
                                      translate(context, 'comments')!,
                                      truncateString(
                                              userWalletValue.userWalletData!
                                                  .earning!.commentEarnings!,
                                              2)
                                          .toDouble(),
                                      const Color(0xffFCDF5C)),
                                  ChartData(
                                      translate(context, 'share')!,
                                      truncateString(
                                              userWalletValue.userWalletData!
                                                  .earning!.shareEarnings!,
                                              2)
                                          .toDouble(),
                                      const Color(0xff6581C0)),
                                ];
                                final List<String> earningData = [
                                  translate(context, 'like')!,
                                  translate(context, 'comments')!,
                                  translate(context, 'share')!,
                                ];

                                final List<String> earningDataNo = [
                                  truncateString(
                                      userWalletValue.userWalletData!.earning!
                                          .likeEarnings!,
                                      2),
                                  truncateString(
                                      userWalletValue.userWalletData!.earning!
                                          .commentEarnings!,
                                      2),
                                  truncateString(
                                      userWalletValue.userWalletData!.earning!
                                          .shareEarnings!,
                                      2),
                                ];
                                final List<Color> earningColorsData = [
                                  const Color(0xffEF7765),
                                  const Color(0xffFCDF5C),
                                  const Color(0xff6581C0)
                                ];

                                final List<SalesData> dailyChartData = [
                                  SalesData(
                                      userWalletValue.userWalletData!
                                          .sevenDayEarning[6].day!,
                                      truncateString(
                                              userWalletValue
                                                  .userWalletData!
                                                  .sevenDayEarning[6]
                                                  .totalEarnings!,
                                              2)
                                          .toDouble()),
                                  SalesData(
                                      userWalletValue.userWalletData!
                                          .sevenDayEarning[5].day!,
                                      truncateString(
                                              userWalletValue
                                                  .userWalletData!
                                                  .sevenDayEarning[5]
                                                  .totalEarnings!,
                                              2)
                                          .toDouble()),
                                  SalesData(
                                      userWalletValue.userWalletData!
                                          .sevenDayEarning[4].day!,
                                      truncateString(
                                              userWalletValue
                                                  .userWalletData!
                                                  .sevenDayEarning[4]
                                                  .totalEarnings!,
                                              2)
                                          .toDouble()),
                                  SalesData(
                                      userWalletValue.userWalletData!
                                          .sevenDayEarning[3].day!,
                                      truncateString(
                                              userWalletValue
                                                  .userWalletData!
                                                  .sevenDayEarning[3]
                                                  .totalEarnings!,
                                              2)
                                          .toDouble()),
                                  SalesData(
                                      userWalletValue.userWalletData!
                                          .sevenDayEarning[2].day!,
                                      truncateString(
                                              userWalletValue
                                                  .userWalletData!
                                                  .sevenDayEarning[2]
                                                  .totalEarnings!,
                                              2)
                                          .toDouble()),
                                  SalesData(
                                      userWalletValue.userWalletData!
                                          .sevenDayEarning[1].day!,
                                      truncateString(
                                              userWalletValue
                                                  .userWalletData!
                                                  .sevenDayEarning[1]
                                                  .totalEarnings!,
                                              2)
                                          .toDouble()),
                                  SalesData(
                                      userWalletValue.userWalletData!
                                          .sevenDayEarning[0].day!,
                                      truncateString(
                                              userWalletValue
                                                  .userWalletData!
                                                  .sevenDayEarning[0]
                                                  .totalEarnings!,
                                              2)
                                          .toDouble()),
                                ];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Directionality(
                                      textDirection: ui.TextDirection
                                          .ltr, // Force LTR direction for this screen
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                .9,
                                        height: 180,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xff1F1F1F),
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/cardimage.png'),
                                                fit: BoxFit.cover)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              translate(context,
                                                      AppString.my_balance)
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  .8,
                                              child: Text(
                                                  '\$${truncateString(userWalletValue.userWalletData!.amount!, 2)}',
                                                  style: const TextStyle(
                                                      letterSpacing: 1,
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${userWalletValue.getUserData!.firstName!.toUpperCase()} ${userWalletValue.getUserData!.lastName!.toUpperCase()}',
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    letterSpacing: 1,
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          if (site!.chckPointLevelSystem ==
                                              "1") ...[
                                            Column(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                      color: const Color(
                                                          0xff1F1F1F),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Text(
                                                      userWalletValue
                                                          .getUserData!.points
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    translate(context,
                                                            AppString.points)
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            )
                                          ],
                                          if (site!.chckPointAllowWithdrawal ==
                                              '1') ...[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Withdrawal()));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                        color: const Color(
                                                            0xff1F1F1F),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100)),
                                                    child: const Icon(
                                                      Icons
                                                          .request_page_outlined,
                                                      size: 26,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    translate(context,
                                                            AppString.withdraw)
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddFunds(
                                                            site: site,
                                                          )));
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                      color: const Color(
                                                          0xff1F1F1F),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  translate(context,
                                                          AppString.deposit)
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (userWalletValue.getUserData!
                                                      .isWalletExist ==
                                                  1) {
                                                //wallet already created
                                                Navigator.of(context).push(
                                                    createRoute(
                                                        Web3WalletScreen()));
                                              } else {
                                                //create web3 wallet
                                                Navigator.of(context).push(
                                                    createRoute(
                                                        Web3AccoutCreationScreen()));
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                      color: const Color(
                                                          0xff1F1F1F),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: const Image(
                                                    image: AssetImage(
                                                        "assets/images/wallet.png"),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    translate(
                                                            context,
                                                            AppString
                                                                .web3_wallet)
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff1F1F1F),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            LineIcons.money_bill,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            translate(
                                                    context, AppString.earnings)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              translate(
                                                      context, AppString.today)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "+\$${truncateString(userWalletValue.userWalletData!.sevenDayEarning[0].totalEarnings!, 2)}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              translate(context,
                                                      AppString.seven_days)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "+\$${truncateString(userWalletValue.userWalletData!.earning!.sevenDayEarning!, 2)}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              translate(context,
                                                      AppString.cumulative)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "+\$${truncateString(userWalletValue.userWalletData!.earning!.totalEarnings!, 2)}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(thickness: 1),
                                    // recent transactions
                                    Row(
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 150,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Center(
                                            child: Text(
                                              translate(
                                                      context,
                                                      AppString
                                                          .recent_transactions)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PaymentHistory(),
                                                ));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color(0xff1F1F1F),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 6),
                                            child: Text(
                                              translate(context,
                                                      AppString.see_all)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // color: const Color(0xff1F1F1F),
                                      ),
                                      height:
                                          205, // Adjust this value as needed
                                      child: userWalletValue.checkData == true
                                          ? userWalletValue
                                                  .withdrawhistory.isEmpty
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
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: userWalletValue
                                                      .withdrawhistory.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors
                                                                  .black12
                                                                  .withOpacity(
                                                                      .1))),
                                                    ),
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              height: 40,
                                                              width: 40,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  color: (userWalletValue
                                                                              .withdrawhistory[
                                                                                  index]
                                                                              .type ==
                                                                          'Paypal')
                                                                      ? Colors.blue[
                                                                          100]
                                                                      : Colors.yellow[
                                                                          100]),
                                                              child: Icon(
                                                                (userWalletValue
                                                                            .withdrawhistory[
                                                                                index]
                                                                            .type ==
                                                                        'Paypal')
                                                                    ? Icons
                                                                        .paypal_outlined
                                                                    : Icons
                                                                        .payment_outlined,
                                                                size: 20,
                                                                color: (userWalletValue
                                                                            .withdrawhistory[
                                                                                index]
                                                                            .type ==
                                                                        'Paypal')
                                                                    ? Colors.blue[
                                                                        800]
                                                                    : Colors.yellow[
                                                                        800],
                                                              )),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${userWalletValue.withdrawhistory[index].type}",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                userWalletValue
                                                                    .withdrawhistory[
                                                                        index]
                                                                    .createdAt!
                                                                    .timeAgo,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Spacer(),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                "\$${userWalletValue.withdrawhistory[index].amount}",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              userWalletValue
                                                                          .withdrawhistory[
                                                                              index]
                                                                          .status ==
                                                                      "Approve"
                                                                  ? Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          color:
                                                                              Colors.green[100]),
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              7,
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          translate(
                                                                              context,
                                                                              'complete')!,
                                                                          style: TextStyle(
                                                                              color: Colors.green[400],
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : userWalletValue
                                                                              .withdrawhistory[index]
                                                                              .status ==
                                                                          "Pending"
                                                                      ? Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                              color: Colors.red[100]),
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 7,
                                                                              vertical: 4),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              translate(context, 'pending')!,
                                                                              style: TextStyle(color: Colors.red[400], fontSize: 12, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                              color: Colors.purple[100]),
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 7,
                                                                              vertical: 4),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              translate(context, 'rejected')!,
                                                                              style: TextStyle(color: Colors.purple[400], fontSize: 12, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                        )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                          : Center(
                                              child: Text(
                                                translate(context,
                                                    'no_transactions_to_display')!,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    // statistics
                                    Text(
                                      translate(context, 'earning_breakdown')!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 170,
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xff1F1F1F),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 150,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.40,
                                            child: SfCircularChart(
                                              centerX: '45%',
                                              series: <CircularSeries>[
                                                DoughnutSeries<ChartData,
                                                    String>(
                                                  dataSource: chartData,
                                                  xValueMapper:
                                                      (ChartData data, _) =>
                                                          data.x,
                                                  yValueMapper:
                                                      (ChartData data, _) =>
                                                          data.y,
                                                  pointColorMapper:
                                                      (ChartData data, _) =>
                                                          data.color,
                                                )
                                              ],
                                              tooltipBehavior: TooltipBehavior(
                                                enable: true,
                                                builder: (data, point, series,
                                                    pointIndex, seriesIndex) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    color: Colors.black,
                                                    child: Text(
                                                      '${point.x} : ${truncateDouble(point.y!.toDouble(), 2)}', // Display the y-value in the tooltip
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.45,
                                                child: ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: earningData.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      children: [
                                                        Container(
                                                          height: 10,
                                                          width: 10,
                                                          color:
                                                              earningColorsData[
                                                                  index],
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                        ),
                                                        SizedBox(
                                                          width: 70,
                                                          child: Text(
                                                            earningData[index],
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          '\$${earningDataNo[index]}',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      translate(context, 'daily_earning')!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 170,
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 10),
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xff1F1F1F),
                                      ),
                                      child: SizedBox(
                                        height: 150,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.3,
                                        child: SfCartesianChart(
                                          primaryXAxis: DateTimeAxis(
                                            majorGridLines: const MajorGridLines(
                                                width:
                                                    0), // Hide major grid lines
                                            minorGridLines: const MinorGridLines(
                                                width:
                                                    0), // Hide minor grid lines
                                            intervalType:
                                                DateTimeIntervalType.days,
                                            axisLabelFormatter:
                                                (AxisLabelRenderDetails
                                                    axisLabelRenderArgs) {
                                              // Ensure the value is a DateTime object
                                              DateTime dateValue = DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      axisLabelRenderArgs.value
                                                          .toInt());
                                              // Extract the day name and take the first three letters
                                              String dayName = DateFormat.EEEE()
                                                  .format(dateValue)
                                                  .substring(0, 3);
                                              return ChartAxisLabel(
                                                  dayName,
                                                  axisLabelRenderArgs
                                                      .textStyle);
                                            },
                                            labelStyle: const TextStyle(
                                                fontSize: 10,
                                                color: Colors
                                                    .white), // Set x-axis label color to white
                                          ),
                                          primaryYAxis: const NumericAxis(
                                            majorGridLines: MajorGridLines(
                                                width:
                                                    0), // Hide major grid lines
                                            minorGridLines: MinorGridLines(
                                                width:
                                                    0), // Hide minor grid lines
                                            labelStyle: TextStyle(
                                                fontSize: 8,
                                                color: Colors
                                                    .white), // Set y-axis label color to white
                                          ),
                                          series: <CartesianSeries>[
                                            AreaSeries<SalesData, DateTime>(
                                              dataSource: dailyChartData,
                                              color: const Color(0xffEF7765)
                                                  .withOpacity(0.2),
                                              xValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.year,
                                              yValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.sales,
                                            ),
                                            LineSeries<SalesData, DateTime>(
                                              dataSource: dailyChartData,
                                              color: const Color(0xffEF7765),
                                              xValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.year,
                                              yValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.sales,
                                              markerSettings:
                                                  const MarkerSettings(
                                                isVisible: true, // Show points
                                                color:
                                                    Colors.white, // Point color
                                              ),
                                            )
                                          ],
                                          plotAreaBorderWidth: 0,
                                          tooltipBehavior: TooltipBehavior(
                                            enable: true,
                                            builder: (data, point, series,
                                                pointIndex, seriesIndex) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                color: Colors.black,
                                                child: Text(
                                                  '${point.y}', // Display the y-value in the tooltip
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              );
                                            },
                                          ),
                                          trackballBehavior: TrackballBehavior(
                                            enable: true,
                                            lineColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}

class SalesData {
  SalesData(this.year, this.sales);

  final DateTime year;
  final double sales;
}
