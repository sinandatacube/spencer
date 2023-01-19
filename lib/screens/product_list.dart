import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/screens/cart.dart';
import 'package:spencer/screens/search.dart';
import 'package:spencer/states/cart_counter.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/search_card.dart';

class ProductList extends StatelessWidget {
  final List productDetails;
  ProductList({Key? key, required this.productDetails}) : super(key: key);

  DB database = DB();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // print(productDetails);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(context, height, width),
      body: _buildBody(height, width, productDetails, context),
    );
  }

  ////////////////////////////////////////////////// appBar ///////////////////////////////////////////
  AppBar _buildAppBar(BuildContext context, double height, double width) {
    return AppBar(actions: [
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
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Cart()));
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                )),
            Positioned(
              right: width * 0.007,
              top: height * 0.006,
              child: Consumer(
                builder: (context, ref, child) {
                  // final count2 = ref.watch(counterProvider);
                  // Future.delayed(const Duration(milliseconds: 100), () async {
                  //   var count = await database.cartCount();
                  //   int co = count[0]["COUNT(*)"];
                  //   final calc = ref.read(counterProvider.notifier);
                  //   calc.cartItemCount(co);
                  // });
                  // final count2=1;
                  var instance = Provider.of<CartCounter>(context);
                  if (instance.count == 0) {
                    return const SizedBox();
                  } else {
                    return Container(
                      // height: height * 0.036,
                      width: width * 0.046,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.002,
                        vertical: height * 0.001,
                      ),
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
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  ////////////////////////////////////////////////////////// body /////////////////////////////////////////
  Widget _buildBody(
      double height, double width, List productDetails, BuildContext context) {
    if (productDetails.isEmpty) {
      return noDataFound(context);
      //  SizedBox(
      //   height: double.maxFinite,
      //   width: double.maxFinite,
      //   child: Center(
      //     child: Text(
      //       "No Items",
      //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.7,
            crossAxisCount: 2,
            // crossAxisSpacing: width * 0.0,
            // mainAxisSpacing: height * 0.0,
          ),
          itemCount: productDetails.length,
          itemBuilder: (context, index) {
            return SearchCard(
                productStatus: productDetails[index]["product_status"],
                imgUrl: productDetailsImage +
                    productDetails[index]["product_image"],
                title: productDetails[index]["product_name"],
                productId: productDetails[index]["product_id"],
                wprice: productDetails[index]["w_rate"]);
          },
        ),
      );
    }
  }
}
