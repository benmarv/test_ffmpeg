// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:lecle_flutter_link_preview/lecle_flutter_link_preview.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/postProvider/postdetail_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart' as post;
import 'package:link_on/screens/youtbe_preview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PostContent extends StatefulWidget {
  final String? data;

  final post.Posts? postData;
  final int maxLines;
  const PostContent({
    super.key,
    this.data,
    this.postData,
    this.maxLines = 4,
  });

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  String translateText = "";
  bool isShowingTranslation = false;
  String currentLanguage = "";

  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  TextPainter textPainter = TextPainter();
  final FontWeight _fontWeight = FontWeight.w400;
  final double _fontSize = 14.0;

  @override
  void initState() {
    currentLanguage = getStringAsync("current_language_code");
    log(currentLanguage);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getNumberOfLines(widget.data!, context);
      },
    );
  }

  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    final buffer = StringBuffer();

    void extractText(html_dom.Node node) {
      if (node is html_dom.Text) {
        buffer.write(node.text);
      } else if (node is html_dom.Element) {
        for (final childNode in node.nodes) {
          extractText(childNode);
        }
      }
    }

    for (final node in document.body!.nodes) {
      extractText(node);
    }

    return buffer.toString();
  }

  int getNumberOfLines(String text, BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: _fontWeight,
        ),
      ),
      textDirection: Directionality.of(context),
      maxLines: 4,
    );
    textPainter.layout(maxWidth: MediaQuery.sizeOf(context).width);
    return textPainter.computeLineMetrics().length;
  }

  Decoration? getDecorationByClassName(String? className) {
    for (var color in Provider.of<PostProvider>(context, listen: false)
        .availableDarkModeColors) {
      if (color.className == className) {
        return color.decoration;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String originalText = parseHtmlString(widget.data!);
    final postProvider =
        Provider.of<PostDetailProvider>(context, listen: false);
    return Container(
      alignment: isRTL(originalText.toString())
          ? Alignment.centerRight
          : Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(
        Platform.isIOS ? 20 : 10,
        0,
        Platform.isIOS ? 20 : 10,
        10,
      ),
      decoration: (widget.postData?.audio == null &&
              widget.postData?.images == null &&
              widget.postData?.video == null &&
              widget.postData?.bgColor != null)
          ? getDecorationByClassName(widget.postData?.bgColor)
          : null,
      child: (widget.postData?.audio == null &&
              widget.postData?.images == null &&
              widget.postData?.video == null &&
              widget.postData?.bgColor != null)
          ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: DetectableText(
                  text: originalText,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  detectionRegExp: RegExp(
                    r'(#[a-zA-Z0-9_]+)|https?://[^\s]+|(?<=\s|^)@[a-zA-Z0-9_]+',
                    multiLine: true,
                  ),
                  trimLength: 500,
                  trimExpandedText:
                      '...' + translate(context, 'show_less').toString(),
                  trimCollapsedText: translate(context, 'read_more').toString(),
                  detectedStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                  basicStyle: TextStyle(
                      fontSize: 18,
                      color: widget.postData?.bgColor == '_23jo'
                          ? Colors.black
                          : Colors.white),
                  onTap: (tappedText) {
                    if (tappedText.startsWith("@")) {
                    } else if (tappedText.startsWith("#")) {
                    } else if (tappedText.startsWith("http")) {}
                  },
                ),
              ),
            )
          : ExpandableNotifier(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (originalText.contains(
                    RegExp(r'https?://[^\s]+'),
                  ))
                    GestureDetector(
                      onTap: () {
                        final Uri url = Uri.parse(originalText);
                        launchUrl(url);
                      },
                      child: FlutterLinkPreview(
                        url: originalText,
                        builder: (info) {
                          if (originalText.contains("youtube.com") ||
                              originalText.contains(
                                "youtu.be",
                              )) {
                            final infoo = info as WebInfo;
                            return Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.25,
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.95,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    ),
                                  ),
                                  child: YouTubeLinkPreview(
                                    url: originalText,
                                  ),
                                ),
                                Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.95,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 6,
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: info.title,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (info.description != null)
                                            TextSpan(
                                              text: '\n${info.description!}',
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    )),
                              ],
                            );
                          } else if (info is WebInfo) {
                            return SizedBox(
                              height: 120,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (info.image != null) ...[
                                      SizedBox(
                                          width: 100,
                                          height: 120,
                                          child: Image.network(
                                            info.image!,
                                            width: double.maxFinite,
                                            fit: BoxFit.cover,
                                          )),
                                    ] else ...[
                                      SizedBox(
                                        width: 100,
                                        height: 120,
                                        child: Image.network(
                                          info.icon!,
                                          width: double.maxFinite,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.5,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 6,
                                        text: TextSpan(
                                          style: const TextStyle(fontSize: 13),
                                          children: [
                                            TextSpan(
                                              text: info.title!,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (info.description != null)
                                              TextSpan(
                                                text: '\n${info.description!}',
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (info is WebImageInfo) {
                            return SizedBox(
                              height: 200,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  info.image,
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                ),
                              ),
                            );
                          } else if (info is WebVideoInfo) {
                            return SizedBox(
                              height: 200,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  info.image,
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        titleStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  DetectableText(
                    text: originalText,
                    textDirection: TextDirection.ltr,
                    detectionRegExp: RegExp(
                      r'(#[a-zA-Z0-9_]+)|https?://[^\s]+|(?<=\s|^)@[a-zA-Z0-9_]+',
                      multiLine: true,
                    ),
                    trimExpandedText:
                        '...' + translate(context, 'show_less').toString(),
                    trimCollapsedText:
                        translate(context, 'read_more').toString(),
                    detectedStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    basicStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    onTap: (tappedText) {
                      if (tappedText.startsWith("@")) {
                      } else if (tappedText.startsWith("#")) {
                      } else if (tappedText.startsWith("http")) {}
                    },
                  ),
                  // // Translation Toggle Button
                  // currentLanguage == "en" ||
                  //         widget.postData?.sharedPost != null ||
                  //         widget.postData?.sharedPost?.postText != ""
                  //     ? SizedBox.shrink()
                  //     : GestureDetector(
                  //         onTap: isShowingTranslation == false
                  //             ? () {
                  //                 postProvider
                  //                     .getTranslateText(
                  //                         type: "post",
                  //                         language: "en",
                  //                         postId: widget.postData!.id)
                  //                     .then((val) {
                  //                   if (val != null) {
                  //                     setState(() {
                  //                       translateText = val;
                  //                       isShowingTranslation = true;
                  //                     });
                  //                   }
                  //                 });
                  //               }
                  //             : () {
                  //                 setState(() {
                  //                   isShowingTranslation = false;
                  //                 });
                  //               },
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Text(
                  //             isShowingTranslation
                  //                 ? "Hide Translation"
                  //                 : "See Translation",
                  //             style: TextStyle(
                  //               color: Colors.grey.withValues(alpha: 0.5),
                  //               fontSize: 7,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  // // Display Translated Text
                  // if (isShowingTranslation)
                  //   Text(
                  //     translateText,
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //     ),
                  //   ),

                  //  Container(height: 20,color: Colors.orange,child: GestureDetector(child: Text("Translate",style: TextStyle(fontSize: 11),)),),
                  // getNumberOfLines(originalText, context) > 2
                  //     ? Row(
                  //         mainAxisAlignment: isRTL(originalText.toString())
                  //             ? MainAxisAlignment.end
                  //             : MainAxisAlignment.start,
                  //         children: <Widget>[
                  //           Builder(
                  //             builder: (context) {
                  //               var controller =
                  //                   ExpandableController.of(context)!;
                  //               return InkWell(
                  //                 child: Text(
                  //                   controller.expanded
                  //                       ? translate(context, "less").toString()
                  //                       : translate(context, "more").toString(),
                  //                   style:
                  //                       Theme.of(context).textTheme.labelLarge!,
                  //                 ),
                  //                 onTap: () {
                  //                   controller.toggle();
                  //                 },
                  //               );
                  //             },
                  //           ),
                  //         ],
                  //       )
                  //     : const SizedBox.shrink()
                ],
              ),
            ),
    );
  }
}
