// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:spencer/db_service/db_functions.dart';
// import 'package:spencer/screens/bulk_subcatory_list.dart';
// import 'package:spencer/states/bulk_quantity_provider.dart';
// import 'package:spencer/utilities/global_variables.dart';
// import 'package:spencer/widgets/bulk_subcategory_tile.dart';

// class MiniSearch extends SearchDelegate {
//   final String subcategoryId;

//   final List data;
//   MiniSearch({
//     required this.data,
//     required this.subcategoryId,
//   });
//   List searched = [];
//   // List _prodIds = [];
//   DB database = DB();

//   getProIds(BuildContext context) async {
//     // prodIds = await database.getProductId();
//     List temp = [];
//     context.read<BulkQuantityProvider>().clearData();

//     // prodIdss.clear();
//     temp = await database.getProductId();
//     // prodIdss.addAll(temp);
//     context.read<BulkQuantityProvider>().addData(temp);
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = "";
//         },
//       )
//     ];
//     // throw UnimplementedError();
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return const BackButton();

//     //  IconButton(
//     //   icon: AnimatedIcon(
//     //     icon: AnimatedIcons.menu_arrow,
//     //     progress: transitionAnimation,
//     //   ),
//     //   onPressed: () {

//     //     // close(context, "");
//     //   },
//     // );
//     // throw UnimplementedError();
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     query.isEmpty
//         ? searched.clear()
//         : searched = data
//             .where((element) => element["product_name"]
//                 .toLowerCase()
//                 .contains(query.toLowerCase()))
//             .toList();
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//             builder: (context) => BulkSubcategoryList(
//                   subCategoryId: subcategoryId,
//                 )));
//         return false;
//       },
//       child: Consumer(builder: (context, value, child) {
//         var instance = Provider.of<BulkQuantityProvider>(context);
//         return FutureBuilder(
//             future: getProIds(context),
//             builder: (context, AsyncSnapshot snapshot) {
//               return ListView.builder(
//                   itemCount: searched.length,
//                   itemBuilder: (context, index) {
//                     var current = searched[index];
//                     int qty = 0;
//                     for (int i = 0; i < instance.prodIdss.length; i++) {
//                       // print(productIds[i]["qantity"]);
//                       // print(current["product_id"]);
//                       // print("-------------------------");

//                       if (instance.prodIdss[i]["product_id"] ==
//                           current["product_id"]) {
//                         qty = instance.prodIdss[i]["qantity"];
//                       }
//                     }
//                     return BulkSubCategoryTile(
//                         productId: current["product_id"],
//                         max: current["max_order"],
//                         imgUrl: current["product_image"],
//                         min: current["min_order"],
//                         price: current["w_rate"],
//                         title: current["product_name"],
//                         qty: qty);
//                   });
//             });
//       }),
//     );

//     // throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     query.isEmpty
//         ? searched.clear()
//         : searched = data
//             .where((element) => element["product_name"]
//                 .toLowerCase()
//                 .contains(query.toLowerCase()))
//             .toList();

//       return FutureBuilder(
//           future: getProIds(context),
//           builder: (context, AsyncSnapshot snapshot) {
//             return searched.isEmpty
//                 ? Consumer(
//                   builder: (context,value,child) {
//                     var instance=Provider.of<BulkQuantityProvider>(context);
//                     return ListView.builder(
//                         itemCount: data.length,
//                         itemBuilder: (context, index) {
//                           var current = data[index];
//                           int qty = 0;
//                           for (int i = 0; i < instance.prodIdss.length; i++) {
//                             // print(productIds[i]["qantity"]);
//                             // print(current["product_id"]);
//                             // print("-------------------------");

//                             if (instance.prodIdss[i]["product_id"] ==
//                                 current["product_id"]) {
//                               qty = instance.prodIdss[i]["qantity"];
//                             }
//                           }
//                           return BulkSubCategoryTile(
//                               productId: current["product_id"],
//                               max: current["max_order"],
//                               imgUrl: current["product_image"],
//                               min: current["min_order"],
//                               price: current["w_rate"],
//                               title: current["product_name"],
//                               qty: qty);
//                         });
//                   }
//                 )
//                 : searched.isEmpty
//                     ? _buildNoMatch(width, height, context)
//                     : Consumer(
//                       builder: (context,value,child) {
//                         var instance=Provider.of<BulkQuantityProvider>(context);
//                         return ListView.builder(
//                             itemCount: searched.length,
//                             itemBuilder: (context, index) {
//                               var current = searched[index];
//                               int qty = 0;
//                               for (int i = 0; i < instance.prodIdss.length; i++) {
//                                 // print(productIds[i]["qantity"]);
//                                 // print(current["product_id"]);
//                                 // print("-------------------------");

//                                 if (instance.prodIdss[i]["product_id"] ==
//                                     current["product_id"]) {
//                                   qty = instance.prodIdss[i]["qantity"];
//                                 }
//                               }
//                               return BulkSubCategoryTile(
//                                   productId: current["product_id"],
//                                   max: current["max_order"],
//                                   imgUrl: current["product_image"],
//                                   min: current["min_order"],
//                                   price: current["w_rate"],
//                                   title: current["product_name"],
//                                   qty: qty);
//                             });
//                       }
//                     );
//           });

//   }
// }

// Widget _buildNoMatch(double width, double height, BuildContext context) {
//   return SizedBox(
//     width: width,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.asset(
//           "assets/images/noResultFound.png",
//           height: height * 0.13,
//         ),
//         Text("sorry!",
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge!
//                 .copyWith(fontWeight: FontWeight.w600)),
//         Text("No result found",
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge!
//                 .copyWith(fontWeight: FontWeight.w600)),
//       ],
//     ),
//   );
// }
