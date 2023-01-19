import 'package:flutter/material.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/order_success.dart';
import 'package:spencer/screens/order_failed.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/widgets/loading_animation.dart';

class SubmitOrder extends StatelessWidget {
  final String tot;

  SubmitOrder({Key? key, required this.tot}) : super(key: key);
  List orderDetails = [];
  DB database = DB();
  @override
  Widget build(BuildContext context) {
    orderDetails.clear();

    for (int i = 0; i < cartItems.length; i++) {
      var productSub = qty[i] * double.parse(cartItems[i]["w_rate"]);
      Map product = {
        "product_id": cartItems[i]["product_id"],
        "price": cartItems[i]["w_rate"],
        "qty": qty[i],
        "product_subtotal": productSub,
        "brand_id": cartItems[i]["brand"]
      };
      orderDetails.add(product);
    }
    return Scaffold(
      body: FutureBuilder(
        future: orders(savedShopId, cartItems.length.toString(), tot, "0", tot,
            "0", orderDetails),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var result = snapshot.data;
            if (result["status"] == "success") {
              database.clearData();
              return const OrderSuccess();
            } else {
              return const OrderFailed();
            }
          } else if (snapshot.hasError) {
            var error = snapshot.error;
            if (error == "Socket exception") {
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
