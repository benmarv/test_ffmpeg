import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/blogsProvider/blog_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/screens/Blog/blog_details.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key});

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  int calculateReadingTime(String text, {int wordsPerMinute = 200}) {
    List<String> words = text.split(RegExp(r'\s+'));
    int wordCount = words.length;
    double readingTime = wordCount / wordsPerMinute;
    return readingTime.ceil();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<BlogsProvider>(context, listen: false)
        .getBlogs(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Consumer<BlogsProvider>(
        builder: (context, value, child) => value.checkData == false &&
                value.data.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            style: IconButton.styleFrom(
                              elevation: 5,
                            ),
                            icon: const Icon(
                              Icons.arrow_back,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Row(
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
                              //   translate(context, 'blogs').toString(),
                              //   style: const TextStyle(
                              //     fontStyle: FontStyle.italic,
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w400,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.25,
                          width: MediaQuery.sizeOf(context).width,
                          child: PageView.builder(
                            itemCount: value.data.length >= 5
                                ? (value.data.length / 2).ceil()
                                : value.data.length,
                            controller: PageController(
                              initialPage: value.currentIndex,
                            ),
                            onPageChanged: (index) {
                              value.changeIndex(index);
                            },
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsBlog(
                                      blogdata: value.data[index],
                                    ),
                                  ),
                                ),
                                child: Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  alignment: Alignment.bottomLeft,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        value.data[index].thumbnail!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Text(
                                    '${value.data[index].title}',
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        value.data.length >= 4
                            ? (value.data.length / 2).ceil()
                            : value.data.length,
                        (index) {
                          return Container(
                            width: value.currentIndex == index ? 16 : 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 2.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: value.currentIndex == index
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        translate(context, 'latest_blogs').toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.data.length,
                        itemBuilder: (context, index) {
                          final document = parse(value.data[index].content);
                          final readingTime =
                              calculateReadingTime(value.data[index].content!);

                          final String parsedString = parse(document.body?.text)
                                  .documentElement
                                  ?.text ??
                              '';
                          final htmData = parsedString;
                          return Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsBlog(
                                      blogdata: value.data[index],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Hero(
                                        tag: value.data[index].id!,
                                        child: Container(
                                          height: 110,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  .27,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: NetworkImage(value
                                                  .data[index].thumbnail
                                                  .toString()),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 2),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.red
                                                    .withOpacity(0.1)),
                                            child: Text(
                                              value.data[index].category!,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                .6,
                                            child: Text(
                                              value.data[index].title
                                                  .toString()
                                                  .replaceAll("&#039;", "'"),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          3.sh,
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                .6,
                                            child: Text(
                                              htmData
                                                  .toString()
                                                  .replaceAll("&#039;", "'"),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          3.sh,
                                          Row(
                                            children: [
                                              Text(
                                                value.data[index].createdAt!
                                                    .timeAgo,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              // const SizedBox(
                                              //   width: 10,
                                              // ),
                                              // Text(
                                              //     '${readingTime.toInt()} ${translate(context, 'min').toString()}')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              )
            : value.checkData == false && value.data.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loading(),
                      Center(
                          child: Text(
                        translate(context, 'no_blogs_found').toString(),
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 16),
                      )),
                      const SizedBox(
                        height: 2,
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                          elevation: 5,
                        ),
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
      ),
    ));
  }
}
