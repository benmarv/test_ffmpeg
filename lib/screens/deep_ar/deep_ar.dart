import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';
import 'package:link_on/screens/createstory/create_story.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class DeepArScreen extends StatefulWidget {
  DeepArScreen(
      {super.key, required this.deepArFilterLink, required this.isPost});
  final bool isPost;
  final String deepArFilterLink;
  @override
  State<DeepArScreen> createState() => _DeepArScreenState();
}

class _DeepArScreenState extends State<DeepArScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  late final WebViewController controller;

  void initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true, // ✅ Allow inline media playback
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) async {
        for (WebViewPermissionResourceType type in request.types) {
          var name = type.name;
          print("Requested permission: $name");

          if (name == "camera" || name == "microphone") {
            var status = await (name == "camera"
                ? Permission.camera.request()
                : Permission.microphone.request());

            if (status.isGranted) {
              await request.grant();
              print("Permission $name granted!");
            } else {
              await request.deny();
              print("Permission $name denied (status: $status)!");
            }
          } else {
            await request.deny();
            print("Permission $name denied (not recognized)!");
          }
        }
      },
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("Progress: $progress");
          },
          onPageStarted: (String url) {
            print("Page Started: $url");
          },
          onPageFinished: (String url) {
            print("Page Finished: $url");
          },
          onWebResourceError: (WebResourceError error) {
            print("Web resource error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            print("Navigating to: ${request.url}");
            if (request.url.startsWith(widget.deepArFilterLink)) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setOnConsoleMessage((message) {
        print("WebView Console: ${message.message}");
      });

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      final WebKitWebViewController webKitController =
          controller.platform as WebKitWebViewController;
      webKitController.setInspectable(true);
      webKitController.setAllowsBackForwardNavigationGestures(true);
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      final AndroidWebViewController androidController =
          controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    // ✅ Fix: Ensure the DeepAR URL is properly formatted
    if (widget.deepArFilterLink.isNotEmpty) {
      print("Loading WebView URL: ${widget.deepArFilterLink}");
      controller.loadRequest(Uri.parse(widget.deepArFilterLink));
    } else {
      print("Error: deepArFilterLink is empty!");
    }
  }

  bool isWebViewLoaded = false;
  @override
  void initState() {
    initializeWebView();
    Future.delayed(
      const Duration(seconds: 10),
      () {
        setState(() {
          isWebViewLoaded = true;
        });
      },
    );
    super.initState();
  }

  Future<void> takeScreenshot() async {
    int min = 1;
    int max = 1000;
    int randomInRange = min + Random().nextInt(max - min + 1);
    int randomInRange2 = min + Random().nextInt(10000 - min - 1);
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imagePath = '$directory/$randomInRange$randomInRange2.png';
        var imageFile = File(imagePath);
        var finalImage = await imageFile.writeAsBytes(image);

        if (widget.isPost) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePostPage(filterPhoto: finalImage),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreateStory(filterPhoto: finalImage),
              ));
        }
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () async {
              controller.loadRequest(Uri.parse("http://www.noexisting"));
              return true;
            },
            child: Stack(children: [
              Screenshot(
                controller: screenshotController,
                child: WebViewWidget(
                  controller: controller,
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 1, offset: Offset(0.3, 0.3))],
                  ),
                ),
              ),
              if (isWebViewLoaded) ...[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: takeScreenshot,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black54,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ]
            ])));
  }
}
