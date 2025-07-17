import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:link_on/components/GoogleAd/banner_ad.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/blogs_model.dart';
import 'package:html/parser.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:share_plus/share_plus.dart';

class DetailsBlog extends StatefulWidget {
  final BlogsModel? blogdata;
  const DetailsBlog({super.key, this.blogdata});
  @override
  State<DetailsBlog> createState() => _DetailsBlogState();
}

class _DetailsBlogState extends State<DetailsBlog> {
  @override
  Widget build(BuildContext context) {
    final document = parse(widget.blogdata!.content);
    final String parsedString =
        parse(document.body?.text).documentElement?.text ?? '';
    final htmData = parsedString;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.6,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSurface,
            size: 18,
          ),
        ),
        centerTitle: true,
        title: SizedBox(
          height: 20,
          width: 100,
          child: Image(
              image: NetworkImage(
            getStringAsync("appLogo"),
          )),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Share.share(widget.blogdata!.link);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.share,
                  color: Theme.of(context).colorScheme.onSurface, size: 20),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Scrollbar(
          radius: const Radius.circular(50),
          thickness: 5,
          interactive: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.blogdata!.id!,
                    child: Container(
                      height: 180,
                      width: MediaQuery.sizeOf(context).width,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(widget.blogdata!.thumbnail!),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  10.sh,
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red.withOpacity(0.1)),
                    child: Text(
                      widget.blogdata!.category!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  5.sh,
                  Text(
                    widget.blogdata!.title.toString().replaceAll("&#039;", "'"),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  10.sh,
                  Text(
                    widget.blogdata!.createdAt!.timeAgo,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  10.sh,
                  getStringAsync('isAdEnabled') == '1' // enable.disable ads
                      ? Column(
                          children: [
                            BannerAdWidget(
                                adSize: AdSize.banner,
                                adIdr: getStringAsync('adId')),
                            10.sh,
                          ],
                        )
                      : const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ReadMoreText(
                      htmData.toString(),
                      trimLines: 1,
                      trimLength: 800,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      colorClickableText: AppColors.primaryColor,
                      trimCollapsedText: '.......Read more',
                      trimExpandedText: '......show less',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
