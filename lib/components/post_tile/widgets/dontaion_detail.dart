import 'package:flutter/material.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/components/post_tile/widgets/donation_post.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DontaionDetailScreen extends StatefulWidget {
  const DontaionDetailScreen(
      {super.key, required this.donationPost, required this.index});
  final Posts donationPost;
  final int index;

  @override
  State<DontaionDetailScreen> createState() => _DontaionDetailScreenState();
}

class _DontaionDetailScreenState extends State<DontaionDetailScreen> {
  final TextEditingController _amountController = TextEditingController();
  Future<void> donate({required String fundId, required String amount}) async {
    customDialogueLoader(context: context);
    Map<String, dynamic> dataArray = {
      "fund_id": fundId,
      "amount": amount,
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: 'donate', apiData: dataArray);
    if (res["code"] == '200') {
      Navigator.pop(context);
      toast(res['message']);
      addAmountInCollectedAmount(amount);
    } else {
      Navigator.pop(context);
      toast(res['message']);
      log('Error : ${res['message']}');
    }
    _amountController.clear();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  late String collectedAmount;
  @override
  void initState() {
    // Initialize collectedAmount based on the sharedPost or the donation itself
    collectedAmount = widget.donationPost.sharedPost != null
        ? widget.donationPost.sharedPost!.donation!.collectedAmount!
        : widget.donationPost.donation!.collectedAmount!;
    print('init collected amount : $collectedAmount');
    super.initState();
  }

  void addAmountInCollectedAmount(String amountToAdd) {
    print(
        'addAmountInCollectedAmount collected amount : $collectedAmount $amountToAdd');
    setState(() {
      try {
        // Attempt to parse both strings to integers
        int currentAmount = int.parse(collectedAmount);
        int newAmount = currentAmount + int.parse(amountToAdd);
        collectedAmount = newAmount.toString();
        Provider.of<PostProvider>(context, listen: false)
            .addAmountInCollectedDonation(
                index: widget.index, amount: collectedAmount);
      } catch (e) {
        print('Error parsing numbers: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, "details")!,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  Share.share(widget.donationPost.sharedPost != null
                      ? widget.donationPost.sharedPost!.postText!
                      : widget.donationPost.postLink!);
                },
                child: const Icon(
                  Icons.share,
                  size: 18,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      image: widget.donationPost.sharedPost != null
                          ? widget.donationPost.sharedPost!.donation!.image
                          : widget.donationPost.donation!.image,
                    ),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height * .25,
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(widget.donationPost.sharedPost !=
                                null
                            ? widget.donationPost.sharedPost!.donation!.image!
                            : widget.donationPost.donation!.image!),
                        fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .8,
                    child: Text(
                      widget.donationPost.sharedPost != null
                          ? widget.donationPost.sharedPost!.donation!.title!
                          : widget.donationPost.donation!.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.donationPost.sharedPost != null
                        ? widget.donationPost.sharedPost!.donation!.description!
                        : widget.donationPost.donation!.description!,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.65)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DonationProgressBar(
                      totalDonations: double.parse(collectedAmount),
                      totalGoal: double.parse(widget.donationPost.sharedPost !=
                              null
                          ? widget.donationPost.sharedPost!.donation!.amount!
                          : widget.donationPost.donation!.amount!)),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        collectedAmount,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        translate(context, "collected")!,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      Text(
                        widget.donationPost.sharedPost != null
                            ? widget.donationPost.sharedPost!.donation!
                                .participatedUsers!
                                .toString()
                            : widget.donationPost.donation!.participatedUsers!
                                .toString(),
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      const Icon(
                        Icons.people_alt_rounded,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    translate(context, "organized_by")!,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 60,
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300]),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              widget.donationPost.sharedPost != null
                                  ? widget
                                      .donationPost.sharedPost!.user!.avatar!
                                  : widget.donationPost.user!.avatar!,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.donationPost.sharedPost != null
                                ? "${widget.donationPost.sharedPost!.user!.firstName} ${widget.donationPost.sharedPost!.user!.lastName}"
                                : "${widget.donationPost.user!.firstName} ${widget.donationPost.user!.lastName}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                radiusCircular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => _amountController.text =
                                        '10', // Set amount to 10
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          translate(context, 'amount_10')!,
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _amountController.text =
                                        '30', // Set amount to 30
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          translate(context, 'amount_30')!,
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          // keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _amountController.text =
                                        '50', // Set amount to 50
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          translate(context, 'amount_50')!,
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      style: TextStyle(
                                          color: AppColors.primaryColor),
                                      controller: _amountController,
                                      decoration: InputDecoration(
                                        hintText: translate(
                                            context, 'enter_custom_amount')!,
                                        hintStyle: TextStyle(
                                            color: AppColors.primaryColor),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize:
                                          const Size(double.infinity, 40),
                                      backgroundColor: AppColors.primaryColor,
                                    ),
                                    onPressed: () {
                                      // Handle donation logic here
                                      if (_amountController.text
                                          .trim()
                                          .isEmpty) {
                                        toast(translate(context,
                                            'enter_amount_to_donate')!);
                                      } else if (_amountController.text ==
                                          '0') {
                                        toast(
                                            translate(context, 'amount_zero')!);
                                      } else {
                                        Navigator.pop(context);

                                        donate(
                                          amount: _amountController.text,
                                          fundId: widget.donationPost
                                                      .sharedPost !=
                                                  null
                                              ? widget.donationPost.sharedPost!
                                                  .donation!.id!
                                              : widget
                                                  .donationPost.donation!.id!,
                                        );
                                      }
                                    },
                                    child: Text(
                                      translate(context, 'donate')!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize:
                                          const Size(double.infinity, 40),
                                      // primary: Colors.grey[300],
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      translate(context, 'cancel')!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primaryColor),
                      child: Center(
                        child: Text(
                          translate(context, 'donate_now')!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
