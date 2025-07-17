import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/controllers/donner_provider/donner_provider.dart';
import 'package:link_on/models/posts.dart' as post_model;
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../consts/colors.dart';
import 'donation_search_page.dart';

class DonersPage extends StatefulWidget {
  final post_model.Posts? posts;
  DonersPage({super.key, this.posts});

  @override
  State<DonersPage> createState() => _DonersPageState();
}

class _DonersPageState extends State<DonersPage> {
  int numberOfDonner = 0;

  List<Usr> donnerList = [];

  @override
  void initState() {
    final donnerProvider = Provider.of<DonnersProvider>(context, listen: false);

    setState(() {
      donnerList = donnerProvider.getDonerList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Color randomColor = Colors
    //     .primaries[Random().nextInt(Colors.primaries.length)]
    //     .withOpacity(.5);
    // final donnerProvider = Provider.of<DonnersProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 131, 199, 99),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.primaryLightColor,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 45,
                        width: 250,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DonationSearchPage()));
                          },
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 0),
                              fillColor: Colors.red,
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: AppColors.primaryLightColor,
                              hintText: "Search here...",
                              hintStyle:
                                  TextStyle(color: AppColors.primaryLightColor),
                              enabled: false,
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: AppColors.primaryLightColor,
                                    width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: AppColors.primaryLightColor,
                                    width: 1),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: AppColors.primaryLightColor,
                                    width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1),
                              ),
                            ),
                            style: TextStyle(
                                color: const Color.fromARGB(255, 5, 5, 5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hellow! ${widget.posts!.user!.firstName.toString()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.white),
                        color: Colors.white.withOpacity(.3),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.posts!.user!.cover.toString(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primaryColor),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "You've Helped",
                        style: TextStyle(
                          color: AppColors.primaryLightColor,
                        ),
                      ),
                      Text(
                        widget.posts!.donation!.collectedAmount.toString(),
                        style: TextStyle(
                            fontSize: 30, color: AppColors.primaryLightColor),
                      ),
                      Text(
                        "Buy food and shelter",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryLightColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Who I've Helped",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: donnerList.length,
                      itemBuilder: (context, index) {
                        // final image =
                        //     'https://picsum.photos/200/300?random=$index';
                        // var name = faker.person.name().toString();
                        // var money = faker.randomGenerator.integer(201);

                        if (donnerList.isEmpty) {
                          print("List is empty.");
                        } else if (donnerList.isNotEmpty) {
                          print(
                              "List is not empty the data is ${donnerList.first}");
                        }

                        return ListTile(
                          leading: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.transparent,
                                  offset: Offset(2, 2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl:
                                    donnerList[index].firstName.toString(),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            donnerList[index].lastName.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _showThankYouDialog(context);
                              },
                              icon: Icon(
                                Icons.message,
                              )),
                          subtitle: Text(
                            "\$ ${donnerList[index].balance}",
                            style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showThankYouDialog(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Say Thank You",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your message here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                toast("Your message is sent.", bgColor: Colors.green);
                Navigator.pop(context);
              },
              child: Text(
                "Send",
                style: TextStyle(color: AppColors.primaryLightColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
