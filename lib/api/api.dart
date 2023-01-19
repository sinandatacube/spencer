import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/utilities/url.dart';

Future categoryCall() async {
  try {
    var response = await http.get(
      Uri.parse(
        baseUrl + categoriesUrl,
      ),
    );
    log(response.body.toString());
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    debugPrint(e.toString());
    return Future.error(e);
  }
}

Future checkSubcategory(String categoryId) async {
  try {
    Map params = {"category_id": categoryId};

    var response =
        await http.post(Uri.parse(baseUrl + subCategoriesUrl), body: params);
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);

      //  jsondata['category'];
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

Future fetchProductDetails(
  String productId,
) async {
  Map params = {"product_id": productId};
  try {
    var response =
        await http.post(Uri.parse(baseUrl + productDetailsUrl), body: params);
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network Error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

// Future fetchCartDetails(List productIds) async {

//   try {
//     Map params = {"products": jsonEncode(productIds)};
//   var response = await http.post(Uri.parse(cartUrl), body: params);

//   if (response.statusCode == 200) {
//     var data = await jsonDecode(response.body);
//     // cartProduct.add(data["details"]);
//     // print("data");
//     // print(data);
//     return data;
//   } else {
//     return Future.error("Network Error");
//   }

//   } on SocketException {
//     return Future.error("Socket error");
//   } catch (e) {
//     print(e);
//   }
// }

Future insertIntiWishlist(String productId, String shopId) async {
  try {
    Map params = {"product_id": productId, "shop_id": shopId};
    var response =
        await http.post(Uri.parse(baseUrl + wishlistInsert), body: params);
    if (response.statusCode == 200) {
      // print(response.statusCode);
      // print(response.body);
      return await jsonDecode(response.body);
    } else {
      // print("error");
      return Future.error("Network Error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

Future fetchWishlist(String shopId) async {
  try {
    Map params = {"shop_id": shopId};
    var response = await http.post(Uri.parse(baseUrl + wishlist), body: params);
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

Future deleteFromWishlist(String wishlistId) async {
  Map params = {"wishlist_id": wishlistId};
  var response =
      await http.post(Uri.parse(baseUrl + wishlistDelete), body: params);
  if (response.statusCode == 200) {
    // print(response.body);
    return await jsonDecode(response.body);
  } else {
    return Future.error("Network error");
  }
}

Future fetchSubcategory(String subcategoryId) async {
  try {
    Map params = {"subcategory_id": subcategoryId};
    var response =
        await http.post(Uri.parse(baseUrl + subcategoryList), body: params);
    if (response.statusCode == 200) {
      //  print(response.statusCode);
      //  print(response.body);
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

Future checkWishlist(String productId, int type) async {
  try {
    Map<String, String> params = {
      "shop_id": savedShopId,
      "prod_id": productId,
      "type": jsonEncode(type),
    };
    var response =
        await http.post(Uri.parse(baseUrl + "check_wishlist"), body: params);
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

// Future loginConfirmation(String mobileNo, String password) async {
//   try {
//     Map params = {"mobile": mobileNo, "password": password};
//     var response = await http.post(Uri.parse(loginUrl), body: params);
//     if (response.statusCode == 200) {

//       return await jsonDecode(response.body);
//     } else {
//       return Future.error("Network error");
//     }
//   } on SocketException {
//     return "Socket error";
//   } catch (e) {
//   return e;
//   }
// }

Future offerwallDetails(String productId, String categoryId) async {
  Map params = {"product_id ": productId, "category_id": categoryId};
  var response =
      await http.post(Uri.parse(baseUrl + offerWallClick), body: params);
  if (response.statusCode == 200) {
    // print("offerwallDetails");
    // print(response.body);
    return await jsonDecode(response.body);
  } else {
    return Future.error("Network error");
  }
}

Future orders(
    String shopId,
    String totalCount,
    String subtotal,
    String deliveryCharge,
    String amountPayed,
    String tax,
    List orderDetails) async {
  Map params = {
    "shop_id": shopId,
    "total_items": totalCount,
    "subtotal": subtotal,
    "delivery_charge": deliveryCharge,
    "amount_payed": amountPayed,
    "tax": tax,
    "order_details": jsonEncode(orderDetails),
  };
  try {
    var response = await http.post(Uri.parse(baseUrl + orderUrl), body: params);
    if (response.statusCode == 200) {
      // print("order");
      // print(response.body);
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

Future myOrdersList(String shopId) async {
  try {
    Map params = {"shop_id": shopId};
    var response =
        await http.post(Uri.parse(baseUrl + urlMyOrders), body: params);
    if (response.statusCode == 200) {
      // print("myordersList");
      // print(response.body);
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

Future orderDetails(String orderId) async {
  try {
    Map params = {"order_id": orderId};
    var response =
        await http.post(Uri.parse(baseUrl + urlMyOrderDetails), body: params);
    if (response.statusCode == 200) {
      // print("myordersDetails");
      // print(response.body);
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

Future fetchOfferWallDetails(String type, String productOrCategory) async {
  try {
    Map params = {"type": type, "product_or_category": productOrCategory};
    var response =
        await http.post(Uri.parse(baseUrl + urlOfferWallDetails), body: params);
    if (response.statusCode == 200) {
      // print("urlOfferWallDetails");
      // print(response.body);
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

// Future fetchSearchData(String keyword,List)

Future fetchSearchData(
    String keyword, List category, List brands, String min, String max) async {
  try {
    Map params = {
      "keyword": keyword,
      "category": category.toString(),
      "brand": brands.toString(),
      "minPrice": min,
      "maxPrice": max
    };
    var response =
        await http.post(Uri.parse(baseUrl + searchUrl), body: params);
    // log(response.body);

    if (response.statusCode == 200) {
      var result = await jsonDecode(response.body);
      return result ?? [];
    } else {
      return Future.error("bad response");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

Future fetchUserDetails(String shopId) async {
  try {
    Map params = {
      "shop_id": shopId,
    };
    var response =
        await http.post(Uri.parse(baseUrl + userDetailsUrl), body: params);
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}

Future fetchSearchSuggestion(String keyword) async {
  try {
    Map params = {
      "keyword": keyword,
    };
    var response =
        await http.post(Uri.parse(baseUrl + suggestionUrl), body: params);
    if (response.statusCode == 200) {
      Map result = await jsonDecode(response.body);
      List category = result["category"];
      List subCategory = result["subcategory"];
      List product = result["product"];

      List allResult = [];
      for (int i = 0; i < category.length; i++) {
        Map item = {
          "id": category[i]["category_id"],
          "name": category[i]["category_name"],
          "type": "category",
        };
        allResult.add(item);
      }
      for (int i = 0; i < subCategory.length; i++) {
        Map item = {
          "id": subCategory[i]["subcategory_id"],
          "name": subCategory[i]["subcategory_name"],
          "type": "sub",
        };
        allResult.add(item);
      }
      for (int i = 0; i < product.length; i++) {
        Map item = {
          "id": product[i]["product_id"],
          "name": product[i]["product_name"],
          "type": "product",
        };
        allResult.add(item);
      }

      // log(allResult.toString());

      return allResult;
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return e;
  }
}

Future fetchTopSelling() async {
  try {
    var response = await http.post(
      Uri.parse(baseUrl + topProductsUrl),
    );
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return e;
  }
}

Future fetchBrandDetails(String brandId) async {
  try {
    Map params = {"brand_id": brandId};
    var response =
        await http.post(Uri.parse(baseUrl + brandProductsUrl), body: params);
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return e;
  }
}

Future fetchBanner() async {
  try {
    var response = await http.post(
      Uri.parse(baseUrl + bannerUrl),
    );
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return e;
  }
}

Future fetchFilterData() async {
  try {
    var response = await http.post(
      Uri.parse(filterDataUrl),
    );
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return e;
  }
}

//send fcm to server

Future saveFCMTokentoServer(String userId) async {
  try {
    if (userId.isNotEmpty && userId != '0') {
      var sharedPreferences = await SharedPreferences.getInstance();
      String savedFCM = sharedPreferences.getString('fcm_token') ?? '';
      log(savedFCM);

      if (savedFCM.isEmpty) {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        String fcmToken = await messaging.getToken() ?? '';
        if (fcmToken.isNotEmpty) {
          Map params = {'shop_id': userId, 'fcm_token': fcmToken};
          log(fcmToken);
          var response = await http.post(Uri.parse(baseUrl + saveFcmTokenUrl),
              body: params);
          if (response.statusCode == 200) {
            var result = await jsonDecode(response.body);

            if (result == true) {
              saveFCMToken(fcmToken);
            }
            // print('fcm res server ' + result.toString());
          }
        }
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

//fcm locally
void saveFCMToken(var fcmToken) async {
  debugPrint('FCM Saved');
  var sharedPreferences = await SharedPreferences.getInstance();
  String savedFCM = sharedPreferences.getString('fcm_token') ?? '';
  if (savedFCM.isEmpty) {
    sharedPreferences.setString('fcm_token', fcmToken);
  }
}

Future uploadShopImage(String image, String shopId) async {
  try {
    var params = {'image': image, 'shop_id': shopId};
    var response =
        await http.post(Uri.parse(baseUrl + shopImageUpdateUrl), body: params);
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket exception");
  } catch (e) {
    return Future.error(e);
  }
}

Future forgotPassword(
  String number,
) async {
  try {
    var params = {
      'number': number,
    };
    var response = await http.post(
        Uri.parse(
          baseUrl + forgotpasswordUrl,
        ),
        body: params);
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket exception");
  } catch (e) {
    return Future.error(e);
  }
}

Future changePassword(String shopId, String password) async {
  try {
    var params = {'shop_id': shopId, 'password': password};
    var response = await http.post(
        Uri.parse(
          baseUrl + changetpasswordUrl,
        ),
        body: params);
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return Future.error("Network error");
    }
  } on SocketException {
    return Future.error("Socket exception");
  } catch (e) {
    return Future.error(e);
  }
}
