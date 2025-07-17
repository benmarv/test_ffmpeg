import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/bloodDonation/blood_requests.dart';
import 'package:link_on/screens/bloodDonation/find_donor.dart';
import 'package:link_on/screens/bloodDonation/update_donor_profile.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class BloodDonation extends StatefulWidget {
  const BloodDonation({super.key});

  @override
  State<BloodDonation> createState() => _BloodDonationState();
}

class _BloodDonationState extends State<BloodDonation> {
  bool data = false;
  Usr getUsrData = Usr();

  Future<void> userdata() async {
    dynamic res =
        await apiClient.get_user_data(userId: getStringAsync('user_id'));

    log('value of res: $res');

    setState(() {
      data = true;
    });
    if (res == null) {
      return;
    }
    if (res["code"] == '200') {
      log('code 200 : ${res['data']}');
      getUsrData = Usr.fromJson(res["data"]);
    } else {
      toast(translate(context, 'error_user_profile').toString() +
          res['errors']['error_text']);
    }
  }

  @override
  void initState() {
    log('value of user id: ${getStringAsync('user_id')}');
    userdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 20,
              width: 100,
              child: Image(
                image: NetworkImage(
                  getStringAsync("appLogo"),
                ),
              ),
            ),
            // Text(
            //   translate(context, 'blood_bank').toString(),
            //   style: const TextStyle(
            //     fontStyle: FontStyle.italic,
            //     fontSize: 14,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
          ],
        ),
        centerTitle: true,
      ),
      body: !data
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/main.PNG'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FindBloodDonor(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 0.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xffFCFCFC),
                            ),
                            child: const Image(
                              image: AssetImage(
                                  'assets/images/blood-donation.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            translate(context, 'find_donors').toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BloodRequests(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xffFCFCFC),
                            ),
                            child: Icon(
                              Icons.water_drop_rounded,
                              color: Colors.red[800],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            translate(context, 'blood_requests').toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateDonorInfo(),
                        ),
                      );
                    },
                    child: Text(
                      translate(context, 'update_your_info').toString(),
                      style: const TextStyle(
                        decorationStyle: TextDecorationStyle.solid,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
