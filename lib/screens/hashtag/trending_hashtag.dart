import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/hashtags_model.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'hashtag_post.dart';

class TrendingHashtag extends StatefulWidget {
  const TrendingHashtag({super.key});
  @override
  State<TrendingHashtag> createState() => _TrendingHashtagState();
}

class _TrendingHashtagState extends State<TrendingHashtag> {
  List<HashtagModel> hashtaglist = [];
  bool isdata = false;

  Future<void> hashtagApi() async {
    Map<String, dynamic> dataArray = {};
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'trending-hashtags', apiData: dataArray);
    if (res["code"] == '200') {
      var data = res['data'];
      hashtaglist = List.from(data).map<HashtagModel>((data) {
        return HashtagModel.fromJson(data);
      }).toList();

      isdata = true;
      setState(() {});
    } else {
      isdata = true;
      setState(() {});
      log('Error: ${res['message']}');
    }
  }

  List<Usr> prouser = [];
  Future<void> proUserApi() async {
    Map<String, dynamic> dataArray = {};
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'get-pro-users', apiData: dataArray);
    if (res["code"] == '200') {
      var data = res['data'];
      prouser = List.from(data).map<Usr>((data) {
        return Usr.fromJson(data);
      }).toList();
      log('prouser : ${prouser[0].username}');

      setState(() {});
    } else {
      log('Error: ${res['message']}');
    }
  }

  @override
  void initState() {
    hashtagApi();
    proUserApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
              )),
          elevation: 1,
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
              // Text(
              //   translate(context, 'trending_posts').toString(),
              //   style: const TextStyle(
              //     fontStyle: FontStyle.italic,
              //     fontSize: 14,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              prouser.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            translate(context, 'pro_users').toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          width: MediaQuery.sizeOf(context).width,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: prouser.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProfileTab(
                                                    userId: prouser[index].id,
                                                  )));
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      prouser[index].avatar!))),
                                        ),
                                        Positioned(
                                            bottom: 5,
                                            right: -1,
                                            child: verified())
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              hashtaglist.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate(context, 'trending_hashtags').toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: hashtaglist.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HashtagPost(
                                                    tag:
                                                        hashtaglist[index].name,
                                                  )));
                                    },
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(
                                            Icons.trending_up,
                                            color: AppColors.gradientColor1,
                                          ),
                                          title: Text(
                                              "${hashtaglist[index].name}"),
                                          subtitle: Text(
                                              "${hashtaglist[index].tagCount} ${translate(context, 'posts').toString()}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      width: MediaQuery.sizeOf(context).width,
                      child: (isdata == true && hashtaglist.isEmpty)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                loading(),
                                Text(translate(context, 'no_hashtag_found')
                                    .toString()),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )),
            ],
          ),
        ));
  }
}
