import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/screens/cart.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/search.dart';
import 'package:spencer/states/cart_counter.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/widgets/image_slider.dart';
import 'package:spencer/widgets/loading_animation.dart';
import '../api/api.dart';
import '../utilities/colors.dart';

// const String kUriPrefix = 'https://spencermobile.com/productdetails';
// const String kUriPrefix = 'https://spencermobile.com';
const String kHomepageLink = '/productdetails--';
const String kProductpageLink = '/?id=89';

class Product extends StatefulWidget {
  final String productId;
  Product({Key? key, required this.productId}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchProductDetails(
          widget.productId,
        ),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // print("snapshot.data");
            log(snapshot.data.toString());

            var details = snapshot.data["details"];

            return ProductDetail(
              productId: widget.productId,
              details: details,
            );
          } else if (snapshot.hasError) {
            var error = snapshot.error;
            if (error == "Socket error") {
              return const NoNetwork();
            } else {
              return const ErrorPage();
            }
          } else {
            return const LoadingAnimation();
          }
        },
      ),
    );
  }
}

class ProductDetail extends StatefulWidget {
  final String productId;

  final Map details;

  const ProductDetail(
      {Key? key, required this.productId, required this.details})
      : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late TextEditingController qtyController =
      TextEditingController(text: min.toString());

  late List images;

  late int min;

  late int max;

  bool isFavourite = false;

  late String wishlistId;

  DB database = DB();

  List tempImages = [];

  checkProductImagesNull() {
    int length = widget.details["image"].length;

    // if (length == 0) {
    //   log(length.toString());
    //   tempImages.add(widget.details["product_image"]);
    // } else {
    //   for (int i = 0; i < length; i++) {
    //     tempImages.add(widget.details["image"][i]["prod_image"]);
    //   }
    // }

    tempImages.add(widget.details["product_image"]);
    for (int i = 0; i < length; i++) {
      tempImages.add(widget.details["image"][i]["prod_image"]);
    }
  }

  ///////////////////////////// dynamic
  String? _linkMessage;

  bool _isCreatingLink = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  @override
  void initState() {
    checkProductImagesNull();
    // print(widget.details);
    // tempImages.add(widget.details["product_image"]);
    // for (int i = 0; i < widget.details["image"].length; i++) {
    //   tempImages.add(widget.details["image"][i]["prod_image"]);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.details["images"]);
    min = int.parse(widget.details["min_order"]);
    max = int.parse(widget.details["max_order"]);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // print(widget.details);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppbar(height, width),
        body: _buildBody(height, width, widget.productId));
  }

////////////////////////////////////////////////////////dynamic

  Future _createDynamicLink(bool short, String link) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: "https://datacubeinfo.page.link",
      // uriPrefix: kUriPrefix,
      link: Uri.parse(
          // "https://spencermobile.com/product/product" + kHomepageLink + link),
          "https://datacubeinfo.page.link/product" + kHomepageLink + link),
      androidParameters: AndroidParameters(
        packageName: 'com.datacubeinfo.spencer_accessories',
        minimumVersion: 0,
        fallbackUrl: Uri.parse(
            "https://play.google.com/store/apps/details?id=com.datacubeinfo.spencer_accessories"),
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.datacubeinfo.spencer-accessories",
        appStoreId: "1631495236",
        minimumVersion: "1.0.1",
      ),
      // iosParameters:
      //     const IOSParameters(bundleId: "com.datacubeinfo.spencer-accessories"),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
      log(url.toString());
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      log(_linkMessage!);
      _isCreatingLink = false;
    });
    return url.toString();
  }

  ////////////////////////////////////////////////// AppBar /////////////////////////////////////////////////////
  AppBar _buildAppbar(double height, double width) {
    return AppBar(
      elevation: 0,
      actions: [
        SizedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed:
                  // () => showSearches(context),
                  () {
                min = 0;
                max = 5000;
                filterBrands.clear();
                filterCategory.clear();
                showSearches(context);
              },
              child: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Cart())),
              child: Stack(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => const Cart(),
                        ))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                      )),
                  Positioned(
                    right: height * 0.015,
                    top: width * 0.008,
                    child: Consumer(
                      builder: (context, ref, child) {
                        // final count2 = ref.watch(counterProvider);
                        // final count2=1;
                        var instance = Provider.of<CartCounter>(context);
                        return instance.count == 0
                            ? const SizedBox()
                            : Container(
                                // height: height*0.03,
                                width: width * 0.045,
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.002,
                                  vertical: height * 0.001,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: Text(
                                  instance.count.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white),
                                )));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }

  //////////////////////////////////////////////////////////body///////////////////////////////////////////////////
  Widget _buildBody(double height, double width, String productId) {
    // var _images;
    // if(widget.details["image"].isEmpty){
    //    _images=widget.details["category_image"];
    // }else{
    // _images=
    // }
    // print("widget.details");
    // print(widget.details["image"]);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.45,
            width: width,
            child: Stack(
              children: [
                Container(
                  height: height * 0.4,
                  width: width,
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.02),
                  color: Colors.white,
                  child: ImageSlider(
                    images: tempImages,
                    productId: widget.details["product_id"],
                  ),
                ),
                // Positioned(
                //     top: height * 0.01,
                //     left: width * 0.02,
                //     child: TextButton(
                //       style: TextButton.styleFrom(
                //         primary: Colors.black,
                //         splashFactory: NoSplash.splashFactory,
                //       ),
                //       onPressed: () => Navigator.of(context).pop(),
                //       child: Card(
                //         elevation: 2,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(15)),
                //         child: Container(
                //           height: height * 0.055,
                //           width: width * 0.11,
                //           decoration: BoxDecoration(
                //               color: Colors.grey.shade300,
                //               borderRadius: BorderRadius.circular(15)),
                //           child: Icon(
                //             Icons.arrow_back_ios_new,
                //             size: Theme.of(context).iconTheme.size,
                //           ),
                //         ),
                //       ),
                //     )),
                // Positioned(
                //   top: height * 0.01,
                //   right: width * 0.14,
                //   child: TextButton(
                //     style: TextButton.styleFrom(
                //       primary: Colors.black,
                //       splashFactory: NoSplash.splashFactory,
                //     ),
                //     onPressed: () => showSearches(context),
                //     child: Card(
                //       elevation: 2,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(15)),
                //       child: Container(
                //         height: height * 0.055,
                //         width: width * 0.11,
                //         decoration: BoxDecoration(
                //             color: Colors.grey.shade300,
                //             borderRadius: BorderRadius.circular(15)),
                //         child: Icon(
                //           Icons.search,
                //           color: Colors.black,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //     top: height * 0.005,
                //     right: width * 0.01,
                //     child: Stack(
                //       children: [
                //         TextButton(
                //           style: TextButton.styleFrom(
                //             primary: Colors.black,
                //             splashFactory: NoSplash.splashFactory,
                //           ),
                //           onPressed: () {
                //             Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => Cart(),
                //             ));
                //           },
                //           child: Card(
                //             elevation: 2,
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(15)),
                //             child: Container(
                //                 alignment: Alignment.center,
                //                 height: height * 0.055,
                //                 width: width * 0.11,
                //                 decoration: BoxDecoration(
                //                     color: Colors.grey.shade300,
                //                     borderRadius:
                //                         BorderRadius.circular(15)),
                //                 child: const Icon(
                //                   Icons.shopping_cart_outlined,
                //                   color: Colors.black,
                //                 )),
                //           ),
                //         ),
                //         Positioned(
                //             right: height * 0.015,
                //             top: width * 0.008,
                //             child: Consumer(
                //               builder: (context, ref, child) {
                //                 final count2 = ref.watch(counterProvider);
                //                 // final count2=1;
                //                 return count2 == 0
                //                     ? SizedBox()
                //                     : Container(
                //                         height: height * 0.036,
                //                         width: width * 0.046,
                //                         decoration: BoxDecoration(
                //                           color: Colors.red.shade800,
                //                           shape: BoxShape.circle,
                //                         ),
                //                         child: Center(
                //                             child: Text(
                //                           count2.toString(),
                //                           style: Theme.of(context)
                //                               .textTheme
                //                               .labelMedium!
                //                               .copyWith(
                //                                   fontWeight:
                //                                       FontWeight.w900,
                //                                   color: Colors.white),
                //                         )));
                //               },
                //             )),
                //       ],
                //     )),

                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Column(
                    children: [
                      Card(
                        elevation: 1,
                        shape: const CircleBorder(),
                        child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                            ),
                            onPressed: () async {
                              // print("link");
                              String link =
                                  await _createDynamicLink(true, productId);
                              Share.share(link);
                            },
                            icon: const Icon(Icons.share)),
                      ),
                      FavWidget(productId: widget.productId),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.02),
                  child: Text(
                    widget.details["product_name"],
                    overflow: TextOverflow.clip,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.01),
                  child: Text(
                    "Brand: " + widget.details["brand_name"],
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.01),
                  child: Text(
                    "Category: " + widget.details["category_name"],
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ),
                if (!isSkip)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.01),
                    height: height * 0.08,
                    width: width * 0.45,
                    // color: Colors.yellow,
                    child: RichText(
                      text: TextSpan(
                        text: '',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'AED\t',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red.shade800),
                          ),
                          TextSpan(
                            text: widget.details["w_rate"],
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade800),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  height: height * 0.0,
                ),
                widget.details["description"].isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05, vertical: height * 0.0),
                        child: Text(
                          "Details",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: height * 0.015,
                ),
                widget.details["description"].isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05, vertical: height * 0.0),
                        child: Text(
                          widget.details["description"],
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.02),
                  child: Row(
                    children: [
                      Text(
                        "Quantity",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                      ),
                      Container(
                        height: height * 0.07,
                        width: width * 0.18,
                        margin: const EdgeInsets.only(
                          top: 5,
                          left: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: qtyController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "qty",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "min $min \nmax $max",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Consumer(
                    builder: (context, ref, child) {
                      // cartCountUpdate() {
                      //   Future.delayed(const Duration(milliseconds: 600),
                      //       () async {
                      //     var count = await DB().cartCount();
                      //     int co = count[0]["COUNT(*)"];
                      //     // print("co$co");
                      //     context.read<CartCounter>().updateCount(co);
                      //   });
                      // }

                      return Container(
                        width: width * 0.7,
                        height: height * 0.07,
                        margin: EdgeInsets.only(bottom: height * 0.02),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor),
                          onPressed: isSkip ||
                                  widget.details["product_status"] == "0"
                              ? null
                              : () {
                                  int qty = 0;

                                  String error = "";

                                  if (qtyController.text.trim().isNotEmpty) {
                                    qty = int.parse(qtyController.text.trim());
                                  }

                                  if (qtyController.text.trim().isEmpty) {
                                    error = "Enter quantity";
                                  } else if (qty < min) {
                                    error = "Minium quantity is $min";
                                  } else if (qty > max) {
                                    error = "Maximum quantity is $max";
                                  } else if (RegExp(r',. -')
                                      .hasMatch(qtyController.text)) {
                                    error = "Enter a valid Number";
                                  } else {
                                    //TODO add data to cart
                                    database.insertdata(savedShopId,
                                        widget.productId, qty, min, max, false);

                                    cartCountUpdate(context);
                                    Fluttertoast.cancel();
                                    Fluttertoast.showToast(
                                        msg: "Added to Cart",
                                        // fontSize: 15,
                                        textColor: Colors.white,
                                        backgroundColor: Colors.grey.shade700);
                                  }

                                  if (error != "") {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          error,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red.shade600,
                                      ),
                                    );
                                  }
                                },
                          child: widget.details["product_status"] == "0"
                              ? Text(
                                  "Not Available !",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red.shade500),
                                )
                              : Text(
                                  "Add to cart",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavWidget extends StatefulWidget {
  final String productId;
  const FavWidget({Key? key, required this.productId}) : super(key: key);

  @override
  State<FavWidget> createState() => _FavWidgetState();
}

class _FavWidgetState extends State<FavWidget> {
  bool isFav = false;
  bool isLoading = true;

  getWishResult(int type) async {
    try {
      Map res = await checkWishlist(widget.productId, type);
      isFav = res['status'];
      isLoading = false;
      log(isFav.toString());
    } catch (e) {
      isFav = false;
      isLoading = false;
      log("$e");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getWishResult(0);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: isSkip
            ? null
            : () async {
                isLoading = true;
                setState(() {});
                await getWishResult(1);
              },
        splashRadius: 24,
        icon: isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color.fromARGB(255, 224, 224, 224),
              )
            : Icon(
                Icons.favorite,
                color: isFav ? Colors.redAccent : Colors.grey.shade300,
              ),
      ),
    );
  }
}
