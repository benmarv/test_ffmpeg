import 'package:flutter/material.dart';
import 'package:link_on/controllers/gamesProvider/game_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/games/game_detail_screen.dart';
import 'package:provider/provider.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});
  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false).getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
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
            //   translate(context, 'games').toString(),
            //   style: const TextStyle(
            //     fontStyle: FontStyle.italic,
            //     fontSize: 14,
            //     fontWeight: FontWeight.w400,
            //   ),
            // )
          ],
        ),
      ),
      body: Consumer<GamesProvider>(
        builder: (context, value, child) => value.checkData == true &&
                value.data.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            translate(context, 'featured_games').toString(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))),
                    SizedBox(
                        height: 150,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: value.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GameDetailScreen(
                                                  gameData: value.data[index]),
                                        ));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          height: 140,
                                          width: 90,
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      value.data[index].image!),
                                                  fit: BoxFit.cover)),
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8, left: 5, right: 5),
                                              child: Text(
                                                value.data[index].name
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )))));
                            })),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(translate(context, 'all_games').toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ))),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: value.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GameDetailScreen(
                                          gameData: value.data[index],
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.5),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  value.data[index].image!),
                                              fit: BoxFit.cover),
                                        )),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  .58,
                                          child: Text(
                                            value.data[index].name.toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  .58,
                                          child: Text(
                                            "${value.data[index].description}",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            : value.checkData == true && value.data.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loading(),
                      Center(
                          child: Text(
                        translate(context, 'no_games_found').toString(),
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 16),
                      )),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
      ),
    );
  }
}
