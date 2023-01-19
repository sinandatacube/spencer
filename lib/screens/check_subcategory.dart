import 'package:flutter/material.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/product_list.dart';
import 'package:spencer/screens/subcategories.dart';
import 'package:spencer/widgets/loading_animation.dart';

class CheckSubCategory extends StatelessWidget {
  final String cagetogoryId;
  const CheckSubCategory({Key? key, required this.cagetogoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkSubcategory(cagetogoryId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.containsKey("subcategory")) {
              // print(snapshot.data);
              return SubCategories(
                subCategoryList: snapshot.data["subcategory"],
              );
            } else {
              //  print(snapshot.data);
              // print(snapshot.data["product"]);
              return ProductList(productDetails: snapshot.data["product"]);
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
      ),
    );
  }
}
