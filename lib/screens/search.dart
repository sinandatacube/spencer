//search utilities

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/product_details.dart';
import 'package:spencer/states/bulk_provider.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/bulk_subcategory_tile.dart';
import 'package:spencer/widgets/filter.dart';
import 'package:spencer/widgets/loading_animation.dart';
import 'package:spencer/widgets/search_card.dart';
import 'package:spencer/widgets/sort.dart';
import '../utilities/global_variables.dart';

class TheSearch extends SearchDelegate<String> {
  TheSearch({
    this.contextPage,
  });

  BuildContext? contextPage;

  @override
  String get searchFieldLabel => "Search products";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    recentSearch = suggestion;
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    getProIds(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    query.trim().isNotEmpty ? saveRecentSearch(query.trim()) : null;

    // result = data2
    //     .where((element) => element.toLowerCase().contains(query.toLowerCase()))
    //     .toList();
    return query.trim().length > 1
        ? FutureBuilder(
            future: fetchSearchData(query.trim(), filterCategory, filterBrands,
                min.toString(), max.toString()),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == "empty") {
                  return buildNoMatch(width, height, context);
                } else {
                  sort = snapshot.data;

                  // sorting data
                  if (sortType == "lowToHigh") {
                    sort.sort((a, b) => (double.tryParse(a['w_rate']) ?? 0.0)
                        .compareTo(double.parse(b['w_rate'])));
                  } else if (sortType == "highToLow") {
                    sort.sort((a, b) => double.parse(b['w_rate'])
                        .compareTo(double.parse(a['w_rate'])));
                  } else if (sortType == "aToz") {
                    sort.sort((a, b) => a['product_name']
                        .toLowerCase()
                        .compareTo(b['product_name'].toLowerCase()));
                  } else if (sortType == "ztoa") {
                    sort.sort((a, b) => b['product_name']
                        .toLowerCase()
                        .compareTo(a['product_name'].toLowerCase()));
                  }

                  return Scaffold(
                    body: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.01, vertical: height * 0.01),
                      child: sort[0]["bulk"] == "1"
                          ? Consumer(builder: (context, value, child) {
                              var instance = Provider.of<BulkProvider>(context);
                              return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: sort.length,
                                  itemBuilder: (context, index) {
                                    var current = sort[index];
                                    // print(
                                    //   current["max_order"],
                                    // );
                                    // print(
                                    //   current["min_order"],
                                    // );

                                    int qty = 0;
                                    try {
                                      qty = instance.prodIdsss[instance
                                              .prodIdsss
                                              .indexWhere((element) =>
                                                  element["product_id"] ==
                                                  current["product_id"])]
                                          ["qantity"];
                                    } catch (e) {
                                      qty = 0;
                                    }
                                    return BulkSubCategoryTile(
                                        productStatus:
                                            current["product_status"],
                                        productId: current["product_id"],
                                        max: current["max_order"],
                                        imgUrl: current["product_image"],
                                        min: current["min_order"],
                                        price: current["w_rate"],
                                        title: current["product_name"],
                                        qty: qty);
                                  });
                            })
                          : GridView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.7,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: width * 0.00,
                                      mainAxisSpacing: height * 0.0),
                              itemCount: sort.length,
                              itemBuilder: (context, index) {
                                var current = sort[index];

                                return SearchCard(
                                  productStatus: current["product_status"],
                                  imgUrl: productDetailsImage +
                                      current["product_image"],
                                  title: current["product_name"],
                                  productId: current["product_id"],
                                  wprice: current["w_rate"],
                                );
                              }),
                    ),
                  );
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
          )
        : buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List suggest =
        suggestion.where((element) => element.startsWith(query)).toList();
    final suggestions = query.isEmpty ? recentSearch : suggest;
    // print("suggestions");
    // print(suggestions);
    return Column(
      children: [
        _buildBottomNavigation(height, width, context),
        Expanded(
          child: query.trim().length > 1
              ? FutureBuilder(
                  future: fetchSearchSuggestion(query.trim()),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, index) {
                          Map current = snapshot.data[index];
                          return ListTile(
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            onTap: () {
                              if (current["type"] == "product") {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Product(
                                      productId: current["id"],
                                    ),
                                  ),
                                );
                              } else {
                                query = current["name"];
                                showResults(context);
                              }

                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => Product(
                              //         productId: product[index]
                              //             ["product_id"])));
                            },
                            leading: const Icon(Icons.search),
                            title: Text(
                              current["name"],
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // subtitle: Text(
                            //   "product",
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .bodyText1!
                            //       .copyWith(
                            //           color: Colors.grey.shade700),
                            // ),
                          );
                        },
                      );
                      // } else {
                      //   return const SizedBox();
                      // }

                      // return SingleChildScrollView(
                      //   physics: const BouncingScrollPhysics(),
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       if (category.isNotEmpty)
                      //         ListView.builder(
                      //           physics: const NeverScrollableScrollPhysics(),
                      //           shrinkWrap: true,
                      //           itemCount: category.length,
                      //           itemBuilder: (context, index) => ListTile(
                      //             visualDensity:
                      //                 VisualDensity.adaptivePlatformDensity,
                      //             onTap: () {
                      //               query = category[index]["category_name"];
                      //               showResults(context);
                      //             },
                      //             leading: const Icon(Icons.search),
                      //             title: Text(
                      //               category[index]["category_name"],
                      //               style:
                      //                   Theme.of(context).textTheme.titleMedium,
                      //               maxLines: 1,
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //             // subtitle: Text(
                      //             //   "category",
                      //             //   style: Theme.of(context)
                      //             //       .textTheme
                      //             //       .bodyText1!
                      //             //       .copyWith(
                      //             //           color: Colors.grey.shade700),
                      //             // ),
                      //           ),
                      //         ),
                      //       if (subCategory.isNotEmpty)
                      //         ListView.builder(
                      //           physics: const NeverScrollableScrollPhysics(),
                      //           shrinkWrap: true,
                      //           itemCount: subCategory.length,
                      //           itemBuilder: (context, index) => ListTile(
                      //             visualDensity:
                      //                 VisualDensity.adaptivePlatformDensity,
                      //             onTap: () {
                      //               query =
                      //                   subCategory[index]["subcategory_name"];
                      //               showResults(context);
                      //             },
                      //             leading: const Icon(Icons.search),
                      //             title: Text(
                      //               subCategory[index]["subcategory_name"],
                      //               style:
                      //                   Theme.of(context).textTheme.titleMedium,
                      //               maxLines: 1,
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //             // subtitle: Text(
                      //             //   "category",
                      //             //   style: Theme.of(context)
                      //             //       .textTheme
                      //             //       .bodyText1!
                      //             //       .copyWith(
                      //             //           color: Colors.grey.shade700),
                      //             // ),
                      //           ),
                      //         ),
                      //       if (product.isNotEmpty)
                      //         ListView.builder(
                      //           physics: const NeverScrollableScrollPhysics(),
                      //           shrinkWrap: true,
                      //           itemCount: product.length,
                      //           itemBuilder: (context, index) => ListTile(
                      //             visualDensity:
                      //                 VisualDensity.adaptivePlatformDensity,
                      //             onTap: () {
                      //               // query = product[index]["product_name"];
                      //               // showResults(context);
                      //               Navigator.of(context).push(
                      //                   MaterialPageRoute(
                      //                       builder: (context) => Product(
                      //                           productId: product[index]
                      //                               ["product_id"])));
                      //             },
                      //             leading: const Icon(Icons.search),
                      //             title: Text(
                      //               product[index]["product_name"],
                      //               style:
                      //                   Theme.of(context).textTheme.titleMedium,
                      //               maxLines: 1,
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //             // subtitle: Text(
                      //             //   "product",
                      //             //   style: Theme.of(context)
                      //             //       .textTheme
                      //             //       .bodyText1!
                      //             //       .copyWith(
                      //             //           color: Colors.grey.shade700),
                      //             // ),
                      //           ),
                      //         )
                      //     ],
                      //   ),
                      // );
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: suggestions.length,
                  itemBuilder: (content, index) => ListTile(
                    onTap: () {
                      query = suggestions[index];
                      showResults(context);
                    },
                    leading: const Icon(Icons.restore_rounded),
                    title: Text(
                      suggestions[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  /////////////////////////// bottom navigation ///////////////////////
  Widget _buildBottomNavigation(
      double height, double width, BuildContext context) {
    // bool selected=false;
    return Container(
      height: height * 0.07,
      width: width,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(
        children: [
          Container(
            // color: Color(0xFF89abe3ff),
            // color: mainColor,
            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            alignment: Alignment.center,
            width: width * 0.49,
            child: TextButton(
              onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return SizedBox(
                      height: height * 0.7,
                      child: const Filter(),
                    );
                  }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LineAwesomeIcons.filter,
                    color: Colors.black,
                  ),
                  Text(
                    "Filter",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          const VerticalDivider(
            color: Colors.black,
            width: 3,
          ),
          Container(
            alignment: Alignment.center,
            width: width * 0.49,
            // color: Color(0xFF89abe3ff),
            // color: mainColor,
            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),

            child: TextButton(
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const SizedBox(height: 300, child: Sort());
                  }).then((value) {}),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LineAwesomeIcons.sort,
                    color: Colors.black,
                  ),
                  Text(
                    "Sort",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildFilterSheet() {
  //   return Container(
  //     color: Colors.white,
  //     child: const Center(child: Text("filter")),
  //   );
  // }
  // Widget _buildSortSheet() {
  //   return Container(
  //     color: Colors.white,
  //     child: Center(child: Text("Sort")),
  //   );
  // }
}

Future<void> showSearches(BuildContext context) async {
  await showSearch(
    context: context,
    delegate: TheSearch(),
    // query: "any query",
  );
}

final _scrollController = ScrollController();
saveRecentSearch(String query) async {
  // suggestion.clear();
  final pref = await SharedPreferences.getInstance();
  Set<String> savedSearches =
      pref.getStringList("recent_search")?.toSet() ?? {};
  savedSearches = {query, ...savedSearches};
  suggestion = savedSearches.toList();
  pref.setStringList("recent_search", savedSearches.toList());
  // print("savedSearches");
  // print(savedSearches);
  // print("suggestions");
  // print(suggestion);
}

getRecentSearch() async {
  final pref = await SharedPreferences.getInstance();
  var savedsearch = pref.getStringList("recent_search")?.toSet() ?? {};
  return savedsearch;
}

Widget buildNoMatch(double width, double height, BuildContext context) {
  return SizedBox(
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/noResultFound.png",
          height: height * 0.13,
        ),
        Text("sorry!",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w600)),
        Text("No result found",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
