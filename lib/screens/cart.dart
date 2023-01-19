import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/screens/bulk_subcatory_list.dart';
import 'package:spencer/screens/check_out.dart';
import 'package:spencer/screens/empty_cart.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/skipped_login_alert.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/loading_animation.dart';
import 'package:spencer/widgets/popup_qty_field.dart';
import '../utilities/global_variables.dart';

class Cart extends StatelessWidget {
  final bool isBulk;
  final String subCategoryId;
  final String categoryId;
  const Cart(
      {Key? key,
      this.isBulk = false,
      this.subCategoryId = "0",
      this.categoryId = "0"})
      : super(key: key);

  Future getProIds() async {
    DB database = DB();

    var result = await database.getProductId();

    return result;
  }

//just comment
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isBulk) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => BulkSubcategoryList(
                    subCategoryId: subCategoryId,
                  )));
        } else {
          Navigator.of(context).pop();
        }

        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: getProIds(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                prodIds = snapshot.data;
                List temp = List.from(prodIds);
                temp.sort((a, b) => (int.parse(a['product_id']))
                    .compareTo(int.parse(b['product_id'])));

                ids = temp.map((e) => e['product_id']).toList();
                qty = temp.map((e) => e['qantity']).toList();
                // print(ids);
                // print(qty);
                return CartBody(
                  isBulk: isBulk,
                  subCategoryId: subCategoryId,
                  categoryId: categoryId,
                );
              } else {
                return Scaffold(
                  appBar: _buildAppbar(context),
                  body: isSkip
                      ? const SkippedLoginAlert(isBackButtonVisible: false)
                      : const EmptyCart(),
                );
              }
            } else {
              return const LoadingAnimation();
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (isBulk) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BulkSubcategoryList(
                        subCategoryId: subCategoryId,
                      )));
            } else {
              Navigator.of(context).pop();
            }
          }),
      title: const Text("Cart"),
      // actions: [
      //   IconButton(
      //       onPressed: () {
      //         Navigator.of(context).push(MaterialPageRoute(
      //           builder: (context) => const Wishlist(),
      //         ));
      //       },
      //       icon: const Icon(
      //         LineAwesomeIcons.heart,
      //         // color: Colors.black,
      //       ))
      // ],
    );
  }
}

class CartBody extends StatelessWidget {
  // final List prodIds;
  final String subCategoryId;
  final String categoryId;
  final bool isBulk;
  const CartBody(
      {Key? key,
      required this.isBulk,
      required this.subCategoryId,
      required this.categoryId})
      : super(key: key);

  Future getData() async {
    try {
      List ids = prodIds.map((e) => e['product_id']).toList();

      Map params = {'products': jsonEncode(ids)};
      var response = await http.post(Uri.parse(cartUrl), body: params);
      if (response.statusCode == 200) {
        var result = await jsonDecode(response.body);
        return result['product'];
      } else {
        return [];
      }
    } on SocketException {
      return Future.error("Socket error");
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              tempCartItems = snapshot.data;
              tempCartItems.sort((a, b) => (int.parse(a['product_id']))
                  .compareTo(int.parse(b['product_id'])));
              return CartItems(
                isBulk: isBulk,
                subCategoryId: subCategoryId,
                categoryId: categoryId,
              );
            } else {
              return const Text('No data');
            }
          } else if (snapshot.hasError) {
            var error = snapshot.error;
            if (error == "Socket error") {
              return const NoNetwork();
            } else {
              // print(snapshot.data);
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

class CartItems extends StatefulWidget {
  final bool isBulk;
  final String subCategoryId;
  final String categoryId;
  // final List cartItems;
  // final List prodIds;
  const CartItems(
      {Key? key,
      required this.isBulk,
      required this.subCategoryId,
      required this.categoryId})
      : super(key: key);

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  DB database = DB();
  late int totalCount;
  TextEditingController qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: _builAppBar(
          width, widget.isBulk, widget.subCategoryId, widget.categoryId),
      body: _buildBody(height, width),
      bottomNavigationBar: _buildBottomNavigationBar(width, height),
    );
  }

////////////////////////////////////////////////////////Body///////////////////////////////////////////////////////////
  Widget _buildBody(double height, double width) {
    return tempCartItems.isEmpty
        ? const EmptyCart()
        : Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.01, horizontal: width * 0.015),
            child: ListView.builder(
              itemCount: tempCartItems.length,
              itemBuilder: (context, index) {
                var current = tempCartItems[index];
                // log("$current");
                totalGet();
                //  print("cartItems.length");
                //  print(cartItems.length);
                //  print("qty.length");
                //  print(qty.length);
                return Container(
                  height: height * 0.15,
                  width: width,
                  color: Colors.white,
                  margin: EdgeInsets.only(
                    top: height * 0.005,
                  ),
                  // horizontal: width * 0.02, vertical: height * 0.002),
                  child: Row(
                    children: [
                      // Image.network(
                      //   productListImage + current["product_image"],
                      //   height: height * 0.15,
                      //   width: width * 0.25,
                      //   fit: BoxFit.fill,
                      // ),
                      SizedBox(
                        height: height * 0.14,
                        width: width * 0.24,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl:
                                productListImage + current["product_image"],
                            // height: height * 0.12,
                            // width: width * 0.24,
                            // fit: BoxFit.contain,
                            memCacheWidth: 200,
                            placeholder: (context, url) {
                              return Image.asset(placeholderImage);
                            },
                            errorWidget: (context, url, dyn) {
                              return Image.asset(noImageUrl);
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: width * 0.45,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            width > 500
                                ? Text(
                                    current["product_name"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                    //  TextStyle(
                                    //     fontWeight: FontWeight.w500,
                                    //     fontSize: 10.sp),
                                  )
                                : Text(
                                    current["product_name"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(fontWeight: FontWeight.w500),
                                    //  TextStyle(
                                    //     fontWeight: FontWeight.w500,
                                    //     fontSize: 10.sp),
                                  ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'AED ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(fontWeight: FontWeight.w600),
                                children: <TextSpan>[
                                  TextSpan(
                                    // text: total.toString(),
                                    text: current["w_rate"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (current['product_status'] == "0")
                              Text(
                                "Not Available !",
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        height: height * 0.15,
                        width: width * 0.15,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Qty",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(
                              height: height * 0.005,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.black87),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PopUpQtyField(
                                        cartItems: tempCartItems,
                                        index: index,
                                        productId: tempCartItems[index]
                                            ["product_id"],
                                      );
                                    }).then((value) {
                                  setState(() {});
                                });
                              },
                              child: Container(
                                height: height * 0.05,
                                width: width * 0.12,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade900),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  qty[index].toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            return IconButton(
                              onPressed: () {
                                //remove product from loading the cart
                                tempCartItems.remove(current);
                                //remove quantity from loading the cart
                                qty.removeAt(index);
                                //remove the product stored in the local database
                                database.deleteItems(current["product_id"]);
                                //delay the process of counting the cart items

                                setState(() {});
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(
                                    msg: "Item removed",
                                    fontSize: 15,
                                    textColor: Colors.white,
                                    backgroundColor: Colors.grey.shade700);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.red.shade700,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

//////////////////////////////////////////////////////////Appbar//////////////////////////////////////////////////////////////
  AppBar _builAppBar(
      double width, bool isBulk, String subCategoryId, String categoryId) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (isBulk) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => BulkSubcategoryList(
                      subCategoryId: subCategoryId,
                    )));
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      foregroundColor: Colors.black,
      title: const Text(
        "Cart",
      ),
      // actions: [
      //   IconButton(
      //       onPressed: () {
      //         Navigator.of(context)
      //             .push(MaterialPageRoute(
      //           builder: (context) => const Wishlist(),
      //         ))
      //             .then((value) {
      //           setState(() {});
      //         });
      //       },
      //       icon: const Icon(
      //         LineAwesomeIcons.heart,
      //         // size: 30,
      //       )),
      //   SizedBox(
      //     width: width * 0.01,
      //   )
      // ],
    );
  }

////////////////////////////////////////////////////////////bottom NavigationBar////////////////////////////////////////////////
  Widget _buildBottomNavigationBar(double width, double height) {
    return tempCartItems.isEmpty
        ? const SizedBox.shrink()
        : Container(
            height: height * 0.09,
            width: width,
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black54))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                      // height: 65,
                      alignment: Alignment.center,
                      // width: width * 0.45,
                      // child: Text("AED $total",
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 19))
                      child: RichText(
                        text: TextSpan(
                          text: 'Total:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                          // style: TextStyle(
                          //     color: Colors.black,
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 12.sp),
                          children: <TextSpan>[
                            TextSpan(
                              text: " AED ",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade800),

                              // style: TextStyle(
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 11.sp,
                              //     color: Colors.red.shade600)
                            ),
                            TextSpan(
                                // text: total.toString(),
                                text: totalGet().toStringAsFixed(2),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red.shade800)

                                // style: TextStyle(
                                //     fontWeight: FontWeight.w600,
                                //     fontSize: 16.sp,
                                //     color: Colors.red.shade600)
                                ),
                          ],
                        ),
                      )),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.55,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02,
                    ),
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: mainColor),
                      onPressed: () {
                        cartItems.clear();
                        for (var element in tempCartItems) {
                          if (element["product_status"] == "1") {
                            cartItems.add(element);
                          }
                        }
                        if (cartItems.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CheckOut(
                                    tot: totalAvailGet().toStringAsFixed(2),
                                  )));
                        } else {
                          Fluttertoast.showToast(msg: "Items unavailable");
                        }
                      },
                      child: Text(
                        "Check out",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black),

                        // style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  //////////////////////////////////////////////////subtotal of cart////////////////////////////////////////////////////////
  double totalGet() {
    double tot = 0.0;
    int length = tempCartItems.length;

    for (var i = 0; i < length; i++) {
      double price = double.parse(tempCartItems[i]['w_rate']);

      // int quty = prodIds[i]['qantity'];
      int quty = qty[i];

      tot += price * quty;
    }
    return tot;
  }

  double totalAvailGet() {
    double tot = 0.0;
    int length = tempCartItems.length;
    for (var i = 0; i < length; i++) {
      if (tempCartItems[i]["product_status"] == "1") {
        double price = double.parse(tempCartItems[i]['w_rate']);

        // int quty = prodIds[i]['qantity'];
        int quty = qty[i];

        tot += price * quty;
      }
    }
    return tot;
  }
}
