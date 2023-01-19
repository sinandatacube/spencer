import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/screens/cart.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/search.dart';
import 'package:spencer/states/bulk_description_visibility_provider.dart';
import 'package:spencer/states/bulk_provider.dart';
import 'package:spencer/states/cart_counter.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/bulk_subcategory_tile.dart';
import 'package:spencer/widgets/loading_animation.dart';

class BulkSubcategoryList extends StatefulWidget {
  final String subCategoryId;
  const BulkSubcategoryList({
    Key? key,
    required this.subCategoryId,
  }) : super(key: key);

  @override
  State<BulkSubcategoryList> createState() => _BulkSubcategoryListState();
}

class _BulkSubcategoryListState extends State<BulkSubcategoryList> {
  DB database = DB();
  String tempQuery = "";
  // getProIds() async {
  //   // prodIdss.clear();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<BulkProvider>().clearQuantity();
  //   });
  //   List temp = [];

  //   temp = await database.getProductId();
  //   // prodIdss.addAll(temp);
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<BulkProvider>().addQuantity(temp);
  //   });
  // }

  @override
  void initState() {
    getProIds(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BulkProvider>().clearQuery();
      context.read<BulkProvider>().clearAllData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getProIds();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: fetchSubcategory(widget.subCategoryId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data.toString());
            List productDetails = snapshot.data["product"];
            Map subcategoryDetails = snapshot.data["subcategory"];
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<BulkProvider>().addDetails(productDetails);
            });

            return Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: _buildAppbar(subcategoryDetails, height, width),
              body: productDetails.isEmpty
                  ? noDataFound(context)
                  : Consumer(builder: (context, value, child) {
                      var instance = Provider.of<BulkProvider>(context);

                      return _buildBody(
                          instance.productDetailss,
                          height,
                          width,
                          // prodIds,
                          instance.prodIdsss,
                          // prodIdss,
                          subcategoryDetails);
                    }),
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
        });
  }

  AppBar _buildAppbar(Map subcategoryDetails, double height, double width) {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () {
      //     Navigator.of(context).pushReplacement(MaterialPageRoute(
      //         builder: (context) =>
      //             SubcategoryList(subCategoryId: widget.subCategoryId)));
      //   },
      //   icon: const Icon(Icons.arrow_back),
      // ),
      title: subcategoryDetails["subcategory_desc"].isEmpty
          ? Text(
              subcategoryDetails["subcategory_name"],
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : const SizedBox(),
      actions: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Cart(
                isBulk: true,
                subCategoryId: widget.subCategoryId,
              ),
            ),
          ),
          child: Stack(
            children: [
              TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Cart(
                                isBulk: true,
                                subCategoryId: widget.subCategoryId,
                              ))),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                  )),
              Positioned(
                right: height * 0.015,
                top: width * 0.008,
                child: Consumer(
                  builder: (context, ref, child) {
                    var instance = Provider.of<CartCounter>(context);
                    // final count2=1;
                    return instance.count == 0
                        ? const SizedBox()
                        : Container(
                            // height: height*0.03,
                            width: width * 0.045,
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
    );
  }

  Widget _buildBody(
    List productDetails,
    double height,
    double width,
    List prodIdss,
    Map subcategoryDetails,
  ) {
    return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            subcategoryDetails["subcategory_desc"].isNotEmpty
                ? Container(
                    width: width,
                    padding: EdgeInsets.only(
                        right: width * 0.03,
                        left: width * 0.03,
                        top: height * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      subcategoryDetails["subcategory_name"],
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox(),
            subcategoryDetails["subcategory_desc"].isNotEmpty
                ? Container(
                    width: width,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                    ),
                    color: Colors.white,
                    child: const Divider(
                      color: Colors.black45,
                      thickness: 0.5,
                    ),
                  )
                : const SizedBox(),
            Container(
              width: width,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: subcategoryDetails["subcategory_desc"].isNotEmpty
                  ? Consumer(builder: (context, value, child) {
                      var instance =
                          Provider.of<BulkDescriptionProvider>(context);
                      return instance.visible
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Description",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Text(
                                  subcategoryDetails["subcategory_desc"],
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      context
                                          .read<BulkDescriptionProvider>()
                                          .updateVisibility();
                                    },
                                    icon: const Icon(Icons.arrow_drop_up),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Description",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54),
                                ),
                                IconButton(
                                    onPressed: () {
                                      context
                                          .read<BulkDescriptionProvider>()
                                          .updateVisibility();
                                    },
                                    icon: const Icon(Icons.arrow_drop_down))
                              ],
                            );
                    })
                  : const SizedBox(),
            ),
            GestureDetector(
              child: Container(
                width: width,
                height: 47,
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.012),
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: TextField(
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  onChanged: (query) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<BulkProvider>().getSearchedData(query);
                    });
                  },
                ),
              ),
            ),
            Consumer(builder: (context, value, child) {
              var instance = Provider.of<BulkProvider>(context);
              return instance.searchedd.isEmpty && instance.keyword != ""
                  ? buildNoMatch(height, width, context)
                  : ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: instance.keyword.isEmpty
                          ? instance.productDetailss.length
                          : instance.searchedd.length,
                      itemBuilder: (context, index) {
                        var current = instance.keyword.isEmpty
                            ? instance.productDetailss[index]
                            : instance.searchedd[index];
                        int qty = 0;
                        try {
                          qty = instance.prodIdsss[instance.prodIdsss
                              .indexWhere((element) =>
                                  element["product_id"] ==
                                  current["product_id"])]["qantity"];
                        } catch (e) {
                          qty = 0;
                        }
                        return BulkSubCategoryTile(
                            productStatus: current["product_status"],
                            productId: current["product_id"],
                            max: current["max_order"],
                            imgUrl: current["product_image"],
                            min: current["min_order"],
                            price: current["w_rate"],
                            title: current["product_name"],
                            qty: qty);
                        // return tile(
                        //     current["product_id"],
                        //     current["max_order"],
                        //     current["min_order"],
                        //     current["product_name"],
                        //     current["w_rate"],
                        //     current["product_image"],
                        //     qty);
                      });
            })
          ],
        ));
  }

  Widget tile(
    String productId,
    String max,
    String min,
    String title,
    String price,
    String imgUrl,
    int qty,
  ) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.01, vertical: height * 0.003),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.01, vertical: height * 0.003),
        height: height * 0.22,
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(
              width: width * 0.02,
            ),
            AspectRatio(
              aspectRatio: 3 / 4,
              child: CachedNetworkImage(
                imageUrl: productDetailsImage + imgUrl,
                errorWidget: (context, url, error) => Image.asset(noImageUrl),
                placeholder: (context, url) => Image.asset(placeholderImage),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                      ),
                      isSkip
                          ? const SizedBox()
                          : Row(
                              children: [
                                Text(
                                  "AED",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.red.shade800),
                                ),
                                Text(
                                  price,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: Colors.red.shade800,
                                          fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isSkip
                                ? const SizedBox()
                                : Text(
                                    "Min qty: $min\nMax qty: $max",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: Colors.black45),
                                  ),
                            qty == 0
                                ? SizedBox(
                                    width: 80,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100))),
                                      onPressed: () {
                                        if (isSkip) {
                                          null;
                                        } else {
                                          qty = int.parse(min);
                                          database.insertdata(
                                              savedShopId,
                                              productId,
                                              qty,
                                              int.parse(min),
                                              int.parse(max),
                                              true);
                                          context
                                              .read<BulkProvider>()
                                              .removeItemFromCart(productId);
                                          // prodIdss.removeWhere(
                                          //   (element) =>
                                          //       element["product_id"] ==
                                          //       productId,
                                          // );
                                          context
                                              .read<BulkProvider>()
                                              .addItemToCart(productId, qty);
                                          // prodIdss.add({
                                          //   "product_id": productId,
                                          //   "qantity": qty
                                          // });

                                          // setState(() {});
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 100,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          // color: Colors.grey.shade200,
                                        ),
                                        child: Text(
                                          "Add",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 30,
                                    width: 90,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Card(
                                          margin: EdgeInsets.zero,
                                          shape: const CircleBorder(),
                                          child: SizedBox.square(
                                            dimension: 27,
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                splashRadius: 10,
                                                onPressed: () {
                                                  //remove
                                                  if (qty == int.parse(min)) {
                                                    qty = 0;
                                                    database
                                                        .deleteItems(productId);
                                                    context
                                                        .read<BulkProvider>()
                                                        .removeItemFromCart(
                                                            productId);
                                                    // prodIdss.removeWhere(
                                                    //   (element) =>
                                                    //       element[
                                                    //           "product_id"] ==
                                                    //       productId,
                                                    // );
                                                    cartCountUpdate(context);
                                                  } else {
                                                    qty--;
                                                    database.insertdata(
                                                        savedShopId,
                                                        productId,
                                                        qty,
                                                        int.parse(min),
                                                        int.parse(max),
                                                        true);
                                                    context
                                                        .read<BulkProvider>()
                                                        .removeItemFromCart(
                                                            productId);
                                                    // prodIdss.removeWhere(
                                                    //   (element) =>
                                                    //       element[
                                                    //           "product_id"] ==
                                                    //       productId,
                                                    // );
                                                    context
                                                        .read<BulkProvider>()
                                                        .addItemToCart(
                                                            productId, qty);
                                                    // prodIdss.add({
                                                    //   "product_id": productId,
                                                    //   "qantity": qty
                                                    // });

                                                    cartCountUpdate(context);
                                                  }
                                                  // setState(() {});
                                                },
                                                icon: const Icon(Icons.remove)),
                                          ),
                                        ),
                                        Text(
                                          qty.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Card(
                                          margin: EdgeInsets.zero,
                                          shape: const CircleBorder(),
                                          child: SizedBox.square(
                                            dimension: 27,
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                splashRadius: 10,
                                                onPressed: () {
                                                  //addd
                                                  if (qty != int.parse(max)) {
                                                    qty++;
                                                    database.insertdata(
                                                        savedShopId,
                                                        productId,
                                                        qty,
                                                        int.parse(min),
                                                        int.parse(max),
                                                        true);
                                                    context
                                                        .read<BulkProvider>()
                                                        .removeItemFromCart(
                                                            productId);

                                                    // prodIdss.removeWhere(
                                                    //   (element) =>
                                                    //       element[
                                                    //           "product_id"] ==
                                                    //       productId,
                                                    // );
                                                    context
                                                        .read<BulkProvider>()
                                                        .addItemToCart(
                                                            productId, qty);

                                                    // prodIdss.add({
                                                    //   "product_id": productId,
                                                    //   "qantity": qty
                                                    // });
                                                    cartCountUpdate(context);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "max quantity reached")));
                                                  }
                                                  // setState(() {});
                                                },
                                                icon: const Icon(Icons.add)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
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

// List searched = [];
// List prodIdss = [];
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:spencer/api/api.dart';
// import 'package:spencer/db_service/db_functions.dart';
// import 'package:spencer/screens/cart.dart';
// import 'package:spencer/screens/error_page.dart';
// import 'package:spencer/screens/home_page.dart';
// import 'package:spencer/screens/no_network.dart';
// import 'package:spencer/screens/search.dart';
// import 'package:spencer/states/bulk_description_visibility_provider.dart';
// import 'package:spencer/states/cart_counter.dart';
// import 'package:spencer/utilities/global_variables.dart';
// import 'package:spencer/utilities/url.dart';
// import 'package:spencer/widgets/loading_animation.dart';

// List searched = [];
// List prodIdss = [];

// class BulkSubcategoryList extends StatefulWidget {
//   final String subCategoryId;
//   const BulkSubcategoryList({
//     Key? key,
//     required this.subCategoryId,
//   }) : super(key: key);

//   @override
//   State<BulkSubcategoryList> createState() => _BulkSubcategoryListState();
// }

// class _BulkSubcategoryListState extends State<BulkSubcategoryList> {
//   DB database = DB();
//   String tempQuery = "";
//   getProIds() async {
//     prodIdss.clear();
//     List temp = [];

//     temp = await database.getProductId();
//     prodIdss.addAll(temp);
//   }

//   @override
//   void initState() {
//     getProIds();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // getProIds();

//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;

//     return FutureBuilder(
//         future: fetchSubcategory(widget.subCategoryId),
//         builder: (context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             List productDetails = snapshot.data["product"];
//             Map subcategoryDetails = snapshot.data["subcategory"];
//             return Scaffold(
//               backgroundColor: Colors.grey.shade200,
//               appBar: _buildAppbar(subcategoryDetails, height, width),
//               body: productDetails.isEmpty
//                   ? Center(
//                       child: Column(
//                         // mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Spacer(
//                             flex: 5,
//                           ),
//                           Image.asset(
//                             "assets/images/emptyicon.png",
//                             height: 150,
//                             width: 170,
//                           ),
//                           Text(
//                             "No Data Found",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleMedium!
//                                 .copyWith(fontWeight: FontWeight.w600),
//                           ),
//                           const Spacer(
//                             flex: 7,
//                           ),
//                         ],
//                       ),
//                     )
//                   : _buildBody(
//                       productDetails,
//                       height,
//                       width,
//                       // prodIds,
//                       prodIdss,
//                       // prodIdss,
//                       subcategoryDetails),
//             );
//           } else if (snapshot.hasError) {
//             var error = snapshot.error;
//             if (error == "Socket error") {
//               return const NoNetwork();
//             } else {
//               return const ErrorPage();
//             }
//           } else {
//             return const LoadingAnimation();
//           }
//         });
//   }

//   AppBar _buildAppbar(Map subcategoryDetails, double height, double width) {
//     return AppBar(
//       // leading: IconButton(
//       //   onPressed: () {
//       //     Navigator.of(context).pushReplacement(MaterialPageRoute(
//       //         builder: (context) =>
//       //             SubcategoryList(subCategoryId: widget.subCategoryId)));
//       //   },
//       //   icon: const Icon(Icons.arrow_back),
//       // ),
//       title: subcategoryDetails["subcategory_desc"].isEmpty
//           ? Text(
//               subcategoryDetails["subcategory_name"],
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(fontWeight: FontWeight.w700),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             )
//           : const SizedBox(),
//       actions: [
//         GestureDetector(
//           onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
//               builder: (context) => Cart(
//                     isBulk: true,
//                     subCategoryId: widget.subCategoryId,
//                   ))),
//           child: Stack(
//             children: [
//               TextButton(
//                   onPressed: () =>
//                       Navigator.of(context).pushReplacement(MaterialPageRoute(
//                           builder: (context) => Cart(
//                                 isBulk: true,
//                                 subCategoryId: widget.subCategoryId,
//                               ))),
//                   child: const Icon(
//                     Icons.shopping_cart_outlined,
//                     color: Colors.black,
//                   )),
//               Positioned(
//                 right: height * 0.015,
//                 top: width * 0.008,
//                 child: Consumer(
//                   builder: (context, ref, child) {
//                     var instance = Provider.of<CartCounter>(context);
//                     // final count2=1;
//                     return instance.count == 0
//                         ? const SizedBox()
//                         : Container(
//                             // height: height*0.03,
//                             width: width * 0.045,
//                             decoration: BoxDecoration(
//                               color: Colors.red.shade800,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                                 child: Text(
//                               instance.count.toString(),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .labelMedium!
//                                   .copyWith(
//                                       fontWeight: FontWeight.w900,
//                                       color: Colors.white),
//                             )));
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBody(
//     List productDetails,
//     double height,
//     double width,
//     List prodIdss,
//     Map subcategoryDetails,
//   ) {
//     return SingleChildScrollView(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         subcategoryDetails["subcategory_desc"].isNotEmpty
//             ? Container(
//                 width: width,
//                 padding: EdgeInsets.only(
//                     right: width * 0.03,
//                     left: width * 0.03,
//                     top: height * 0.03),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   subcategoryDetails["subcategory_name"],
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge!
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//               )
//             : const SizedBox(),
//         subcategoryDetails["subcategory_desc"].isNotEmpty
//             ? Container(
//                 width: width,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: width * 0.03,
//                 ),
//                 color: Colors.white,
//                 child: const Divider(
//                   color: Colors.black45,
//                   thickness: 0.5,
//                 ),
//               )
//             : const SizedBox(),
//         Container(
//           width: width,
//           padding: EdgeInsets.symmetric(
//             horizontal: width * 0.03,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: subcategoryDetails["subcategory_desc"].isNotEmpty
//               ? Consumer(builder: (context, value, child) {
//                   var instance = Provider.of<BulkDescriptionProvider>(context);
//                   return instance.visible
//                       ? Container(

//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Description",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium!
//                                     .copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black54),
//                               ),
//                               SizedBox(
//                                 height: height * 0.005,
//                               ),
//                               Text(
//                                 subcategoryDetails["subcategory_desc"],
//                               ),
//                               Container(
//                                 alignment: Alignment.centerRight,
//                                 child: IconButton(
//                                   onPressed: () {
//                                     context
//                                         .read<BulkDescriptionProvider>()
//                                         .updateVisibility();
//                                   },
//                                   icon: const Icon(Icons.arrow_drop_up),
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       : Container(

//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Description",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium!
//                                     .copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black54),
//                               ),
//                               IconButton(
//                                   onPressed: () {
//                                     context
//                                         .read<BulkDescriptionProvider>()
//                                         .updateVisibility();
//                                   },
//                                   icon: const Icon(Icons.arrow_drop_down))
//                             ],
//                           ),
//                         );
//                 })
//               : const SizedBox(),
//         ),
//         GestureDetector(

//           child: Container(
//             width: width,
//             height: 47,
//             margin: EdgeInsets.symmetric(
//                 horizontal: width * 0.04, vertical: height * 0.01),
//             padding: EdgeInsets.symmetric(
//                 horizontal: width * 0.02, vertical: height * 0.005),
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black87),
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white),
//             child: TextField(
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Search",
//               ),
//               onChanged: (query) {
//                 tempQuery = query;
//                 searched.clear();
//                 query.isEmpty
//                     ? searched.clear()
//                     : searched = productDetails
//                         .where((element) => element["product_name"]
//                             .toLowerCase()
//                             .contains(query.toLowerCase()))
//                         .toList();
//                 setState(() {});
//               },
//             ),

//           ),
//         ),
//         tempQuery != "" && searched.isEmpty
//             ? buildNoMatch(height, width, context)
//             : ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount:
//                     tempQuery.isEmpty ? productDetails.length : searched.length,
//                 itemBuilder: (context, index) {
//                   var current = tempQuery.isEmpty
//                       ? productDetails[index]
//                       : searched[index];

//                   // print(prodIdss);
//                   int qty = 0;
//                   // prodIdss.where((element) => element["product_id"]==current["product_id"]);

//                   try {
//                     qty = prodIdss[prodIdss.indexWhere((element) =>
//                             element["product_id"] == current["product_id"])]
//                         ["qantity"];
//                   } catch (e) {
//                     qty = 0;
//                   }

//                   return tile(
//                     current["product_id"],
//                     current["max_order"],
//                     current["min_order"],
//                     current["product_name"],
//                     current["w_rate"],
//                     current["product_image"],
//                     qty,
//                   );

//                 })
//       ],
//     ));
//   }

//   Widget tile(String productId, String max, String min, String title,
//       String price, String imgUrl, int qty) {
//     return Card(
//       elevation: 1,
//       margin: EdgeInsets.symmetric(
//           horizontal: width * 0.01, vertical: height * 0.003),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Container(
//         margin: EdgeInsets.symmetric(
//             horizontal: width * 0.01, vertical: height * 0.003),
//         height: height * 0.22,
//         padding: EdgeInsets.symmetric(horizontal: width * 0.02),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             SizedBox(
//               width: width * 0.02,
//             ),
//             AspectRatio(
//               aspectRatio: 3 / 4,
//               child: CachedNetworkImage(
//                 imageUrl: productDetailsImage + imgUrl,
//                 errorWidget: (context, url, error) => Image.asset(noImageUrl),
//                 placeholder: (context, url) => Image.asset(placeholderImage),
//               ),
//             ),
//             Expanded(
//               child: ListTile(
//                 title: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleMedium!
//                             .copyWith(color: Colors.black),
//                       ),
//                       isSkip
//                           ? const SizedBox()
//                           : Row(
//                               children: [
//                                 Text(
//                                   "AED",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleSmall!
//                                       .copyWith(color: Colors.red.shade800),
//                                 ),
//                                 Text(
//                                   price,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleLarge!
//                                       .copyWith(
//                                           color: Colors.red.shade800,
//                                           fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             ),
//                       SizedBox(
//                         height: 50,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             isSkip
//                                 ? const SizedBox()
//                                 : Text(
//                                     "Min qty: $min\nMax qty: $max",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .labelMedium!
//                                         .copyWith(color: Colors.black45),
//                                   ),
//                             qty == 0
//                                 ? SizedBox(
//                                     width: 80,
//                                     child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           primary: Colors.white,
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(100))),
//                                       onPressed: () {
//                                         if (isSkip) {
//                                           null;
//                                         } else {
//                                           qty = int.parse(min);
//                                           database.insertdata(
//                                               savedShopId,
//                                               productId,
//                                               qty,
//                                               int.parse(min),
//                                               int.parse(max),
//                                               true);

//                                           prodIdss.removeWhere(
//                                             (element) =>
//                                                 element["product_id"] ==
//                                                 productId,
//                                           );

//                                           prodIdss.add({
//                                             "product_id": productId,
//                                             "qantity": qty
//                                           });

//                                           setState(() {});
//                                         }
//                                       },
//                                       child: Container(
//                                         alignment: Alignment.center,
//                                         height: 30,
//                                         width: 100,
//                                         padding: const EdgeInsets.all(2),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(100),
//                                           // color: Colors.grey.shade200,
//                                         ),
//                                         child: Text(
//                                           "Add",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .titleMedium!
//                                               .copyWith(color: Colors.black),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 : Container(
//                                     height: 30,
//                                     width: 90,
//                                     padding: const EdgeInsets.all(2),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(100),
//                                       color: Colors.grey.shade200,
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Card(
//                                           margin: EdgeInsets.zero,
//                                           shape: const CircleBorder(),
//                                           child: SizedBox.square(
//                                             dimension: 27,
//                                             child: IconButton(
//                                                 padding: EdgeInsets.zero,
//                                                 splashRadius: 10,
//                                                 onPressed: () {
//                                                   //remove
//                                                   if (qty == int.parse(min)) {
//                                                     qty = 0;
//                                                     database
//                                                         .deleteItems(productId);

//                                                     prodIdss.removeWhere(
//                                                       (element) =>
//                                                           element[
//                                                               "product_id"] ==
//                                                           productId,
//                                                     );
//                                                     cartCountUpdate(context);
//                                                   } else {
//                                                     qty--;
//                                                     database.insertdata(
//                                                         savedShopId,
//                                                         productId,
//                                                         qty,
//                                                         int.parse(min),
//                                                         int.parse(max),
//                                                         true);

//                                                     prodIdss.removeWhere(
//                                                       (element) =>
//                                                           element[
//                                                               "product_id"] ==
//                                                           productId,
//                                                     );

//                                                     prodIdss.add({
//                                                       "product_id": productId,
//                                                       "qantity": qty
//                                                     });

//                                                     cartCountUpdate(context);
//                                                   }
//                                                   setState(() {});
//                                                 },
//                                                 icon: const Icon(Icons.remove)),
//                                           ),
//                                         ),
//                                         Text(
//                                           qty.toString(),
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .titleMedium,
//                                         ),
//                                         Card(
//                                           margin: EdgeInsets.zero,
//                                           shape: const CircleBorder(),
//                                           child: SizedBox.square(
//                                             dimension: 27,
//                                             child: IconButton(
//                                                 padding: EdgeInsets.zero,
//                                                 splashRadius: 10,
//                                                 onPressed: () {
//                                                   //addd
//                                                   if (qty != int.parse(max)) {
//                                                     qty++;
//                                                     database.insertdata(
//                                                         savedShopId,
//                                                         productId,
//                                                         qty,
//                                                         int.parse(min),
//                                                         int.parse(max),
//                                                         true);

//                                                     prodIdss.removeWhere(
//                                                       (element) =>
//                                                           element[
//                                                               "product_id"] ==
//                                                           productId,
//                                                     );

//                                                     prodIdss.add({
//                                                       "product_id": productId,
//                                                       "qantity": qty
//                                                     });
//                                                     cartCountUpdate(context);
//                                                   } else {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .hideCurrentSnackBar();
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(
//                                                             const SnackBar(
//                                                                 content: Text(
//                                                                     "max quantity reached")));
//                                                   }
//                                                   setState(() {});
//                                                 },
//                                                 icon: const Icon(Icons.add)),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
