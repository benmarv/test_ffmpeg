import 'dart:io';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';
import 'package:link_on/screens/openai/openai_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum Status { none, loading, complete }

class ImageController extends ChangeNotifier {
  Status status = Status.none;

  String url = '';

  List<String> imageList = [];

  void selectedImage({required String selectedImage}) {
    url = selectedImage;
    notifyListeners();
  }

  void clearImageList() {
    imageList.clear();
    status = Status.none;
    notifyListeners();
  }

  bool isLoading = false;
  String apiKey = 'sk-None-X5rvpZdaNyqVWyn1kftqT3BlbkFJcJicvkwgPNHSH2QcfAeG';
  Future<void> createAIImage({required String textC}) async {
    if (textC.trim().isNotEmpty) {
      OpenAI.apiKey = apiKey;
      isLoading = true;
      status = Status.loading;

      OpenAIImageModel image = await OpenAI.instance.image.create(
        prompt:
            "$textC. Please generate family-friendly, safe-for-work images. Avoid any 18+ or explicit content.",
        style: OpenAIImageStyle.natural,
        n: 1,
        size: OpenAIImageSize.size512,
        responseFormat: OpenAIImageResponseFormat.url,
      );
      url = image.data[0].url.toString();
      log('openai image url : ${url}');
      isLoading = false;
      status = Status.complete;
      notifyListeners();
    } else {
      isLoading = false;
      toast('Provide some beautiful image description!');
    }
  }

  void downloadImage(
      {required BuildContext context, required bool isCreatePost}) async {
    try {
      //To show loading
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      log('url: $url');

      final bytes = (await get(Uri.parse(url))).bodyBytes;
      final dir = await getTemporaryDirectory();

      final file = await File('${dir.path}/ai_image.png').writeAsBytes(bytes);

      log('filePath: ${file.path}');

      //save image to gallery
      await GallerySaver.saveImage(file.path, albumName: 'LinkOn')
          .then((success) {
        //hide loading

        Navigator.pop(context);
        if (isCreatePost) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePostPage(filterPhoto: file),
              ));
        } else if (!isCreatePost) {
          toast('Image Downloaded to Gallery!', bgColor: Colors.green);
        }
      });
    } catch (e) {
      //hide loading
      Navigator.pop(context);
      toast('Something Went Wrong (Try again in sometime)!',
          bgColor: Colors.red);
      log('downloadImageE: $e');
    }
    notifyListeners();
  }

  void shareImage({required BuildContext context}) async {
    try {
      //To show loading
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      log('url: $url');

      final bytes = (await get(Uri.parse(url))).bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = await File('${dir.path}/ai_image.png').writeAsBytes(bytes);

      log('filePath: ${file.path}');

      //hide loading
      Navigator.pop(context);

      await Share.shareXFiles([XFile(file.path)],
          text:
              'Check out this Amazing Image created by Ai Assistant App by Harsh H. Rajpurohit');
    } catch (e) {
      //hide loading
      Navigator.pop(context);
      toast('Something Went Wrong (Try again in sometime)!',
          bgColor: Colors.red);
      log('downloadImageE: $e');
    }
    notifyListeners();
  }

  Future<void> searchAiImage({required String textC}) async {
    //if prompt is not empty
    if (textC.trim().isNotEmpty) {
      status = Status.loading;

      imageList = await APIs.searchAiImages(prompt: textC);

      if (imageList.isEmpty) {
        toast('Something went wrong. Try again in sometime',
            bgColor: Colors.red, textColor: Colors.white);

        return;
      }

      url = imageList.first;

      status = Status.complete;
    } else {
      toast('Provide some beautiful image description!');
    }
    notifyListeners();
  }
}
