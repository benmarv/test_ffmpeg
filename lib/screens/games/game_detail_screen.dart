// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:link_on/components/GoogleAd/banner_ad.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/games.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:link_on/localization/localization_constant.dart';

class GameDetailScreen extends StatelessWidget {
  GameDetailScreen({super.key, required this.gameData});
  Games gameData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Play',
          backgroundColor: Colors.red,
          onPressed: () {
            final Uri url = Uri.parse(gameData.link!);
            launchUrl(url);
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
                  height: MediaQuery.sizeOf(context).height * 0.45,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    image: DecorationImage(
                        image: NetworkImage(gameData.image!),
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
                      const Column(),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(gameData.image!),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${gameData.name}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '${4.6}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.play_arrow,
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '126',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        translate(context, 'description')!,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${gameData.description}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      getStringAsync('isAdEnabled') == '1' // enable/disable ads
                          ? BannerAdWidget(
                              adSize: AdSize.banner,
                              adIdr: getStringAsync('adId'),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
