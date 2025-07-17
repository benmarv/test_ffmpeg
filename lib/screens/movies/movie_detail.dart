// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:link_on/components/GoogleAd/banner_ad.dart';
import 'package:link_on/models/movies.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/screens/movies/movie_play.dart';
import 'package:link_on/localization/localization_constant.dart';

class MovieDetail extends StatelessWidget {
  Movies moviesdata;
  MovieDetail({super.key, required this.moviesdata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          tooltip: translate(context, 'play').toString(), // Corrected Key
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoviePlay(
                  url: moviesdata.video,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.55,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    image: DecorationImage(
                        image: NetworkImage(moviesdata.coverPic!),
                        fit: BoxFit.cover),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 1, offset: Offset(0.3, 0.3))
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.25,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              '${moviesdata.movieName}',
                              maxLines: 2,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ),
                          Text(
                            '${moviesdata.releaseYear} ● ${moviesdata.genre} ● ${moviesdata.duration} ' +
                                translate(context, 'hour')
                                    .toString(), // Corrected Key
                            style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                              (index) => Icon(
                                index < int.tryParse(moviesdata.rating!)!
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        translate(context, 'plot_summary')
                            .toString(), // Corrected Key
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${moviesdata.description}',
                        style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      getStringAsync('isAdEnabled') == '1' // enable/disable ads
                          ? BannerAdWidget(
                              adSize: AdSize.banner,
                              adIdr: getStringAsync('adId'))
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
