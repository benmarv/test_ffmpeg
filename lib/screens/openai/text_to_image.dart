import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/openai/openai_controller.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ImageFeature extends StatefulWidget {
  const ImageFeature({super.key});

  @override
  State<ImageFeature> createState() => _ImageFeatureState();
}

class _ImageFeatureState extends State<ImageFeature> {
  final TextEditingController textC = TextEditingController();

  @override
  void initState() {
    Provider.of<ImageController>(context, listen: false).clearImageList();
    super.initState();
  }

  @override
  void dispose() {
    textC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageController>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
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
              Text(
                translate(context, "generative_ai")!,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * .02,
              bottom: MediaQuery.sizeOf(context).height * .1,
              left: MediaQuery.sizeOf(context).width * .04,
              right: MediaQuery.sizeOf(context).width * .04),
          children: [
            Text(
              translate(context, 'enter_your_prompt')!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: textC,
              onTapOutside: (e) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () => value.searchAiImage(textC: textC.text),
                    child: const Icon(LineIcons.search),
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 60,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  hintText: translate(context, 'prompt_hint'),
                  hintStyle: const TextStyle(fontSize: 13.5),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            const SizedBox(height: 20),
            value.imageList.isEmpty && value.isLoading == false
                ? Center(
                    child: Lottie.asset('assets/anim/ai_play.json',
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        height: MediaQuery.sizeOf(context).height * .3),
                  )
                : value.imageList.isEmpty && value.isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.imageList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            value.selectedImage(
                                selectedImage: value.imageList[index]);
                            Navigator.of(context).push(createRoute(DetailScreen(
                              image: value.imageList[index],
                              isFromAiScreen: true,
                            )));
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: CachedNetworkImage(
                              imageUrl: value.imageList[index],
                              height: 100,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
