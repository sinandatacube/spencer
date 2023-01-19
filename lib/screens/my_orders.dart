import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/empty_myorders.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/orders_details.dart';
import 'package:spencer/screens/skipped_login_alert.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/widgets/loading_animation.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (isSkip) {
      return const SkippedLoginAlert();
    } else {
      return FutureBuilder(
        future: myOrdersList(savedShopId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data["orders"];
            if (data.isEmpty) {
              return const EmptyMyOrders();
            } else {
              return Scaffold(
                  backgroundColor: Colors.grey.shade100,
                  appBar: AppBar(
                    title: const Text("My Orders"),
                  ),
                  body: _buildBody(height, width, data));
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

  ///////////////////////////////////////////////////////body////////////////////////////////////////
  Widget _buildBody(double height, double width, List data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    OrderDetails(orderId: data[index]["order_id"])));
          },
          child: Container(
            alignment: Alignment.center,
            height: height * 0.13,
            width: width,
            margin: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.005),
            decoration: const BoxDecoration(color: Colors.white),
            child: ListTile(
              isThreeLine: true,
              title: Text("Order id :" + data[index]["order_id"],
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600)),
              subtitle: Text(
                  "Order date    : " +
                      DateFormat.yMMMd()
                          .format(DateTime.parse(data[index]["order_date"])) +
                      "\nOrder status : " +
                      data[index]["order_status"],
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black87)),
            ),
          ),
        );
      },
    );
  }
}
