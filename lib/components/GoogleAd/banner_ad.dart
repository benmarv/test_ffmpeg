import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

class BannerAdWidget extends StatefulWidget {
  final String adIdr;
  final AdSize adSize;
  const BannerAdWidget({super.key, required this.adIdr, required this.adSize});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd bannerAd;
  initBannerAd() {
    bannerAd = BannerAd(
        size: widget.adSize,
        // adUnitId: widget.adIdr,
        adUnitId: 'ca-app-pub-3355640798916544/7371479478',
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            log('On Ad loaded : ${ad.adUnitId} ${ad.responseInfo}');
          },
          onAdFailedToLoad: (ad, error) {
            log('On Ad failed : ${error.message}');
            ad.dispose();
          },
        ),
        request: const AdRequest());
    bannerAd.load();
  }

  @override
  void initState() {
    initBannerAd();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
    bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bannerAd.size.height.toDouble() + 20,
      width: MediaQuery.sizeOf(context).width,
      child: AdWidget(ad: bannerAd),
    );
  }
}
