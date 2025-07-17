import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/spaces_model/spaces_model.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/spaces/spaces_home/create_space.dart';
import 'package:link_on/screens/spaces/spaces_home/main_space.dart';
import 'package:link_on/screens/spaces/spaces_home/widgets/show_confirmation_dialogue.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/spaces_widgets/custom_room_tiles.dart';
import 'package:link_on/screens/spaces/spaces_provider/spaces_provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class SpacesHome extends StatefulWidget {
  const SpacesHome({super.key});

  @override
  State<SpacesHome> createState() => _SpacesHomeState();
}

class _SpacesHomeState extends State<SpacesHome> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final spaceProvider = context.read<SpaceProvider>();
    spaceProvider.makeSpacesListEmpty();
    spaceProvider.getAllSpaces();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        spaceProvider.getAllSpaces(
          offset: spaceProvider.spacesList.length,
        );
      }
    });
    super.initState();
  }

  void joinSpace({
    required Member hostData,
    required SpaceModel space,
  }) {
    Provider.of<SpaceProvider>(context, listen: false)
        .joinSpace(context: context, spaceId: space.id!)
        .then(
      (value) {
        log('Join Space Response ${value.toString()}');
        if (value['code'] == '200') {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MainSpaceScreen(
                hostData: hostData,
                isAudience: true,
                spaceData: space,
                channel: hostData.firstName! +
                    hostData.userId!, // Ensure these are not null
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(
                milliseconds: 500,
              ), // Adjust the duration as needed
            ),
          );
        } else {
          toast(value['message']);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: [
            SizedBox(
              height: 20,
              width: 100,
              child: Image(
                  image: NetworkImage(
                getStringAsync("appLogo"),
              )),
            ),
            // Text(
            //   translate(context, 'spaces').toString(),
            //   style: const TextStyle(
            //     fontStyle: FontStyle.italic,
            //     fontSize: 14,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateSpaceScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(context, 'live_spaces').toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      translate(context, 'spaces_going_on').toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                10.sh,
                Consumer<SpaceProvider>(
                  builder: (context, value, child) {
                    return (value.loading == true &&
                            value.getSpaceslist.isEmpty)
                        ? AspectRatio(
                            aspectRatio: 0.6,
                            child: Loader(),
                          )
                        : (value.loading == false &&
                                value.getSpaceslist.isEmpty)
                            ? AspectRatio(
                                aspectRatio: 0.65,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    loading(),
                                    Text(translate(context, 'no_spaces')
                                        .toString()),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) => 10.sh,
                                shrinkWrap: true,
                                itemCount: value.getSpaceslist.length,
                                itemBuilder: (context, index) {
                                  Member hostData =
                                      value.getSpaceslist[index].member;
                                  SpaceModel space = value.getSpaceslist[index];
                                  return GestureDetector(
                                    onTap: () {
                                      space.amount != '0'
                                          ? showConfirmationDialog(
                                              context: context,
                                              title: translate(
                                                      context, 'confirm_join')
                                                  .toString()
                                                  .replaceFirst(
                                                      "/", space.amount),
                                              yesText:
                                                  translate(context, 'join')
                                                      .toString(),
                                              noText:
                                                  translate(context, 'cancel')
                                                      .toString(),
                                              onYes: () {
                                                Navigator.pop(context);
                                                joinSpace(
                                                  space: space,
                                                  hostData: hostData,
                                                );
                                              },
                                              onNo: () =>
                                                  Navigator.pop(context),
                                            )
                                          : joinSpace(
                                              space: space,
                                              hostData: hostData,
                                            );
                                    },
                                    child: CustomRoomTiles(
                                      hostData: hostData,
                                      spacesData: space,
                                      index: index,
                                    ),
                                  );
                                },
                              );
                  },
                ),
                20.sh,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
