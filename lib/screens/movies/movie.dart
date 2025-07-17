import 'package:flutter/material.dart';
import 'package:link_on/controllers/moviesProvider/movie_provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/movies/all_movies.dart';
import 'package:link_on/screens/movies/movie_categories.dart';
import 'package:link_on/screens/movies/movie_detail.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class MoviesList extends StatefulWidget {
  const MoviesList({super.key});

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  @override
  void initState() {
    super.initState();
    Provider.of<MoviesProvider>(context, listen: false).getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 1.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          title: Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(getStringAsync("appLogo")))),
          ),
        ),
        body: Consumer<MoviesProvider>(
          builder: (context, value, child) => value.checkData == true &&
                  value.moviesdata.isNotEmpty
              ? SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.4,
                              width: MediaQuery.sizeOf(context).width,
                              child: PageView.builder(
                                itemCount: (value.moviesdata.length / 2).ceil(),
                                controller: PageController(
                                    initialPage: value.currentIndex),
                                onPageChanged: (index) {
                                  value.changeIndex(index);
                                },
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetail(
                                            moviesdata:
                                                value.moviesdata[index]),
                                      ),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                            image: NetworkImage(value
                                                .moviesdata[index].coverPic!),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.25,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black,
                                                  Colors.black54,
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            bottom: 50,
                                            child: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              child: Text(
                                                '${value.moviesdata[index].movieName}',
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 10,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  (value.moviesdata.length / 2).ceil(),
                                  (index) {
                                return Container(
                                  width: value.currentIndex == index ? 16 : 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: value.currentIndex == index
                                        ? Colors.white
                                        : Colors.white70,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                translate(context, 'category').toString(),
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MoviesCategories(
                                        moviesdata: value.moviesdata),
                                  ),
                                ),
                                child: Text(
                                  translate(context, 'see_all').toString(),
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (value.moviesdata.length / 2).ceil(),
                            itemBuilder: (context, index) => GestureDetector(
                                onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetail(
                                            moviesdata:
                                                value.moviesdata[index]),
                                      ),
                                    ),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 90,
                                      width: 135,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        image: DecorationImage(
                                            image: NetworkImage(value
                                                .moviesdata[index].coverPic!),
                                            fit: BoxFit.cover),
                                      ),
                                      child: SizedBox(
                                        width: 110,
                                        child: Center(
                                          child: Text(
                                            translate(context, 'adventure')
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                translate(context, 'movies').toString(),
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AllMovies(moviesdata: value.moviesdata),
                                  ),
                                ),
                                child: Text(
                                  translate(context, 'see_all').toString(),
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: (value.moviesdata.length / 2).ceil(),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => GestureDetector(
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetail(
                                          moviesdata: value.moviesdata[index]),
                                    ),
                                  ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 80,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(value
                                                .moviesdata[index].coverPic!),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.7,
                                          child: Text(
                                            value.moviesdata[index].movieName
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          value.moviesdata[index].genre
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          value.moviesdata[index].releaseYear
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              : value.checkData == true && value.moviesdata.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading(),
                        Center(
                            child: Text(
                          translate(context, 'no_movies_found').toString(),
                          style: TextStyle(fontSize: 16),
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
        ));
  }
}
