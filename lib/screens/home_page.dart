import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/screens/brand_list.dart';
import 'package:spencer/screens/chat.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/product_details.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/screens/cart.dart';
import 'package:spencer/screens/search.dart';
import 'package:spencer/screens/wishlist.dart';
import 'package:spencer/states/cart_counter.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/categories_tile.dart';
import 'package:spencer/widgets/drawer.dart';
import 'package:spencer/widgets/loading_animation.dart';
import 'package:spencer/widgets/offer_wall.dart';

import '../notification/notification.dart';

String savedShopId = "";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future saveShopId() async {
    var sp = await SharedPreferences.getInstance();
    savedShopId = (sp.getString("shopId")) ?? "";
    var result = await fetchUserDetails(savedShopId);
    shopImage = result["image"];
  }

  @override
  void initState() {
    super.initState();

    NotificationServices().setupInteractedMessage();
    if (!isSkip) {
      saveShopId().then((value) {
        saveFCMTokentoServer(savedShopId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamicLinkRouting(context);
    return Scaffold(
      body: FutureBuilder(
        future: categoryCall(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return HomePageBody(
              data: snapshot.data,
            );
          } else if (snapshot.hasError) {
            var error = snapshot.error;
            if (error == "Socket error") {
              return const NoNetwork();
            } else {
              return const ErrorPage();
            }
          } else {
            // return Center(
            //     child: LoadingAnimationWidget.twoRotatingArc(
            //         color: mainColor, size: 35));
            // Center(child: CircularProgressIndicator());
            return const LoadingAnimation();
          }
        },
      ),
    );
  }
}

class HomePageBody extends StatefulWidget {
  final Map data;

  const HomePageBody({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DB database = DB();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    List category = widget.data["category"];
    // List offerwall = widget.data["offerwall"];

    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          _scaffoldKey.currentState?.closeDrawer();
        } else if (isSkip) {
          SystemNavigator.pop();
        } else {
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                'Are you sure you want to leave?',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'No',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      // willLeave = true;
                      // Navigator.of(context).pop();
                      SystemNavigator.pop();
                    },
                    child: Text('yes',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black)))
              ],
            ),
          );
        }

        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        floatingActionButton:
            !isSkip ? _buildFloatingActionButton() : const SizedBox.shrink(),
        appBar: _buildAppbar(height, width),
        drawer: const NavDrawer(),
        body: _buildBody(height, width, category),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////// body ///////////////////////////////////////////////////////////////////

  Widget _buildBody(double height, double width, List category) {
    return SingleChildScrollView(
      child: Stack(children: [
        // SizedBox(
        //     // height: 110.h,
        //     // width: 100.w,
        //     ),
        Container(
          height: height * 0.45,
          width: width,
          decoration: BoxDecoration(
              color: mainColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.elliptical(160, 80),
                bottomRight: Radius.elliptical(160, 80),
              )),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.01,
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                  height: 46,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -3),
                    contentPadding: const EdgeInsets.only(left: 5, top: 0),
                    // onTap: () => showSearches(context),
                    onTap: () {
                      min = 0;
                      max = 5000;
                      filterBrands.clear();
                      filterCategory.clear();
                      showSearches(context);
                    },
                    title: Text(
                      "Search products",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    leading: Icon(Icons.search,
                        color: Colors.grey.shade600,
                        size: Theme.of(context).iconTheme.size),
                  )),
            ),
            SizedBox(
              height: height * 0.01,
            ),

            widget.data["offerwall"].isEmpty
                ? const SizedBox()
                : AspectRatio(
                    aspectRatio: 21 / 9,
                    child: OfferWall(
                      details: widget.data["offerwall"],
                    ),
                  ),
            SizedBox(height: height * 0.02),
            Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.04,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //categories
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.01,
                          right: width * 0.01,
                          top: height * 0.03,
                          bottom: height * 0.01),
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: category.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.85,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: width * 0.015,
                                  mainAxisSpacing: height * 0.015),
                          itemBuilder: (context, index) {
                            var current = category[index];
                            return CategoriesTile(
                              imgUrl: current["category_image"],
                              title: current["category_name"],
                              categoryId: current["category_id"],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            FutureBuilder(
              future: fetchTopSelling(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var banner = snapshot.data["secondary_banner"];
                  var topselling = snapshot.data["product"];
                  var topBrands = snapshot.data["brand"];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // //banner
                      banner.isEmpty
                          ? const SizedBox.shrink()
                          : Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.04),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: AspectRatio(
                                aspectRatio: 21 / 9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: staticBannerDirectory +
                                        banner[0]["banner_image"],
                                    fit: BoxFit.fill,
                                    memCacheWidth: 1000,
                                    placeholder: (context, url) {
                                      return Image.asset(placeholderImage);
                                    },
                                    errorWidget: (context, url, dyn) {
                                      return Image.asset(noImageUrl);
                                    },
                                  ),
                                ),
                              ),
                            ),

                      SizedBox(height: height * 0.01),

                      //topSelling
                      topselling.isEmpty
                          ? const SizedBox()
                          : Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.04),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: width * 0.01,
                                    right: width * 0.01,
                                    top: height * 0.01,
                                    bottom: height * 0.01),
                                width: width,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 145, 187, 241),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      " Top Selling",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    GridView.builder(
                                        itemCount: topselling.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 0.8,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: width * 0.01,
                                                mainAxisSpacing: height * 0.01),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => Product(
                                                  productId: topselling[index]
                                                      ["product_id"],
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Column(
                                                children: [
                                                  AspectRatio(
                                                    aspectRatio: 1,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          productDetailsImage +
                                                              topselling[index][
                                                                  "product_image"],
                                                      // fit: BoxFit.fill,
                                                      memCacheWidth: 500,
                                                      // height: height * 0.221,
                                                      placeholder:
                                                          (context, url) {
                                                        return Image.asset(
                                                            placeholderImage);
                                                      },
                                                      errorWidget:
                                                          (context, url, dyn) {
                                                        return Image.asset(
                                                            noImageUrl);
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: width * 0.015),
                                                      child: Center(
                                                        child: Text(
                                                          topselling[index]
                                                              ["product_name"],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                      SizedBox(
                        height: height * 0.02,
                      ),

                      //topBrands
                      topBrands.isEmpty
                          ? const SizedBox()
                          : Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.04),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: width * 0.01,
                                    right: width * 0.01,
                                    top: height * 0.01,
                                    bottom: height * 0.01),
                                width: width,
                                decoration: BoxDecoration(
                                    color: Colors.red.shade300,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      " Top Brands",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    GridView.builder(
                                        itemCount: topBrands.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 3.5,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: width * 0.01,
                                                mainAxisSpacing: height * 0.01),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        BrandList(
                                                            brandName: topBrands[
                                                                    index]
                                                                ["brand_name"],
                                                            brandId: topBrands[
                                                                    index]
                                                                ["brand_id"]))),
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                child: Text(
                                                  topBrands[index]
                                                      ["brand_name"],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                      // Center(
                      //     child: ElevatedButton(
                      //   child: const Text('sample'),
                      //   onPressed: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => const Sample()));
                      //   },
                      // ))
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // //banner
            // Card(
            //   elevation: 2,
            //   margin: EdgeInsets.symmetric(horizontal: width * 0.04),
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(5)),
            //   child: AspectRatio(
            //     aspectRatio: 21 / 9,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(5),
            //       child: CachedNetworkImage(
            //         imageUrl:
            //             "https://www.mindinventory.com/blog/wp-content/uploads/2020/01/uiux-trends1200.png",
            //         fit: BoxFit.fill,
            //         memCacheWidth: 300,
            //         placeholder: (context, url) {
            //           return Image.asset(placeholderImage);
            //         },
            //         errorWidget: (context, url, dyn) {
            //           return Image.asset(noImageUrl);
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: height * 0.01),

            // //Top selling
            // FutureBuilder(
            //   future: fetchTopSelling(),
            //   builder: (context, AsyncSnapshot snapshot) {
            //     if (snapshot.hasData) {
            //       var data = snapshot.data;
            //       return Card(
            //         elevation: 2,
            //         margin: EdgeInsets.symmetric(horizontal: width * 0.04),
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(5)),
            //         child: Container(
            //           padding: EdgeInsets.only(
            //               left: width * 0.01,
            //               right: width * 0.01,
            //               top: height * 0.01,
            //               bottom: height * 0.01),
            //           width: width,
            //           decoration: BoxDecoration(
            //               color: const Color.fromARGB(255, 145, 187, 241),
            //               borderRadius: BorderRadius.circular(5)),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 " Top Selling",
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .titleLarge!
            //                     .copyWith(fontWeight: FontWeight.w600),
            //               ),
            //               SizedBox(
            //                 height: height * 0.01,
            //               ),
            //               GridView.builder(
            //                   itemCount: data["product"].length,
            //                   physics: const NeverScrollableScrollPhysics(),
            //                   shrinkWrap: true,
            //                   gridDelegate:
            //                       SliverGridDelegateWithFixedCrossAxisCount(
            //                           childAspectRatio: 0.8,
            //                           crossAxisCount: 2,
            //                           crossAxisSpacing: width * 0.01,
            //                           mainAxisSpacing: height * 0.01),
            //                   itemBuilder: (context, index) {
            //                     return GestureDetector(
            //                       onTap: () => Navigator.of(context)
            //                           .push(MaterialPageRoute(
            //                               builder: (context) => Product(
            //                                     productId: data["product"]
            //                                         [index]["product_id"],
            //                                   ))),
            //                       child: Container(
            //                         alignment: Alignment.center,
            //                         decoration: BoxDecoration(
            //                             color: Colors.white,
            //                             borderRadius: BorderRadius.circular(5)),
            //                         child: Column(
            //                           children: [
            //                             CachedNetworkImage(
            //                               imageUrl: productDetailsImage +
            //                                   data["product"][index]
            //                                       ["product_image"],
            //                               fit: BoxFit.fill,
            //                               memCacheWidth: 300,
            //                               height: height * 0.221,
            //                               placeholder: (context, url) {
            //                                 return Image.asset(
            //                                     placeholderImage);
            //                               },
            //                               errorWidget: (context, url, dyn) {
            //                                 return Image.asset(noImageUrl);
            //                               },
            //                             ),
            //                             Expanded(
            //                                 child: Padding(
            //                               padding: EdgeInsets.only(
            //                                   left: width * 0.015),
            //                               child: Center(
            //                                 child: Text(
            //                                   data["product"][index]
            //                                       ["product_name"],
            //                                   maxLines: 2,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style: Theme.of(context)
            //                                       .textTheme
            //                                       .titleSmall!
            //                                       .copyWith(
            //                                           fontWeight:
            //                                               FontWeight.w600),
            //                                 ),
            //                               ),
            //                             ))
            //                           ],
            //                         ),
            //                       ),
            //                     );
            //                   }),
            //             ],
            //           ),
            //         ),
            //       );
            //     } else {
            //       return SizedBox();
            //     }
            //   },
            // ),

            // SizedBox(
            //   height: height * 0.02,
            // ),
            // //Top brand

            // Card(
            //   elevation: 2,
            //   margin: EdgeInsets.symmetric(horizontal: width * 0.04),
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(5)),
            //   child: Container(
            //     padding: EdgeInsets.only(
            //         left: width * 0.01,
            //         right: width * 0.01,
            //         top: height * 0.01,
            //         bottom: height * 0.01),
            //     width: width,
            //     decoration: BoxDecoration(
            //         color: Colors.red.shade300,
            //         borderRadius: BorderRadius.circular(5)),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           " Top Brands",
            //           style: Theme.of(context)
            //               .textTheme
            //               .titleLarge!
            //               .copyWith(fontWeight: FontWeight.w600),
            //         ),
            //         SizedBox(
            //           height: height * 0.01,
            //         ),
            //         FutureBuilder(
            //           future: fetchTopSelling(),
            //           builder: (context, AsyncSnapshot snapshot) {
            //             if (snapshot.hasData) {
            //               var data=snapshot.data["brand"];
            //               return GridView.builder(
            //                   itemCount: data.length,
            //                   physics: const NeverScrollableScrollPhysics(),
            //                   shrinkWrap: true,
            //                   gridDelegate:
            //                       SliverGridDelegateWithFixedCrossAxisCount(
            //                           childAspectRatio: 3.5,
            //                           crossAxisCount: 2,
            //                           crossAxisSpacing: width * 0.01,
            //                           mainAxisSpacing: height * 0.01),
            //                   itemBuilder: (context, index) {
            //                     return GestureDetector(
            //                       // onTap: () =>,
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                             color: Colors.white,
            //                             borderRadius: BorderRadius.circular(5)),
            //                         child: Center(
            //                           child: Text(
            //                             data[index]["brand_name"],
            //                             overflow: TextOverflow.ellipsis,
            //                             style: Theme.of(context)
            //                                 .textTheme
            //                                 .titleLarge!
            //                                 .copyWith(
            //                                     fontWeight: FontWeight.w500),
            //                           ),
            //                         ),
            //                       ),
            //                     );
            //                   });
            //             } else {
            //               return SizedBox();
            //             }
            //           },
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: height * 0.02,
            )
          ],
        ),
      ]),
    );
  }

  ////////////////////////////////////////////////////////////////AppBar//////////////////////////////////////////////////////

  AppBar _buildAppbar(double height, double width) {
    return AppBar(
      // title:Image.asset("assets/images/logos.png",height:30,width:80) ,
      leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
          )),
      automaticallyImplyLeading: false,
      // backgroundColor: const Color(0xff107cb5),
      elevation: 0,
      actions: [
        Align(
          alignment: Alignment.topCenter,
          child: IconButton(
              onPressed: () {
                print(savedShopId);

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Wishlist()));
              },
              icon: const Icon(
                LineAwesomeIcons.heart,
              )),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Cart())),
          child: Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Cart()));
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                  )),
              Positioned(
                right: width * 0.007,
                top: height * 0.006,
                child: Consumer(
                  builder: (context, value, child) {
                    // final count2 = ref.watch(counterProvider);
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      var count = await database.cartCount();
                      int co = count[0]["COUNT(*)"];
                      context.read<CartCounter>().updateCount(co);
                    });
                    // Future.delayed(const Duration(milliseconds: 100), () async {

                    // });
                    var instance = Provider.of<CartCounter>(context);
                    return instance.count == 0
                        ? const SizedBox()
                        : Container(
                            // height: height * 0.036,
                            width: width * 0.046,
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
        SizedBox(width: width * 0.01),
      ],
    );
  }

  _buildFloatingActionButton() {
    return FutureBuilder(
        future: fetchUserDetails(savedShopId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              backgroundColor: mainColor,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatWidget(
                        email: snapshot.data["email"],
                        shopName: snapshot.data["shop_name"],
                      ))),
              child: const Icon(
                Icons.wechat,
                color: Colors.black,
              ),
            );
          } else {
            return FloatingActionButton(
              backgroundColor: mainColor,
              onPressed: null,
              child: const Icon(
                Icons.wechat,
                color: Colors.black,
              ),
            );
          }
        });
  }
}
