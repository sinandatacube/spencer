import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spencer/screens/cart.dart';
import 'package:spencer/screens/search.dart';
import 'package:spencer/states/cart_counter.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';
import 'package:spencer/widgets/subcategory_tile.dart';

class SubCategories extends StatelessWidget {
  final List subCategoryList;
  const SubCategories({
    Key? key,
    required this.subCategoryList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: _buildAppbar(height, width, context),
        body: _buildBody(height, width));
  }

/////////////////////////////////////////////////////////// body //////////////////////////////////////////
  Widget _buildBody(double height, double width) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.015),
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: subCategoryList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.82,
                    crossAxisCount: 2,
                    crossAxisSpacing: width * 0.015,
                    mainAxisSpacing: height * 0.01),
                itemBuilder: (context, index) {
                  var current = subCategoryList[index];
                  return SubCategoryTile(
                    title: current["subcategory_name"],
                    imgUrl: subCategoriesImage + current["subcategory_image"],
                    subcategoryId: current["subcategory_id"],
                    isBulk: current["bulk"],
                  );
                }),
          ),
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////// appbar //////////////////////////////////////////
  AppBar _buildAppbar(double height, double width, BuildContext context) {
    return AppBar(
      elevation: 2,
      automaticallyImplyLeading: true,
      actions: [
        SizedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                // onPressed: () => showSearches(context),
                onPressed: () {
                  min = 0;
                  max = 5000;
                  filterBrands.clear();
                  filterCategory.clear();
                  showSearches(context);
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Cart())),
              child: Stack(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Cart(),
                        ));
                      },
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                      )),
                  Positioned(
                    right: height * 0.015,
                    top: width * 0.008,
                    child: Consumer(
                      builder: (context, ref, child) {
                        var instance = Provider.of<CartCounter>(context);
                        // final count2=1;
                        return instance.count == 0
                            ? const SizedBox()
                            : Container(
                                // height: height*0.03,
                                width: width * 0.045,
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
                                )));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }
}
