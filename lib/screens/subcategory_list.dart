import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/cart.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/search.dart';
import 'package:spencer/states/cart_counter.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/loading_animation.dart';
import 'package:spencer/widgets/search_card.dart';

// class SubcategoryList extends StatelessWidget {
//   String subCategoryId;
//   SubcategoryList({Key? key, required this.subCategoryId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return Scaffold(
//           backgroundColor: Colors.grey.shade100,
//           appBar: AppBar(
//             backgroundColor: mainColor,
//             automaticallyImplyLeading: false,
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: Icon(
//                 Icons.arrow_back,
//                 size: 30,
//               ),
//             ),
//             title: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => SearchPage(),
//                 ));
//               },
//               child: Container(
//                 height: 40,
//                 width: width * 0.7,
//                 alignment: Alignment.centerLeft,
//                 padding: EdgeInsets.only(left: width * 0.02),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: Text(
//                   "Search products",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black54,
//                       fontSize: 12.sp),
//                 ),
//               ),
//             ),
//             actions: [
//               Stack(
//                 children: [
//                   IconButton(
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => Cart(),
//                         ));
//                       },
//                       icon: Icon(Icons.shopping_cart_outlined, size: 24.sp)),
//                   Positioned(
//                     right: height * 0.005,
//                     top: width * 0.005,
//                     child: Consumer(
//                       builder: (context, ref, child) {
//                         final count2 = ref.watch(counterProvider);
//                         // final count2=1;
//                         return count2 == 0
//                             ? SizedBox()
//                             : Container(
//                                 height: height * 0.035,
//                                 width: width * 0.045,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(child: Text(count2.toString())));
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: width * 0.02,
//               )
//             ],
//           ),
//           body: FutureBuilder(
//             future: fetchSubcategory(subCategoryId),
//             builder: (context, AsyncSnapshot snapshot) {
//               if (snapshot.hasData) {
//                 if (snapshot.data == "Socket error") {
//                   print(snapshot.data);
//                   return NoNetwork();
//                 } else {
//                   print(snapshot.data);
//                   var subcateogoryProducts = snapshot.data["product"];
//                   // print(subcateogoryProducts);
//                   // print("object");
//                   // print(snapshot.data.length);
//                   return Padding(
//                     padding: EdgeInsets.symmetric(
//                         vertical: height * 0.02, horizontal: width * 0.01),
//                     child: GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           childAspectRatio: 0.7,
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 2.w,
//                           mainAxisSpacing: 1.2.h),
//                       itemCount: subcateogoryProducts.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         var current = subcateogoryProducts[index];
//                         //  return Container(color: Colors.black,height: 100,);
//                         return SizedBox(
//                             height: height * 0.3,
//                             width: width * 0.45,
//                             child: SearchCard(
//                                 imgUrl: productDetailsImage +
//                                     current["product_image"],
//                                 title: current["product_name"],
//                                 productId: current["product_id"],
//                                 wprice: current["w_rate"],
//                                 isInWishlist: true,
//                                 wishlistId: "wishlistId"));
//                       },
//                     ),
//                   );
//                 }
//               } else {
//                 return LoadingAnimation();
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
// }

class SubcategoryList extends StatelessWidget {
  final String subCategoryId;
  const SubcategoryList({Key? key, required this.subCategoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: fetchSubcategory(subCategoryId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data);
            log(snapshot.data.toString());
            var subcateogoryProducts = snapshot.data["product"];

            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: _buildAppBar(context, height, width),
              body: _buildBody(height, width, subcateogoryProducts, context),
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
////////////////////////////////////////////// appbar ///////////////////////////////////////////////

  AppBar _buildAppBar(BuildContext context, double height, double width) {
    return AppBar(
      actions: [
        IconButton(
            // onPressed: () => showSearches(context),
            onPressed: () {
              min = 0;
              max = 5000;
              filterBrands.clear();
              filterCategory.clear();
              showSearches(context);
            },
            icon: const Icon(Icons.search)),
        GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Cart())),
          child: Stack(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Cart(),
                    ));
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
                    var instance = Provider.of<CartCounter>(context);
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
                            )));
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: width * 0.02,
        )
      ],
    );
  }

  //////////////////////////////////////////// body /////////////////////////////////////////////////
  Widget _buildBody(double height, double width, List subcateogoryProducts,
      BuildContext context) {
    return subcateogoryProducts.isEmpty
        ? noDataFound(context)
        : Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.015, horizontal: width * 0.01),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.7,
                      crossAxisCount: 2,
                      // crossAxisSpacing: width * 0.02,
                      // mainAxisSpacing: height * 0.01
                    ),
                    itemCount: subcateogoryProducts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var current = subcateogoryProducts[index];
                      //  return Container(color: Colors.black,height: 100,);
                      return SizedBox(
                          height: height * 0.3,
                          width: width * 0.45,
                          child: SearchCard(
                            productStatus: current["product_status"],
                            imgUrl:
                                productDetailsImage + current["product_image"],
                            title: current["product_name"],
                            productId: current["product_id"],
                            wprice: current["w_rate"],
                          ));
                    },
                  ),
                ),
              ),
            ],
          );
  }
}
