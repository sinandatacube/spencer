import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/product_details.dart';
import 'package:spencer/screens/skipped_login_alert.dart';
import 'package:spencer/screens/wishlist_empty.dart';
import 'package:spencer/utilities/functions.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/loading_animation.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  bool isWishlistIsEmpty = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (isSkip) {
      return const SkippedLoginAlert();
    } else {
      return
       FutureBuilder(
          future: fetchWishlist(savedShopId),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                  backgroundColor: Colors.grey.shade100,
                  appBar: AppBar(
                    title: const Text("Wishlist"),
                  ),
                  body: _buildBody(height, width));
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
  }

////////////////////////////////////////////////////// body ///////////////////////////////
  Widget _buildBody(double height, double width) {
    return FutureBuilder(
      future: fetchWishlist(savedShopId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // if (snapshot.data == "Socket error") {
          //   return NoNetwork();
          // } else {
          var wishlistItems = snapshot.data["wishlist"];

          if (wishlistItems.isEmpty) {
            return const WishlistEmpty();
          } else {
            return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.01),
                child: GridView.builder(
                    itemCount: wishlistItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.8,
                        crossAxisCount: 2,
                        crossAxisSpacing: width * 0.01,
                        mainAxisSpacing: height * 0.01),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => Product(
                                        productId: wishlistItems[index]
                                            ["product_id"],
                                      )))
                              .then((value) => setState(() {}));
                        },
                        child: Container(
                          height: height * 0.23,
                          width: width * 0.45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.yellow.shade700, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(children: [
                            Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 4 / 3,
                                  child: CachedNetworkImage(
                                    imageUrl: productListImage +
                                        wishlistItems[index]["product_image"],
                                    memCacheWidth: 200,
                                    placeholder: (context, url) {
                                      return Image.asset(placeholderImage);
                                    },
                                    errorWidget: (context, url, dyn) {
                                      return Image.asset(noImageUrl);
                                    },
                                  ),
                                ),
                                Positioned(
                                    // right: width * 0.005,
                                    // top: height * 0.005,
                                    right: 0,
                                    top: 0,
                                    child: SizedBox(
                                      child: IconButton(
                                        onPressed: () async {
                                          checkNetwork();
                                          Future.delayed(
                                              const Duration(milliseconds: 200),
                                              () async {
                                            if (isConnected == "true") {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return const DialogLoadingAnimation(
                                                      pleaseWait: false,
                                                    );
                                                  });
                                              // print("object");
                                              var result =
                                                  await deleteFromWishlist(
                                                      wishlistItems[index]
                                                          ["wishlist_id"]);

                                              if (result == "seccess") {
                                                setState(() {});
                                                Navigator.of(context).pop();
                                              }
                                            } else {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const NoNetwork()));
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: width > 450
                                  ? Text(
                                      wishlistItems[index]["product_name"],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    )
                                  : Text(
                                      wishlistItems[index]["product_name"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                            ),
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.02, top: height * 0.004),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      width > 450
                                          ? Text("AED ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: Colors.red.shade700,
                                                    fontWeight: FontWeight.w400,
                                                  ))
                                          : Text(
                                              "AED ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    color: Colors.red.shade700,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                      width > 450
                                          ? Text(
                                              wishlistItems[index]["w_rate"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                    color: Colors.red.shade700,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            )
                                          : Text(
                                              wishlistItems[index]["w_rate"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: Colors.red.shade700,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    }));
            // }
          }
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
    );
  }
}
