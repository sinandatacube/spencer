import 'package:flutter/material.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/loading_animation.dart';
import 'package:spencer/widgets/search_card.dart';

class BrandList extends StatelessWidget {
  final String brandName;
  final String brandId;
  const BrandList({Key? key, required this.brandName, required this.brandId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(width, height, context),
    );
  }

  ///////////////////////////////////////////////// Appbar ///////////////////////////////////////////////////////////
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(brandName),
    );
  }

  ////////////////////////////////////////////////// body ////////////////////////////////////////////////////////////
  Widget _buildBody(double width, double height, BuildContext context) {
    return FutureBuilder(
      future: fetchBrandDetails(brandId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          // print(data);

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.01),
            child: GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.7,
                  crossAxisCount: 2,
                  // crossAxisSpacing: width * 0.01,
                  // mainAxisSpacing: height * 0.01
                ),
                itemBuilder: (context, index) {
                  return SearchCard(
                      productStatus: data[index]["product_status"],
                      imgUrl:
                          productDetailsImage + data[index]["product_image"],
                      title: data[index]["product_name"],
                      productId: data[index]["product_id"],
                      wprice: data[index]["w_rate"]);
                }),
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
      },
    );
  }
}
