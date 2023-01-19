import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/product_details.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/checkout_tile.dart';
import 'package:spencer/widgets/loading_animation.dart';
import 'package:shimmer/shimmer.dart';
import '../api/api.dart';

class OrderDetails extends StatelessWidget {
  final String orderId;
  const OrderDetails({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: orderDetails(orderId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var order = snapshot.data["order"];
            // var orderDetails = snapshot.data["order"]["details"];
            return OrderDetailsBody(orderDetails: order);
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

class OrderDetailsBody extends StatelessWidget {
  final Map orderDetails;
  const OrderDetailsBody({Key? key, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("details");
    // print(orderDetails);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: _buildBody(width, height),
      bottomNavigationBar: _buildBottomNavigation(height, width, context),
    );
  }

  ////////////////////////////////////////////////////////body///////////////////////////////////////////////
  Widget _buildBody(double width, double height) {
    return ListView.builder(
      itemCount: orderDetails["details"].length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: fetchProductDetails(
            orderDetails["details"][index]["product"],
          ),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // print("product details");
              // print(snapshot.data["details"]);
              // var current = snapshot.data["details"][index];
              // print("current");
              // print(snapshot.data["details"]);
              // print(details["details"][index]);
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Product(
                      productId: snapshot.data["details"]["product_id"],
                    ),
                  ));
                },
                child: CheckOutTile(
                  price: snapshot.data["details"]["w_rate"],
                  productName: snapshot.data["details"]["product_name"],
                  quantity: orderDetails["details"][index]["qty"],
                  subtotal: orderDetails["details"][index]["product_subtotal"],
                  imgUrl: productDetailsImage +
                      snapshot.data["details"]["product_image"],
                ),
              );
            } else if (snapshot.hasError) {
              var error = snapshot.error;
              if (error == "Socket error") {
                return const NoNetwork();
              } else {
                return const ErrorPage();
              }
            } else {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade400,
                period: const Duration(milliseconds: 1500),
                direction: ShimmerDirection.ltr,
                loop: 2,
                child: Container(
                  height: height * 0.13,
                  width: width,
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.01),
                  color: Colors.grey,
                ),
              );
            }
          },
        );
      },
    );
  }

  ///////////////////////////////////////////////////////////////bottomNavigationBar//////////////////////////////////////
  Widget _buildBottomNavigation(
      double height, double width, BuildContext context) {
    return Container(
      height: height * 0.3,
      width: width,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: height * 0.01),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.05,
            child: ListTile(
              leading: Text("Order id",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600)),
              trailing: Text(orderDetails["order_id"],
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(
            height: height * 0.05,
            child: ListTile(
              leading: Text("Order date",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600)),
              trailing: Text(
                  DateFormat.yMMMd().format(DateTime.parse(
                    orderDetails["order_date"],
                  )),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(
            height: height * 0.05,
            child: ListTile(
              leading: Text("Number of items",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600)),
              trailing: Text(orderDetails["ordered_products_count"],
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(
            height: height * 0.05,
            child: ListTile(
              leading: Text("Total amount",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600)),
              trailing: RichText(
                text: TextSpan(
                  text: 'AED ',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontWeight: FontWeight.w600),
                  children: <TextSpan>[
                    TextSpan(
                        // text: total.toString(),
                        text: orderDetails["subtotal"],
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.05,
            child: ListTile(
              leading: Text("Status",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600)),
              trailing: Text(orderDetails["order_status"],
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
