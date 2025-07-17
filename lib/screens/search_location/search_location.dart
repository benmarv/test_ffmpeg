import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/search_location/location_tile.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(context, 'post_current_location')!),
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  onChanged: (val) {},
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: translate(context, 'search_location_hint')!,
                    prefixIcon: const Icon(Icons.location_pin),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.2,
              height: 1,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.my_location_sharp),
            label: Text(translate(context, 'use_current_location')!),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.2,
              height: 1,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          LocationTile(
            press: () {},
            title: translate(context, 'dhaka_bangladesh')!,
          ),
        ],
      ),
    );
  }
}
