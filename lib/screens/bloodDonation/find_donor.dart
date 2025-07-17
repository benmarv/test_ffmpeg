import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';

import 'package:link_on/screens/bloodDonation/become_donor.dart';
import 'package:link_on/screens/bloodDonation/blood_donation_provider.dart';
import 'package:link_on/screens/bloodDonation/find_distance_googlemap.dart';
import 'package:link_on/screens/message_details.dart/messaging_with_agora.dart';
import 'package:link_on/screens/spaces/spaces_home/widgets/space_material_button.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';
import 'package:provider/provider.dart';

class FindBloodDonor extends StatefulWidget {
  const FindBloodDonor({super.key});

  @override
  State<FindBloodDonor> createState() => _FindBloodDonorState();
}

class _FindBloodDonorState extends State<FindBloodDonor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BloodDonationProvider>(context, listen: false)
          .removeSelectedBloodGroup();
      Provider.of<BloodDonationProvider>(context, listen: false)
          .getDonorsList(context: context, bloodGroup: '');
    });
  }

  double? latitude;
  double? longitude;
  Future<void> getAddressCoordinates(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location place = locations.first;
      latitude = place.latitude;
      longitude = place.longitude;
    } else {
      print('No placemarks found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        // backgroundColor: const Color(0xffF4F4F4),
        title: Text(
          translate(context, 'find_donor')!,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BecomeADonor(),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                color: Colors.red[800],
              ),
            ),
          )
        ],
      ),
      body: Consumer<BloodDonationProvider>(
        builder: (context, vloodDonationProviderValue, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: AssetImage('assets/images/search.PNG'),
                          fit: BoxFit.contain)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    bloodGroupContainer(
                        'A+',
                        vloodDonationProviderValue.selectedBloodGroup == 'A+',
                        context),
                    bloodGroupContainer(
                        'B+',
                        vloodDonationProviderValue.selectedBloodGroup == 'B+',
                        context),
                    bloodGroupContainer(
                        'AB+',
                        vloodDonationProviderValue.selectedBloodGroup == 'AB+',
                        context),
                    bloodGroupContainer(
                        'O+',
                        vloodDonationProviderValue.selectedBloodGroup == 'O+',
                        context),
                  ],
                ),
                const SizedBox(height: 10), // Space between rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    bloodGroupContainer(
                        'A-',
                        vloodDonationProviderValue.selectedBloodGroup == 'A-',
                        context),
                    bloodGroupContainer(
                        'B-',
                        vloodDonationProviderValue.selectedBloodGroup == 'B-',
                        context),
                    bloodGroupContainer(
                        'AB-',
                        vloodDonationProviderValue.selectedBloodGroup == 'AB-',
                        context),
                    bloodGroupContainer(
                        'O-',
                        vloodDonationProviderValue.selectedBloodGroup == 'O-',
                        context),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    translate(context, 'available_donors')!,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<BloodDonationProvider>(
                  builder: (context, bloodDonationProviderValue, child) =>
                      ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bloodDonationProviderValue.donorList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            isDismissible: true,
                            isScrollControlled: true,
                            context: context,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            builder: (context) {
                              String dateOfBirth = bloodDonationProviderValue
                                  .donorList[index].dateOfBirth!;
                              DateTime parsedDate =
                                  DateFormat("yyyy-MM-dd").parse(dateOfBirth);
                              DateTime currentDate = DateTime.now();

                              int ageInYears =
                                  currentDate.year - parsedDate.year;
                              int monthDifference =
                                  currentDate.month - parsedDate.month;

                              // Correcting the month difference calculation
                              int correctedMonthDifference =
                                  (currentDate.month > parsedDate.month)
                                      ? currentDate.month - parsedDate.month
                                      : currentDate.month +
                                          12 -
                                          parsedDate.month;

                              if (monthDifference < 0 ||
                                  (monthDifference == 0 &&
                                      currentDate.day < parsedDate.day)) {
                                ageInYears--;
                              }
                              String age;

                              // Check if age is less than 1 year
                              if (ageInYears < 1) {
                                age =
                                    '$correctedMonthDifference ${translate(context, 'months')}';
                              } else {
                                age =
                                    '$ageInYears ${translate(context, 'years')}';
                              }

                              getAddressCoordinates(
                                bloodDonationProviderValue
                                    .donorList[index].address
                                    .toString(),
                              );
                              return Container(
                                color: Theme.of(context).colorScheme.secondary,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      bottomSheetTopDivider(
                                          color: AppColors.primaryColor),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        height: 80,
                                        width: 80,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              bloodDonationProviderValue
                                                  .donorList[index].avatar!,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.person),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${bloodDonationProviderValue.donorList[index].firstName} ${bloodDonationProviderValue.donorList[index].lastName!}",
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      if (bloodDonationProviderValue
                                              .donorList[index].phoneNumber !=
                                          null)
                                        Row(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Icon(Icons.phone),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${bloodDonationProviderValue.donorList[index].phoneNumber}",
                                            )
                                          ],
                                        ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.email_outlined),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${bloodDonationProviderValue.donorList[index].email}",
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.person),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            age,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.bloodtype),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${bloodDonationProviderValue.donorList[index].bloodGroup}",
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          // countAndText(
                                          //   index,
                                          //   count: "50",
                                          //   text: 'Friends',
                                          // ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SpaceMaterialButton(
                                              onPress: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FindDistanceByGoogleMap(
                                                        lat: latitude!,
                                                        long: longitude!,
                                                      ),
                                                    ));
                                              },
                                              // width: 100,
                                              height: 40,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  translate(
                                                      context, 'locate_donor')!,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),

                                          SpaceMaterialButton(
                                              onPress: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                AgoraMessaging(
                                                                  userId: bloodDonationProviderValue
                                                                      .donorList[
                                                                          index]
                                                                      .id,
                                                                  userAvatar: bloodDonationProviderValue
                                                                      .donorList[
                                                                          index]
                                                                      .avatar,
                                                                  userFirstName: bloodDonationProviderValue
                                                                      .donorList[
                                                                          index]
                                                                      .firstName,
                                                                  userLastName: bloodDonationProviderValue
                                                                      .donorList[
                                                                          index]
                                                                      .lastName,
                                                                )));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  translate(
                                                      context, 'chat_donor')!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.grey[300]!, width: 0.2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Image(
                                  image: NetworkImage(bloodDonationProviderValue
                                      .donorList[index].avatar!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.35,
                                    child: Text(
                                      "${bloodDonationProviderValue.donorList[index].firstName} ${bloodDonationProviderValue.donorList[index].lastName!}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  if (bloodDonationProviderValue
                                          .donorList[index].address !=
                                      null)
                                    Text(
                                      bloodDonationProviderValue
                                          .donorList[index].address!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[400]!),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    translate(context, 'view_details')!,
                                    style: TextStyle(fontSize: 12),
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget bloodGroupContainer(
    String bloodGroup, bool isSelected, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Provider.of<BloodDonationProvider>(context, listen: false)
          .selectBloodGroup(bloodGroup);
      Provider.of<BloodDonationProvider>(context, listen: false)
          .getDonorsList(context: context, bloodGroup: bloodGroup);
    },
    child: Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.red
            : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          bloodGroup,
          style: TextStyle(
              // color: isSelected ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
      ),
    ),
  );
}
