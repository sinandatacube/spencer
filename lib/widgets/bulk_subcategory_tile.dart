import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/states/bulk_provider.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';


class BulkSubCategoryTile extends StatefulWidget {
  final String productId;
  final String title;
  final String price;
  final String min;
  final String max;
  final String imgUrl;
  int qty;
  String productStatus;
  BulkSubCategoryTile(
      {Key? key,
      required this.productStatus,
      required this.productId,
      required this.max,
      required this.imgUrl,
      required this.min,
      required this.price,
      required this.title,
      required this.qty})
      : super(key: key);

  @override
  State<BulkSubCategoryTile> createState() => _BulkSubCategoryTileState();
}

class _BulkSubCategoryTileState extends State<BulkSubCategoryTile> {
  // int min = 3;
  // int max = 10;
  int qty = 0;
  DB database = DB();

  @override
  void initState() {
    // qty = widget.qty;
    qty = widget.qty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // qty = widget.qty;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.01, vertical: height * 0.003),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.01, vertical: height * 0.003),
        height: height * 0.24,
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(
              width: width * 0.02,
            ),
            AspectRatio(
              aspectRatio: 3 / 4,
              child: CachedNetworkImage(
                imageUrl: productDetailsImage + widget.imgUrl,
                errorWidget: (context, url, error) => Image.asset(noImageUrl),
                placeholder: (context, url) => Image.asset(placeholderImage),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                      ),
                      isSkip
                          ? const SizedBox()
                          : Row(
                              children: [
                                Text(
                                  "AED",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.red.shade800),
                                ),
                                Text(
                                  widget.price,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: Colors.red.shade800,
                                          fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isSkip
                                ? const SizedBox()
                                : Text(
                                    "Min qty: ${widget.min}\nMax qty: ${widget.max}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: Colors.black45),
                                  ),
                            qty == 0
                                ? SizedBox(
                                    width: 80,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100))),
                                      onPressed: widget.productStatus == "0"
                                          ? null
                                          : () {
                                              //

                                              if (isSkip) {
                                                null;
                                                Fluttertoast.cancel();
                                                Fluttertoast.showToast(
                                                    msg: "Please Login");
                                              } else {
                                                qty = int.parse(widget.min);
                                                database.insertdata(
                                                    savedShopId,
                                                    widget.productId,
                                                    qty,
                                                    int.parse(widget.min),
                                                    int.parse(widget.max),
                                                    true);
                                                context
                                                    .read<BulkProvider>()
                                                    .removeItemFromCart(
                                                        widget.productId);
                                                // prodIdss.removeWhere(
                                                //   (element) =>
                                                //       element["product_id"] ==
                                                //       productId,
                                                // );
                                                context
                                                    .read<BulkProvider>()
                                                    .addItemToCart(
                                                        widget.productId, qty);
                                                // prodIdss.add({
                                                //   "product_id": productId,
                                                //   "qantity": qty
                                                // });

                                                // setState(() {});
                                              }
                                            },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 100,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          // color: Colors.grey.shade200,
                                        ),
                                        child: Text(
                                          "Add",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 30,
                                    width: 90,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Card(
                                          margin: EdgeInsets.zero,
                                          shape: const CircleBorder(),
                                          child: SizedBox.square(
                                            dimension: 27,
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                splashRadius: 10,
                                                onPressed: () {
                                                  //remove
                                                  if (qty ==
                                                      int.parse(widget.min)) {
                                                    qty = 0;
                                                    database.deleteItems(
                                                        widget.productId);
                                                    context
                                                        .read<BulkProvider>()
                                                        .removeItemFromCart(
                                                            widget.productId);
                                                    // prodIdss.removeWhere(
                                                    //   (element) =>
                                                    //       element[
                                                    //           "product_id"] ==
                                                    //       productId,
                                                    // );
                                                    cartCountUpdate(context);
                                                  } else {
                                                    qty--;
                                                    database.insertdata(
                                                        savedShopId,
                                                        widget.productId,
                                                        qty,
                                                        int.parse(widget.min),
                                                        int.parse(widget.max),
                                                        true);
                                                    context
                                                        .read<BulkProvider>()
                                                        .removeItemFromCart(
                                                            widget.productId);
                                                    // prodIdss.removeWhere(
                                                    //   (element) =>
                                                    //       element[
                                                    //           "product_id"] ==
                                                    //       productId,
                                                    // );
                                                    context
                                                        .read<BulkProvider>()
                                                        .addItemToCart(
                                                            widget.productId,
                                                            qty);
                                                    // prodIdss.add({
                                                    //   "product_id": productId,
                                                    //   "qantity": qty
                                                    // });

                                                    cartCountUpdate(context);
                                                  }
                                                  // setState(() {});
                                                },
                                                icon: const Icon(Icons.remove)),
                                          ),
                                        ),
                                        Text(
                                          qty.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Card(
                                          margin: EdgeInsets.zero,
                                          shape: const CircleBorder(),
                                          child: SizedBox.square(
                                            dimension: 27,
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                splashRadius: 10,
                                                onPressed: () {
                                                  //addd
                                                  if (qty !=
                                                      int.parse(widget.max)) {
                                                    qty++;
                                                    database.insertdata(
                                                        savedShopId,
                                                        widget.productId,
                                                        qty,
                                                        int.parse(widget.min),
                                                        int.parse(widget.max),
                                                        true);
                                                    context
                                                        .read<BulkProvider>()
                                                        .removeItemFromCart(
                                                            widget.productId);

                                                    // prodIdss.removeWhere(
                                                    //   (element) =>
                                                    //       element[
                                                    //           "product_id"] ==
                                                    //       productId,
                                                    // );
                                                    context
                                                        .read<BulkProvider>()
                                                        .addItemToCart(
                                                            widget.productId,
                                                            qty);

                                                    // prodIdss.add({
                                                    //   "product_id": productId,
                                                    //   "qantity": qty
                                                    // });
                                                    cartCountUpdate(context);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "max quantity reached")));
                                                  }
                                                  // setState(() {});
                                                },
                                                icon: const Icon(Icons.add)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      widget.productStatus == "0"
                          ? Text(
                              "Not Available !",
                              style: TextStyle(
                                  color: Colors.red.shade800, fontSize: 13),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
