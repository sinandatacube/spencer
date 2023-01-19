import 'package:flutter/material.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/widgets/loading_animation.dart';
import 'package:spencer/widgets/range_slider.dart';

// class Filter extends StatefulWidget {
//   const Filter({Key? key}) : super(key: key);

//   @override
//   State<Filter> createState() => _FilterState();
// }

// class _FilterState extends State<Filter> {
//   bool selected = false;
//     List tempBrands = [];
//     List tempCategories = [];

//   @override
//   void initState() {
//     tempBrands = filterBrands;
//     tempCategories = filterCategories;
//    tempMin=min;
//       tempMax=max;
//     super.initState();
//   }
//   @override

//   Widget build(BuildContext context) {

//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: width * 0.03, vertical: height * 0.02),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Price Range",
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium!
//                     .copyWith(fontWeight: FontWeight.bold),
//               ),

//             ],
//           ),
//         ),
//          RangsSliders(start: tempMin,end: tempMax,),
//         Expanded(
//           child: FutureBuilder(
//             future: fetchFilterData(),
//             builder: (context, AsyncSnapshot snapshot) {
//               if (snapshot.hasData) {
//                 var categories = snapshot.data["category"];
//                 var brands = snapshot.data["brand"];
//                 return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(
//                             left: width * 0.03, top: height * 0.01),
//                         child: Text(
//                           "Brand",
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       SizedBox(
//                           height: height * 0.09,
//                           width: width,
//                           child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: brands.length,
//                               itemBuilder: (context, index) {
//                                 if (tempBrands.contains(
//                                   brands[index]["brand_id"],
//                                 )) {
//                                   selected = true;
//                                 } else {
//                                   selected = false;
//                                 }
//                                 return Padding(
//                                   padding: EdgeInsets.only(left: width * 0.02),
//                                   child: FilterChip(
//                                     label: Text(brands[index]["brand_name"]),
//                                     onSelected: (val) {
//                                       if (tempBrands.contains(
//                                           brands[index]["brand_id"])) {
//                                         tempBrands
//                                             .remove(brands[index]["brand_id"]);
//                                       } else {
//                                         tempBrands
//                                             .add(brands[index]["brand_id"]);
//                                       }

//                                       setState(() {});
//                                     },
//                                     selected: selected,
//                                     backgroundColor: Colors.white54,
//                                     selectedColor: Colors.yellow.shade400,
//                                     elevation: 2,
//                                   ),
//                                 );
//                               })),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             left: width * 0.03, top: height * 0.01),
//                         child: Text(
//                           "Category",
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       SizedBox(
//                           height: height * 0.09,
//                           width: width,
//                           // color: Colors.grey.shade200,
//                           child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: categories.length,
//                               itemBuilder: (context, index) {
//                                 if (tempCategories.contains(
//                                     categories[index]["category_id"])) {
//                                   selected = true;
//                                 } else {
//                                   selected = false;
//                                 }
//                                 return Padding(
//                                     padding:
//                                         EdgeInsets.only(left: width * 0.02),
//                                     child: FilterChip(
//                                       label: Text(
//                                         categories[index]["category_name"],
//                                       ),
//                                       onSelected: (val) {
//                                         if (tempCategories.contains(
//                                           categories[index]["category_id"],
//                                         )) {
//                                           tempCategories.remove(
//                                             categories[index]["category_id"],
//                                           );
//                                         } else {
//                                           tempCategories.add(
//                                             categories[index]["category_id"],
//                                           );
//                                         }
//                                         selected = !selected;

//                                         setState(() {});
//                                       },
//                                       selected: selected,
//                                       backgroundColor: Colors.white54,
//                                       selectedColor: Colors.yellow.shade400,
//                                       elevation: 2,
//                                     ));
//                               })),
//                       Expanded(
//                           child: Center(
//                         child: SizedBox(
//                           height: height * 0.05,
//                           width: width * 0.28,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               primary: Color(0xff2e5266),
//                             ),
//                             onPressed: () {
//                               // filterBrands=tempBrands;
//                               // filterCategories=tempCategories;
//                               min=tempMin;
//                               max=tempMax;
//                               print(tempBrands);
//                               print(tempCategories);
//                               print(filterBrands);
//                               print(filterCategories);
//                               // Navigator.of(context).pop();
//                             },
//                             child: Text(
//                               "Confirm",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleSmall!
//                                   .copyWith(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w700),
//                             ),
//                           ),
//                         ),
//                       ))
//                     ]);
//               } else {
//                 return const SizedBox();
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class Filter extends StatefulWidget {
//   Filter({Key? key}) : super(key: key);

//   @override
//   State<Filter> createState() => _FilterState();
// }

// class _FilterState extends State<Filter> {
//   bool selected = false;

//   List tempBrands = [];

//   List tempCategories = [];
//  @override
//   void initState() {
//     tempBrands = filterBrands;
//     tempCategories = filterCategories;
//    tempMin=min;
//       tempMax=max;
//       print("rebuildinit");
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//       print("rebuild");
//            print("tempBrands");
//                               print(tempBrands);
//                               print("tempCategories");
//                               print(tempCategories);
//                               print("filterBrands");
//                               print(filterBrands);
//                               print("filterCategories");
//                               print(filterCategories);

//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: width * 0.03, vertical: height * 0.02),
//           child: Text(
//             "Price Range",
//             style: Theme.of(context)
//                 .textTheme
//                 .titleMedium!
//                 .copyWith(fontWeight: FontWeight.bold),
//           ),
//         ),
//         RangsSliders(start: tempMin,end: tempMax,),
//         Expanded(child:
//         FutureBuilder(
//           future: fetchFilterData(),
//           builder: (context,AsyncSnapshot snapshot){
//             if(snapshot.hasData){
//               var categories=snapshot.data["category"];
//               var brands=snapshot.data["brand"];
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
//                 children: [
//                         Padding(
//                         padding: EdgeInsets.only(
//                             left: width * 0.03, top: height * 0.01),
//                         child: Text(
//                           "Brand",
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                        SizedBox(
//                           height: height * 0.09,
//                           width: width,
//                           child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: brands.length,
//                               itemBuilder: (context, index) {
//                                 if (tempBrands.contains(
//                                   brands[index]["brand_id"],
//                                 )) {
//                                   selected = true;
//                                 } else {
//                                   selected = false;
//                                 }
//                                 return Padding(
//                                   padding: EdgeInsets.only(left: width * 0.02),
//                                   child: FilterChip(
//                                     label: Text(brands[index]["brand_name"]),
//                                     onSelected: (val) {
//                                       if (tempBrands.contains(
//                                           brands[index]["brand_id"])) {
//                                         tempBrands
//                                             .remove(brands[index]["brand_id"]);
//                                       } else {
//                                         tempBrands
//                                             .add(brands[index]["brand_id"]);
//                                       }

//                                       setState(() {});
//                                     },
//                                     selected: selected,
//                                     backgroundColor: Colors.white54,
//                                     selectedColor: Colors.yellow.shade400,
//                                     elevation: 2,
//                                   ),
//                                 );
//                               })),
//                                Padding(
//                         padding: EdgeInsets.only(
//                             left: width * 0.03, top: height * 0.01),
//                         child: Text(
//                           "Category",
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                                SizedBox(
//                           height: height * 0.09,
//                           width: width,
//                           // color: Colors.grey.shade200,
//                           child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: categories.length,
//                               itemBuilder: (context, index) {
//                                 if (tempCategories.contains(
//                                     categories[index]["category_id"])) {
//                                   selected = true;
//                                 } else {
//                                   selected = false;
//                                 }
//                                 return Padding(
//                                     padding:
//                                         EdgeInsets.only(left: width * 0.02),
//                                     child: FilterChip(
//                                       label: Text(
//                                         categories[index]["category_name"],
//                                       ),
//                                       onSelected: (val) {
//                                         if (tempCategories.contains(
//                                           categories[index]["category_id"],
//                                         )) {
//                                           tempCategories.remove(
//                                             categories[index]["category_id"],
//                                           );
//                                         } else {
//                                           tempCategories.add(
//                                             categories[index]["category_id"],
//                                           );
//                                         }
//                                         selected = !selected;

//                                         setState(() {});
//                                       },
//                                       selected: selected,
//                                       backgroundColor: Colors.white54,
//                                       selectedColor: Colors.yellow.shade400,
//                                       elevation: 2,
//                                     ));
//                               })),
//                                 Expanded(
//                           child: Center(
//                         child: SizedBox(
//                           height: height * 0.05,
//                           width: width * 0.28,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               primary: Color(0xff2e5266),
//                             ),
//                             onPressed: () {
//                               filterBrands=tempBrands;
//                               filterCategories=tempCategories;
//                               min=tempMin;
//                               max=tempMax;

//                               Navigator.of(context).pop();
//                             },
//                             child: Text(
//                               "Confirm",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleSmall!
//                                   .copyWith(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w700),
//                             ),
//                           ),
//                         ),
//                       ))
//                 ],
//               );
//             }else{
//               return SizedBox();
//             }
//           },
//         )
//         )
//       ],
//     );
//   }
// }

class Filter extends StatelessWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFilterData(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var categories = snapshot.data["category"];
          var brands = snapshot.data["brand"];
          return FilterBody(
            categories: categories,
            brands: brands,
            selectedBrands: filterBrands,
            selectedCategories: filterCategory,
          );
        } else if (snapshot.hasError) {
          var error = snapshot.error;
          if (error == "Socket error") {
            return const NoNetwork();
          } else {
            return const ErrorPage();
          }
        } else {
          return const LoadingAnimation2();
        }
      },
    );
  }
}

class FilterBody extends StatefulWidget {
  final List categories;
  final List brands;
  final List selectedBrands;
  final List selectedCategories;
  const FilterBody(
      {Key? key,
      required this.brands,
      required this.categories,
      required this.selectedBrands,
      required this.selectedCategories})
      : super(key: key);

  @override
  State<FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends State<FilterBody> {
  bool selected = false;
  List tempBrands = [];
  List tempCategories = [];
  @override
  void initState() {
    tempBrands.addAll(widget.selectedBrands);
    tempCategories.addAll(widget.selectedCategories);
    tempMin = min;
    tempMax = max;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.02),
          child: Text(
            "Price Range",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: height * 0.22,
          child: RangsSliders(
            start: tempMin,
            end: tempMax,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: width * 0.03, top: height * 0.01),
          child: Text(
            "Brand",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
            height: height * 0.09,
            width: width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.brands.length,
                itemBuilder: (context, index) {
                  if (tempBrands.contains(
                    widget.brands[index]["brand_id"],
                  )) {
                    selected = true;
                  } else {
                    selected = false;
                  }
                  return Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: FilterChip(
                      label: Text(widget.brands[index]["brand_name"]),
                      onSelected: (val) {
                        if (tempBrands
                            .contains(widget.brands[index]["brand_id"])) {
                          tempBrands.remove(widget.brands[index]["brand_id"]);
                        } else {
                          tempBrands.add(widget.brands[index]["brand_id"]);
                        }

                        setState(() {});
                      },
                      selected: selected,
                      backgroundColor: Colors.white54,
                      selectedColor: Colors.yellow.shade400,
                      elevation: 2,
                    ),
                  );
                })),
        Padding(
          padding: EdgeInsets.only(left: width * 0.03, top: height * 0.01),
          child: Text(
            "Category",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
            height: height * 0.09,
            width: width,
            // color: Colors.grey.shade200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categories.length,
                itemBuilder: (context, index) {
                  if (tempCategories
                      .contains(widget.categories[index]["category_id"])) {
                    selected = true;
                  } else {
                    selected = false;
                  }
                  return Padding(
                      padding: EdgeInsets.only(left: width * 0.02),
                      child: FilterChip(
                        label: Text(
                          widget.categories[index]["category_name"],
                        ),
                        onSelected: (val) {
                          if (tempCategories.contains(
                            widget.categories[index]["category_id"],
                          )) {
                            tempCategories.remove(
                              widget.categories[index]["category_id"],
                            );
                          } else {
                            tempCategories.add(
                              widget.categories[index]["category_id"],
                            );
                          }
                          selected = !selected;

                          setState(() {});
                        },
                        selected: selected,
                        backgroundColor: Colors.white54,
                        selectedColor: Colors.yellow.shade400,
                        elevation: 2,
                      ));
                })),
        Expanded(
            child: Center(
          child: SizedBox(
            height: height * 0.06,
            width: width * 0.3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2e5266),
              ),
              onPressed: () {
                filterBrands.clear();
                filterBrands.addAll(tempBrands);
                filterCategory.clear();
                filterCategory.addAll(tempCategories);
                min = tempMin;
                max = tempMax;

                Navigator.of(context).pop();
              },
              child: Text(
                "Confirm",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ))
      ],
    );
  }
}
