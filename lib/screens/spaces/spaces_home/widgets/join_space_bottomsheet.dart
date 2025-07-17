// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:link_on/consts/colors.dart';
// import 'package:link_on/models/spaces_model/spaces_model.dart';
// import 'package:link_on/spaces/spaces_home/widgets/user_profile.dart';
// import 'package:link_on/spaces/spaces_provider/spaces_provider.dart';
// import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
// import 'package:link_on/utils/utils.dart';


// class JoinSpaceBottomSheet extends StatefulWidget {
//   final SpaceModel? spaceData;
//   const JoinSpaceBottomSheet({super.key, this.spaceData});

//   @override
//   State<JoinSpaceBottomSheet> createState() => _JoinSpaceBottomSheetState();
// }

// class _JoinSpaceBottomSheetState extends State<JoinSpaceBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.sizeOf(context).height * .7,
//       child: Padding(
//         padding:
//             const EdgeInsets.only(top: 10.0, bottom: 10, left: 5, right: 5),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             bottomSheetTopDivider(color: AppColors.primaryColor),
//             20.sh,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 14.0),
//                   child: SizedBox(
//                     width: MediaQuery.sizeOf(context).width * .7,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.spaceData!.title.toString(),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 2,
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w900,
//                             color: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge!
//                                 .color!
//                                 .withOpacity(0.7),
//                           ),
//                         ),
//                         6.sh,
//                         Text(
//                           widget.spaceData!.description.toString(),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w900,
//                               color: Theme.of(context)
//                                   .textTheme
//                                   .bodyMedium!
//                                   .color!
//                                   .withOpacity(0.8)),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Utils.live(70.0),
//               ],
//             ),
//             SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Wrap(
//                     spacing: MediaQuery.sizeOf(context).width * .05,
//                     direction: Axis.horizontal,
//                     alignment: WrapAlignment.center,
//                     crossAxisAlignment: WrapCrossAlignment.center,
//                     children: [
//                       for (int index = 0;
//                           index < widget.spaceData!.member.length;
//                           index++)
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                             showModelBottomSheet(
//                               isScroll: true,
//                               colors: Colors.white,
//                               context: context,
//                               widget: UserProfile(
//                                 id: widget.spaceData!.member[index].userId,
//                               ),
//                             );
//                             // final Uri _url = Uri.parse(data[index].link!);
//                             // launchUrl(_url);
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.all(
//                                 MediaQuery.sizeOf(context).width * .01),
//                             child: SizedBox(
//                               height: 130,
//                               width: MediaQuery.sizeOf(context).width * .8,
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 75,
//                                     width:
//                                         MediaQuery.sizeOf(context).width * .15,
//                                     decoration: BoxDecoration(
//                                         color: Colors.blueGrey,
//                                         shape: BoxShape.circle,
//                                         image: DecorationImage(
//                                             image: NetworkImage(widget
//                                                 .spaceData!
//                                                 .member[index]
//                                                 .avatar!))),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(3.0),
//                                     child: Text(
//                                       ("${widget.spaceData!.member[index].firstName}") +
//                                           (" ${widget.spaceData!.member[index].lastName}"),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       textAlign: TextAlign.center,
//                                       style: const TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ),
//                                   widget.spaceData!.member[index].isHost == "1"
//                                       ? const Padding(
//                                           padding: EdgeInsets.all(3.0),
//                                           child: Text(
//                                             "Host",
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                         )
//                                       : widget.spaceData!.member[index]
//                                                   .isCohost ==
//                                               "1"
//                                           ? const Padding(
//                                               padding: EdgeInsets.all(3.0),
//                                               child: Text(
//                                                 "Co-Host",
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 13,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ),
//                                             )
//                                           : const Padding(
//                                               padding: EdgeInsets.all(3.0),
//                                               child: Text(
//                                                 "Listening",
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 13,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ),
//                                             ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             15.sh,
//             Center(
//               child: InkWell(
//                 onTap: () async {
//                   await context.read<SpaceProvider>().spaceJoinMember(
//                       context: context,
//                       spaceId: widget.spaceData?.id,
//                       spaceModel: widget.spaceData);
//                 },
//                 child: Container(
//                   height: 40,
//                   width: MediaQuery.sizeOf(context).width * .7,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "Start listening",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             15.sh,
//           ],
//         ),
//       ),
//     );
//   }
// }
