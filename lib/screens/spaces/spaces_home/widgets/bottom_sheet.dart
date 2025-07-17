// import 'package:date_format/date_format.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:provider/provider.dart';
// import 'package:link_on/components/header_text.dart';
// import 'package:link_on/consts/colors.dart';
// import 'package:link_on/spaces/spaces_provider/spaces_provider.dart';
// import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

// class BottomSheetItems extends StatefulWidget {
//   final String? spaceId;
//   final bool? isSerachScreen;
//   final int? index;
//   const BottomSheetItems(
//       {super.key, this.spaceId, this.index, this.isSerachScreen});

//   @override
//   State<BottomSheetItems> createState() => _BottomSheetItemsState();
// }

// class _BottomSheetItemsState extends State<BottomSheetItems> {
//   List<Map<String, dynamic>> mapData = [
//     {
//       "title": "anyone on clubhouse",
//       "icon": const Icon(CupertinoIcons.person_2_square_stack_fill,
//           color: Colors.black, size: 30)
//     },
//     {
//       "title": "my friends",
//       "icon": const Icon(CupertinoIcons.person_2_fill,
//           color: Colors.black, size: 30)
//     },
//     {
//       "title": "people i choose",
//       "icon":
//           const Icon(CupertinoIcons.lock_fill, color: Colors.black, size: 30)
//     },
//     {
//       "title": "people i send a link",
//       "icon": const Icon(
//         CupertinoIcons.link,
//         size: 30,
//         color: Colors.black,
//       )
//     },
//     {
//       "title": "games",
//       "icon": const Icon(CupertinoIcons.gamecontroller_fill,
//           color: Colors.black, size: 30)
//     },
//     {
//       "title": "Schedule a event",
//       "icon": const Icon(CupertinoIcons.calendar, color: Colors.black, size: 30)
//     },
//   ];

//   List<String> availableTopic = [
//     'Business & Finance',
//     'Music',
//     'Gaming',
//     'News',
//     'Sports',
//     'Politics',
//     'Cryptocurrencies'
//   ];

//   TextEditingController title = TextEditingController();
//   TextEditingController description = TextEditingController();
//   TextEditingController amount = TextEditingController();
//   bool timeshdule = false;
//   String? topicName;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 15,
//             right: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             bottomSheetTopDivider(),
//             20.sh,
//             const HeaderText(
//               text: "Create your space",
//             ),
//             20.sh,
//             Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width: 0.5,
//                     color: AppColors.primaryColor,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextField(
//                   controller: title,
//                   maxLines: 1,
//                   textAlignVertical: TextAlignVertical.top,
//                   textInputAction: TextInputAction.next,
//                   decoration: const InputDecoration(
//                       hintText: "What do you want to talk about ?",
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.only(left: 10)),
//                 )),
//             20.sh,
//             Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width: 0.5,
//                     color: AppColors.primaryColor,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextField(
//                   controller: description,
//                   maxLines: 5,
//                   textAlign: TextAlign.start,
//                   textInputAction: TextInputAction.next,
//                   decoration: const InputDecoration(
//                       hintText: "Enter you description here",
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.only(left: 10, top: 10)),
//                 )),
//             20.sh,
//             Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width: 0.5,
//                     color: AppColors.primaryColor,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextField(
//                   controller: amount,
//                   maxLines: 1,
//                   keyboardType: TextInputType.number,
//                   textInputAction: TextInputAction.next,
//                   decoration: const InputDecoration(
//                       hintText: "Enter amount if its going to be paid",
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.only(left: 10)),
//                 )),
//             20.sh,
//             Row(
//               children: [
//                 10.sw,
//                 OutlinedButton(
//                     style: ButtonStyle(
//                       side: MaterialStateProperty.all(
//                         const BorderSide(color: AppColors.primaryColor),
//                       ),
//                     ),
//                     onPressed: () {
//                       showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               backgroundColor: Colors.white,
//                               title: const Text('Select a topic'),
//                               content: SingleChildScrollView(
//                                 scrollDirection: Axis.vertical,
//                                 child: Wrap(
//                                   direction: Axis.horizontal,
//                                   spacing: 15,
//                                   children: availableTopic.map((tag) {
//                                     return GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           Provider.of<SpaceProvider>(context,
//                                                   listen: false)
//                                               .selectedTopic = tag.toString();

//                                           topicName = tag.toString();
//                                           Provider.of<SpaceProvider>(context,
//                                                   listen: false)
//                                               .isSelectedorNot();
//                                         });
//                                         Navigator.pop(context);
//                                       },
//                                       child: Chip(
//                                         label: Text(tag),
//                                         labelStyle: const TextStyle(
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text(
//                                     'Close',
//                                     style: TextStyle(color: Colors.red),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           });
//                     },
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           Icons.add,
//                           size: 18,
//                           color: AppColors.primaryColor,
//                         ),
//                         5.sw,
//                         const Text(
//                           "Add Topic",
//                           style: TextStyle(color: AppColors.primaryColor),
//                         ),
//                       ],
//                     )),
//                 10.sw,
//                 Provider.of<SpaceProvider>(context, listen: false)
//                             .selectedTopic !=
//                         null
//                     ? Text(Provider.of<SpaceProvider>(context, listen: false)
//                         .selectedTopic
//                         .toString())
//                     : const SizedBox.shrink()
//               ],
//             ),
//             20.sh,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: () async {
//                     if (widget.spaceId != null) {
//                       _editSpace();
//                     } else {
//                       if (title.text.isEmpty) {
//                         toast("Add title of your space");
//                       } else if (description.text.isEmpty) {
//                         toast("Add your description");
//                       } else {
//                         await context.read<SpaceProvider>().createSpace(
//                               context: context,
//                               title: title.text,
//                               description: description.text,
//                             );
//                       }
//                     }
//                   },
//                   child: Container(
//                     height: 40,
//                     width: MediaQuery.sizeOf(context).width * .9,
//                     decoration: BoxDecoration(
//                         color: AppColors.primaryColor,
//                         borderRadius: BorderRadius.circular(20)),
//                     child: const Center(
//                       child: Text(
//                         "Start Your Space ",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             20.sh,
//             const Center(
//               child: Text(
//                 "Get to know Spaces",
//                 style: TextStyle(color: Colors.blue),
//               ),
//             ),
//             30.sh,
//           ],
//         ));
//   }

//   String? _hour, _minute, _time;
//   String? dateTime;
//   DateTime selectedDate = DateTime.now();
//   DateTime endselectedDate = DateTime.now();
//   TimeOfDay endselectedTime = const TimeOfDay(hour: 00, minute: 00);
//   TimeOfDay startselectedTime = const TimeOfDay(hour: 00, minute: 00);
//   final TextEditingController timeController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();

//   Future selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//         context: context,
//         initialTime: endselectedTime,
//         builder: (context, child) {
//           return Theme(
//               data: Theme.of(context).copyWith(
//                 colorScheme: const ColorScheme.light(
//                   primary: Colors.green,
//                 ),
//               ),
//               child: child!);
//         });
//     if (picked != null) {
//       setState(() {
//         endselectedTime = picked;
//         _hour = endselectedTime.hour.toString();
//         _minute = endselectedTime.minute.toString();
//         _time = '${_hour!} : ${_minute!}';
//         timeController.text = _time!;
//         timeController.text = formatDate(
//             DateTime(2019, 08, 1, endselectedTime.hour, endselectedTime.minute),
//             [hh, ':', nn, " ", am]).toString();
//       });
//     }
//   }

//   Future selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         initialDatePickerMode: DatePickerMode.day,
//         firstDate: DateTime(2015),
//         lastDate: DateTime(2025),
//         builder: (context, child) {
//           return Theme(
//               data: Theme.of(context).copyWith(
//                 colorScheme: const ColorScheme.light(
//                   primary: Colors.green,
//                 ),
//               ),
//               child: child!);
//         });

//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//         dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//         print(dateController.text);
//       });
//     }
//   }

//   void _editSpace() async {
//     if (title.text.isNotEmpty || description.text.isNotEmpty) {
//       await context.read<SpaceProvider>().editSpace(
//           context: context,
//           spaceId: widget.spaceId,
//           spaceTitle: title.text,
//           description: description.text,
//           index: widget.index,
//           isSearchScreen: widget.isSerachScreen);
//     } else {
//       toast("Add title/description to edit");
//     }
//   }
// }
