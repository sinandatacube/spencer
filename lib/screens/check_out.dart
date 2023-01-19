import 'package:flutter/material.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/submit_order.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/checkout_tile.dart';
import '../utilities/global_variables.dart';

class CheckOut extends StatelessWidget {
  final String tot;

  const CheckOut({Key? key, required this.tot}) : super(key: key);
  // String deliveryCharge = "0";
  // String amountPayed = "0";
  // String tax = "700";
  // List orderDetails = [];

  @override
  Widget build(BuildContext context) {
    // log("cartog${ cartItems}");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("Checkout"),
        ),
        body: _buildBody(width, height),
        bottomNavigationBar: _buildBottomNavigation(context, height, width));
  }

  ////////////////////////////////////////////////////////////////body/////////////////////////////////////////////
  Widget _buildBody(double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.01, vertical: height * 0.01),
      child: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            var current = cartItems[index];
            double productTot = 0;
            productTot = double.parse(current["w_rate"]) * qty[index];
            return CheckOutTile(
              price: current["w_rate"],
              productName: current["product_name"],
              quantity: qty[index].toString(),
              subtotal: productTot.toStringAsFixed(2),
              imgUrl: productListImage + current["product_image"],
            );
          }),
    );
  }

  ////////////////////////////////////////////////////bottomNavigation/////////////////////////////////////////////////
  Widget _buildBottomNavigation(
      BuildContext context, double height, double width) {
    return Container(
      height: height * 0.1,
      width: width,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      child: Row(
        children: [
          Expanded(
            child: Container(
                height: height * 0.09,
                // width: width * 0.55,
                alignment: Alignment.center,
                // padding: EdgeInsets.only(left: width*0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Amount ',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    RichText(
                        text: TextSpan(
                            text: "AED ",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red.shade800),
                            children: <TextSpan>[
                          TextSpan(
                            text: tot,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade800),
                          ),
                          TextSpan(
                            text: "  +5% VAT",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                          )
                        ])),
                  ],
                )),
          ),
          Container(
            height: height * 0.05,
            width: width * 0.4,
            margin: EdgeInsets.only(right: width * 0.02),
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(5)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              onPressed: () async {
                // orderDetails.clear();
                // checking shopId is null or not
                if (savedShopId.isEmpty || savedShopId == "0") {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "ERR-076, please try again later",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red.shade700,
                  ));
                  return;
                }

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SubmitOrder(
                          tot: tot,
                        )));
              },
              child: Text(
                "Confirm",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
