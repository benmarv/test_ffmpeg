import 'package:flutter/material.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/advertisement_controller/advertisement_controller.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AdvertisementRequestPage extends StatefulWidget {
  const AdvertisementRequestPage({super.key});

  @override
  State<AdvertisementRequestPage> createState() =>
      _AdvertisementRequestPageState();
}

class _AdvertisementRequestPageState extends State<AdvertisementRequestPage> {
  @override
  void initState() {
    Provider.of<AdvertisementController>(context, listen: false)
        .advertisements
        .clear();
    Provider.of<AdvertisementController>(context, listen: false)
        .fetchAdvertisementRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          translate(context, AppString.advertisement_requests).toString(),
        ),
      ),
      body: Consumer<AdvertisementController>(
        builder: (context, value, child) => value.isLoading == true &&
                value.advertisements.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : value.isLoading == false && value.advertisements.isEmpty
                ? Center(
                    child: Text(
                      translate(context, AppString.no_data_found).toString(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        onTap: () async {
                          if (await canLaunchUrlString(
                              value.advertisements[index].link!)) {
                            launchUrlString(value.advertisements[index].link!);
                          } else {
                            toast(translate(context, 'could_not_launch_url')!);
                          }
                        },
                        leading: Container(
                          height: 55,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: NetworkImage(
                                    value.advertisements[index].image!),
                                fit: BoxFit.cover),
                          ),
                        ),
                        title: Text(
                          value.advertisements[index].title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value.advertisements[index].body!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileTab(
                                          userId: value.advertisements[index]
                                              .userData!.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(
                                        translate(context, 'view_user')!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    value
                                        .approveOrDisapproveAd(
                                      'approve',
                                      int.parse(
                                        value.advertisements[index].id
                                            .toString(),
                                      ),
                                    )
                                        .then((val) {
                                      if (val['key'] != 'balance') {
                                        value.removeAdvertisement(index);
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Text(
                                          translate(context, 'approve')!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    value
                                        .approveOrDisapproveAd(
                                          'reject',
                                          int.parse(
                                            value.advertisements[index].id
                                                .toString(),
                                          ),
                                        )
                                        .then(
                                          (val) =>
                                              value.removeAdvertisement(index),
                                        );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Text(
                                          translate(context, 'reject')!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      itemCount: value.advertisements.length,
                    ),
                  ),
      ),
    );
  }
}
