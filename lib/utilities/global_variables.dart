//lists
import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/states/bulk_provider.dart';
import 'package:spencer/states/cart_counter.dart';

import '../screens/home_page.dart';
import '../screens/product_details.dart';
import 'dynamic links/dynamic_link.dart';

List filterBrands = [];
List filterCategory = [];
List result = [];
List suggestion = [];
List recentSearch = [];
List sort = [];
String sortType = "lowToHigh";
List cartItems = [];
List tempCartItems = [];
List prodIds = [];
List qty = [];
List ids = [];

//variables
double width = 0;
double height = 0;
double min = 0;
double max = 5000;
double tempMin = 0;
double tempMax = 5000;
XFile? images;
String? shopImage;
bool isSkip = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//functions
cartCountUpdate(BuildContext context) {
  Future.delayed(const Duration(milliseconds: 100), () async {
    var count = await DB().cartCount();
    int co = count[0]["COUNT(*)"];
    // print("co$co");
    context.read<CartCounter>().updateCount(co);
    // return co;
  });
}

// getproduct quantity
getProIds(BuildContext context) async {
  // prodIdss.clear();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<BulkProvider>().clearQuantity();
  });
  List temp = [];

  temp = await DB().getProductId();
  // prodIdss.addAll(temp);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<BulkProvider>().addQuantity(temp);
  });
}

Widget noDataFound(BuildContext context) {
  return Center(
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(
          flex: 5,
        ),
        Image.asset(
          "assets/images/emptyicon.png",
          height: 150,
          width: 170,
        ),
        Text(
          "No Data Found",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(
          flex: 7,
        ),
      ],
    ),
  );
}

dynamicLinkRouting(BuildContext context) async {
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    log(dynamicLinkData.link.toString());
    String link = dynamicLinkData.link.toString();
    List data = link.split("--");
    log(data.toString());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Product(
              productId: data[1],
            )));
    // Navigator.pushNamed(context, dynamicLinkData.link.path);
  }).onError((error) {
    log(error);
  });
  // log("dynamic");
  // final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  // //get id from dynamic link
  // String id = await _dynamicLinkService.retrieveDynamicLink(context);
  // //routing accoording to dynamic link
  // if (id.isNotEmpty) {
  //   // log(id, name: "mainn");
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => const HomePage()),
  //       (route) => false);
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => Product(
  //       productId: id,
  //     ),
  //   ));
  // }
}
