import 'package:flutter/material.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/screens/NearbyFriends/nearby_friends_provider.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';

class NearbyFriends extends StatefulWidget {
  const NearbyFriends({super.key});

  @override
  State<NearbyFriends> createState() => _NearbyFriendsState();
}

class _NearbyFriendsState extends State<NearbyFriends> {
  @override
  void initState() {
    Provider.of<NearByProvider>(context, listen: false).nearbyFriends.clear();
    Future.delayed(const Duration(milliseconds: 200), () {
      showModalBottomSheet(
        isDismissible: true, // Set to true to allow dismissing on tap outside
        backgroundColor: Theme.of(context).colorScheme.secondary,
        enableDrag: true,
        showDragHandle: true,
        context: context,
        builder: (context) {
          return const FilterSheet();
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            translate(context, AppString.nearby_friends).toString(),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  isDismissible:
                      true, // Set to true to allow dismissing on tap outside
                  enableDrag: true,
                  showDragHandle: true,
                  context: context,
                  builder: (context) {
                    return const FilterSheet();
                  },
                );
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Consumer<NearByProvider>(
          builder: (context, value, child) {
            return value.isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : value.isLoading == false && value.nearbyFriends.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loading(),
                            Text(
                                translate(context, 'no_data_found').toString()),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.nearbyFriends.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              height: 140,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileTab(
                                        userId: value.nearbyFriends[index].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: double.infinity,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                value
                                                    .nearbyFriends[index].avatar
                                                    .toString(),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              value
                                                  .nearbyFriends[index].lastName
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 22,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (!value.nearbyFriends[index].city
                                                .isEmptyOrNull)
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Location:',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      value.nearbyFriends[index]
                                                          .city
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (!value.nearbyFriends[index]
                                                .gender.isEmptyOrNull)
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Gender:',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    value.nearbyFriends[index]
                                                        .gender
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Relationship:',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  value.nearbyFriends[index]
                                                      .relationId
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (value.nearbyFriends[index]
                                                    .activeStatus !=
                                                '0')
                                              Row(
                                                children: [
                                                  const Text(
                                                    'status:',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    value.nearbyFriends[index]
                                                                .onlineStatus ==
                                                            "1"
                                                        ? 'Online'
                                                        : 'Offline',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
          },
        ));
  }
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  var selectedRange = const RangeValues(0.0, 5.0);
  late NearByProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<NearByProvider>(context, listen: false);
    provider.selectedDistance = selectedRange.end.toStringAsFixed(1);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 7),
              _buildFilterSection(
                  translate(context, AppString.gender).toString(), 'gender'),
              const SizedBox(height: 7),
              _buildRangeSlider(),
              const SizedBox(height: 7),
              _buildFilterSection(
                  translate(context, AppString.relationship).toString(),
                  'relationship'),
              const SizedBox(height: 7),
              _buildFilterSection(
                  translate(context, AppString.status).toString(), 'status'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          translate(context, AppString.filter_details).toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: AppColors.primaryColor,
          onPressed: () {
            _logSelectedValues();
            provider.getNearbyFriends(
              distance: provider.selectedDistance,
              relationship: provider.selectedValues['relationship'],
              gender: provider.selectedValues['gender'],
              status: provider.selectedValues['status'],
            );
            Navigator.pop(context);
          },
          child: Text(
            translate(context, AppString.submit).toString(),
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _buildFilterSection(String title, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 7),
        _buildChipsRow(type),
      ],
    );
  }

  Widget _buildChipsRow(String type) {
    final labels = {
      'gender': [
        translate(context, AppString.all).toString(),
        translate(context, AppString.male).toString(),
        translate(context, AppString.female).toString(),
      ],
      'relationship': [
        translate(context, AppString.single).toString(),
        translate(context, AppString.married).toString(),
        translate(context, AppString.engaged).toString(),
      ],
      'status': [
        translate(context, AppString.both).toString(),
        translate(context, AppString.online).toString(),
        translate(context, AppString.offline).toString(),
      ],
    };

    return Row(
      children: labels[type]!.map((label) => _buildChip(label, type)).toList(),
    );
  }

  Widget _buildChip(String label, String type) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _updateSelectedValue(label, type),
          child: Chip(
            backgroundColor: provider.selectedValues[type] == label
                ? AppColors.primaryColor
                : Colors.white,
            deleteIcon: const Icon(Icons.male),
            label: Text(
              label,
              style: TextStyle(
                color: provider.selectedValues[type] == label
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            side: BorderSide(
              color: provider.selectedValues[type] == label
                  ? AppColors.primaryColor
                  : Colors.black,
              width: 0.1,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }

  Widget _buildRangeSlider() {
    return Row(
      children: [
        Expanded(
          child: Slider(
            activeColor: AppColors.primaryColor,
            value: selectedRange.end,
            min: 1.0,
            max: 5.0,
            divisions: 50,
            onChanged: (double newValue) {
              setState(() {
                selectedRange = RangeValues(newValue, newValue);
                provider.selectedDistance = newValue.toStringAsFixed(1);
              });
            },
          ),
        ),
        Text('${selectedRange.end.toStringAsFixed(0)} km'),
      ],
    );
  }

  void _updateSelectedValue(String label, String type) {
    setState(() {
      provider.selectedValues[type] = label;
    });
  }

  void _logSelectedValues() {
    log("SelectedDistance......${provider.selectedDistance}");
    log("SelectedGender......${provider.selectedValues['gender']}");
    log("SelectedRelation......${provider.selectedValues['relationship']}");
    log("SelectedStatus.......${provider.selectedValues['status']}");
  }
}
