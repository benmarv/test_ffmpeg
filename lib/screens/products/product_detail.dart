import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/spaces/spaces_home/widgets/show_confirmation_dialogue.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/product_model/product_model.dart';
import 'package:link_on/controllers/product/get_product_provider.dart';
import 'package:link_on/screens/message_details.dart/messaging_with_agora.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/screens/products/edit_product.dart';

class ProducDetail extends StatefulWidget {
  final ProductsModel? productModel;
  final int? index;
  final bool? isHomePost;
  final bool? isProfilePost;
  const ProducDetail(
      {super.key,
      this.productModel,
      this.index,
      this.isHomePost,
      this.isProfilePost});

  @override
  State<ProducDetail> createState() => _ProducDetailState();
}

class _ProducDetailState extends State<ProducDetail> {
  int selectedIndex = 0;
  int _currentIndex = 0;

  // List<String> productTypeList = ["Used", "New"];
  List<String> productStatusList = ["in_stock", "out_of_stock"];

  @override
  void initState() {
    log('Is Home Post: ${widget.isHomePost}');
    super.initState();
    getCoordinatesFromAddress(widget.productModel!.location.toString());
  }

  late GoogleMapController mapController;

  // Initial position for the map
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Coordinates of San Francisco
    zoom: 10,
  );

  Future<void> getCoordinatesFromAddress(address) async {
    log("Address: $address");
    try {
      // Get coordinates from the address
      List<Location> locations = await locationFromAddress(address);

      // If a valid location is returned
      if (locations.isNotEmpty) {
        Location location = locations.first;
        print(
            "Latitude: ${location.latitude}, Longitude: ${location.longitude}");
      } else {
        print("No coordinates found for the address");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    int statuss = int.parse(widget.productModel!.status.toString());

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: MediaQuery.sizeOf(context).height * 0.3,
                          width: MediaQuery.sizeOf(context).width * 0.95,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: PageView.builder(
                            itemCount: widget.productModel!.images.length,
                            controller:
                                PageController(initialPage: _currentIndex),
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                  image: widget.productModel!
                                                      .images[index].image,
                                                )));
                                  },
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        width: double.infinity,
                                        imageUrl: widget
                                            .productModel!.images[index].image
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child:
                                              CircularProgressIndicator(), // Show loader while loading
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: Icon(Icons.error,
                                              color: Colors
                                                  .red), // Show error icon on failure
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ),
                        Positioned(
                            top: 30,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 25,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1,
                                        offset: Offset(0.3, 0.3),
                                      )
                                    ],
                                  )),
                            )),
                        Positioned(
                          bottom: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                widget.productModel!.images.length, (index) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _currentIndex == index
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .6,
                                  child: Text(
                                    "${widget.productModel?.productName}",
                                    maxLines: null,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.productModel!.price.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          widget.productModel!.currency
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      widget.productModel!.createdAt!.timeAgo,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 205, 205, 205),
                                            width: .5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          widget.productModel!.userId
                                                      .toString() ==
                                                  getStringAsync("user_id")
                                              ? Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Edit my product",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  "Contact with seller",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                          widget.productModel!.userId
                                                      .toString() ==
                                                  getStringAsync("user_id")
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                .65,
                                                        child: Center(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditProduct(
                                                                    productModel:
                                                                        widget
                                                                            .productModel,
                                                                    id: widget
                                                                        .productModel!
                                                                        .id,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 40,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .7,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: AppColors
                                                                    .primaryColor,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  translate(
                                                                      context,
                                                                      'edit_product')!,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      5.sw,
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            showConfirmationDialog(
                                                              context: context,
                                                              title: translate(
                                                                      context,
                                                                      'delete_product')
                                                                  .toString(),
                                                              yesText:
                                                                  translate(
                                                                      context,
                                                                      'yes')!,
                                                              noText: translate(
                                                                  context,
                                                                  'no')!,
                                                              onYes: () {
                                                                context
                                                                    .read<
                                                                        GetProductProvider>()
                                                                    .deleteProduct(
                                                                      screenName: widget.isHomePost ==
                                                                              true
                                                                          ? "home"
                                                                          : widget.isProfilePost == true
                                                                              ? "profile"
                                                                              : null,
                                                                      context:
                                                                          context,
                                                                      productsModel:
                                                                          widget
                                                                              .productModel!,
                                                                      index: widget
                                                                          .index,
                                                                    );
                                                              },
                                                              onNo: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            );
                                                          },
                                                          child: const Icon(
                                                            LineIcons.trash,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer()
                                                    ],
                                                  ),
                                                )
                                              : widget.productModel!.userId
                                                              .toString() ==
                                                          getStringAsync(
                                                              "user_id") &&
                                                      widget.isHomePost == true
                                                  ? SizedBox()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Center(
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AgoraMessaging(
                                                                              userId: widget.productModel!.userInfo!.id,
                                                                              userAvatar: widget.productModel!.userInfo!.avatar,
                                                                              userFirstName: widget.productModel!.userInfo!.firstName,
                                                                              userLastName: widget.productModel!.userInfo!.lastName,
                                                                            )));
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: AppColors
                                                                  .primaryColor,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons.chat,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  translate(
                                                                      context,
                                                                      'chat_seller')!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                        ],
                                      )),
                                ),
                              ],
                            ),

                            Text(
                              translate(context, "description")!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   "${widget.productModel?.productDescription}",
                            //   style:
                            //       const TextStyle(fontWeight: FontWeight.w400),
                            // ),
                            SizedBox(height: 8),
                            ReadMoreText(
                              '''${widget.productModel?.productDescription}''',
                              trimLines: 1,
                              trimLength: 110,
                              style: const TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              colorClickableText: AppColors.primaryColor,
                              trimCollapsedText:
                                  translate(context, 'read_more')!,
                              trimExpandedText:
                                  translate(context, 'show_less')!,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Center(
                                  child: Text(
                                    translate(context,
                                            productStatusList[statuss])! +
                                        " :",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  widget.productModel!.type.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  translate(context, "categories")! + " :",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.productModel!.category.toString(),
                                ),
                              ],
                            ),
                            const Divider(
                                thickness: .5,
                                color: Color.fromARGB(255, 221, 221, 221)),
                            Text(
                              "Seller informaiton",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            ListTile(
                              title: Text(widget
                                  .productModel!.userInfo!.firstName
                                  .toString()),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(widget
                                    .productModel!.userInfo!.avatar
                                    .toString()),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => ProfileTab(
                                          userId: widget.productModel!.userId
                                              .toString(),
                                        )),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                                thickness: .5,
                                color: Color.fromARGB(255, 221, 221, 221)),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        "Meetup Preferances",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 18),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: GoogleMap(
                                        initialCameraPosition: _initialPosition,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          mapController = controller;
                                        },
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(widget.productModel!.location
                                          .toString()),
                                      Text(
                                        "Location is approximate",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
