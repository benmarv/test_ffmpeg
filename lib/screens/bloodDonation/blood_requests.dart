import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';

import 'package:link_on/screens/bloodDonation/add_blood_request.dart';
import 'package:link_on/screens/bloodDonation/blood_donation_provider.dart';
import 'package:link_on/screens/bloodDonation/find_distance_googlemap.dart';
import 'package:link_on/screens/message_details.dart/messaging_with_agora.dart';
import 'package:link_on/screens/spaces/spaces_home/widgets/space_material_button.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class BloodRequests extends StatefulWidget {
  const BloodRequests({super.key});

  @override
  State<BloodRequests> createState() => _BloodRequestsState();
}

class _BloodRequestsState extends State<BloodRequests> {
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
          .getBloodRequestsList(
              context: context, bloodGroup: '', urgentNeed: '0');
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

  bool isAvailableForDonation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(context, 'blood_requests')!),
        centerTitle: true,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddBloodRequest(),
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
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: AssetImage('assets/images/request.PNG'),
                          fit: BoxFit.contain)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    bloodGroupContainer(
                      'A+',
                      vloodDonationProviderValue.selectedBloodGroup == 'A+',
                      isAvailableForDonation,
                      context,
                    ),
                    bloodGroupContainer(
                        'B+',
                        vloodDonationProviderValue.selectedBloodGroup == 'B+',
                        isAvailableForDonation,
                        context),
                    bloodGroupContainer(
                        'AB+',
                        vloodDonationProviderValue.selectedBloodGroup == 'AB+',
                        isAvailableForDonation,
                        context),
                    bloodGroupContainer(
                        'O+',
                        vloodDonationProviderValue.selectedBloodGroup == 'O+',
                        isAvailableForDonation,
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
                        isAvailableForDonation,
                        context),
                    bloodGroupContainer(
                        'B-',
                        vloodDonationProviderValue.selectedBloodGroup == 'B-',
                        isAvailableForDonation,
                        context),
                    bloodGroupContainer(
                        'AB-',
                        vloodDonationProviderValue.selectedBloodGroup == 'AB-',
                        isAvailableForDonation,
                        context),
                    bloodGroupContainer(
                        'O-',
                        vloodDonationProviderValue.selectedBloodGroup == 'O-',
                        isAvailableForDonation,
                        context),
                  ],
                ),
                const SizedBox(height: 10),

                SwitchListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  value: isAvailableForDonation,
                  onChanged: (value) {
                    setState(() {
                      isAvailableForDonation = value;
                      Provider.of<BloodDonationProvider>(context, listen: false)
                          .getBloodRequestsList(
                              context: context,
                              bloodGroup: '',
                              urgentNeed: value ? '1' : '0');
                    });
                  },
                  title: Text(
                    translate(context, 'urgently_needed')!,
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    translate(context, 'blood_requests')!,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<BloodDonationProvider>(
                  builder: (context, bloodDonationProviderValue, child) =>
                      ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        bloodDonationProviderValue.bloodRequestList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            isDismissible: true,
                            isScrollControlled: true,
                            context: context,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            builder: (context) {
                              getAddressCoordinates(bloodDonationProviderValue
                                  .bloodRequestList[index].location!);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            bloodDonationProviderValue
                                                .bloodRequestList[index]
                                                .user!
                                                .avatar!,
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
                                          "${bloodDonationProviderValue.bloodRequestList[index].user!.firstName} ${bloodDonationProviderValue.bloodRequestList[index].user!.lastName}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${bloodDonationProviderValue.bloodRequestList[index].phone}",
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
                                          "${bloodDonationProviderValue.bloodRequestList[index].user!.email}",
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
                                          "${bloodDonationProviderValue.bloodRequestList[index].bloodGroup}",
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (bloodDonationProviderValue
                                                .bloodRequestList[index]
                                                .user!
                                                .id !=
                                            getStringAsync('user_id')) ...[
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
                                              width: 100,
                                              height: 40,
                                              child: Text(
                                                translate(
                                                    context, 'view_on_maps')!,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SpaceMaterialButton(
                                            onPress: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AgoraMessaging(
                                                    userId:
                                                        bloodDonationProviderValue
                                                            .bloodRequestList[
                                                                index]
                                                            .user!
                                                            .id,
                                                    userAvatar:
                                                        bloodDonationProviderValue
                                                            .bloodRequestList[
                                                                index]
                                                            .user!
                                                            .avatar,
                                                    userFirstName:
                                                        bloodDonationProviderValue
                                                            .bloodRequestList[
                                                                index]
                                                            .user!
                                                            .firstName,
                                                    userLastName:
                                                        bloodDonationProviderValue
                                                            .bloodRequestList[
                                                                index]
                                                            .user!
                                                            .lastName,
                                                  ),
                                                ),
                                              );
                                            },
                                            width: 60,
                                            child: Text(
                                              translate(context, 'message')!,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                        if (bloodDonationProviderValue
                                                .bloodRequestList[index]
                                                .userId ==
                                            getStringAsync('user_id'))
                                          SpaceMaterialButton(
                                            width: 40,
                                            onPress: () {
                                              bloodDonationProviderValue
                                                  .deleteBloodRequest(
                                                      bloodRequestId:
                                                          bloodDonationProviderValue
                                                              .bloodRequestList[
                                                                  index]
                                                              .id!,
                                                      context: context);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              translate(context, 'delete')!,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
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
                                      .bloodRequestList[index].user!.avatar!),
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
                                      "${bloodDonationProviderValue.bloodRequestList[index].user!.firstName} ${bloodDonationProviderValue.bloodRequestList[index].user!.lastName!}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.45,
                                    child: Text(
                                      bloodDonationProviderValue
                                          .bloodRequestList[index].location!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[400]!,
                                      ),
                                    ),
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
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  translate(context, 'view_details')!,
                                  style: TextStyle(fontSize: 12),
                                ),
                              )
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

Widget bloodGroupContainer(String bloodGroup, bool isSelected,
    bool isAvailableForDonation, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Provider.of<BloodDonationProvider>(context, listen: false)
          .selectBloodGroup(bloodGroup);
      Provider.of<BloodDonationProvider>(context, listen: false)
          .getBloodRequestsList(
        context: context,
        bloodGroup: bloodGroup,
        urgentNeed: isAvailableForDonation ? '1' : '0',
      );
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
    ),
  );
}
