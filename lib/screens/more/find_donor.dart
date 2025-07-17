import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';

class FindBloodDonor extends StatefulWidget {
  const FindBloodDonor({super.key});

  @override
  State<FindBloodDonor> createState() => _FindBloodDonorState();
}

class _FindBloodDonorState extends State<FindBloodDonor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xffF4F4F4),
        title: Text(
          translate(context, 'pick_blood_group')!,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                bloodGroupContainer(context, 'A+'),
                bloodGroupContainer(context, 'B+'),
                bloodGroupContainer(context, 'AB+'),
                bloodGroupContainer(context, 'O+'),
              ],
            ),
            const SizedBox(height: 10), // Space between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                bloodGroupContainer(context, 'A-'),
                bloodGroupContainer(context, 'B-'),
                bloodGroupContainer(context, 'AB-'),
                bloodGroupContainer(context, 'O-'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              translate(context, 'available_donors')!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xffFCFCFC),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey[300]!),
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
                          child: const Image(
                            image: NetworkImage(
                                'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Abdul Rauf',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Kahna Nau, Lahore',
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
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            translate(context, 'view_details')!,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget bloodGroupContainer(BuildContext context, String bloodGroup) {
  return Container(
    width: 60,
    height: 60,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xffFCFCFC),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Center(
      child: Text(
        bloodGroup,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
