import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spencer/utilities/url.dart';

class CheckOutTile extends StatelessWidget {
  final String productName;
  final String price;
  final String quantity;
  final String subtotal;
  final String imgUrl;
  const CheckOutTile(
      {Key? key,
      required this.price,
      required this.productName,
      required this.quantity,
      required this.subtotal,
      required this.imgUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 2,
      child: Container(
        height: height * 0.15,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          // border: Border.all()
        ),
        child: Row(
          children: [
            // Image.network(
            //   productListImage + current["product_image"],
            //   height: height * 0.15,
            //   width: width * 0.2,
            //   fit: BoxFit.cover,
            // ),

            //     height: height * 0.15,
            // width: width * 0.22,
            Container(
              height: height * 0.15,
              width: width * 0.23,
              color: Colors.white,
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                // productListImage + current["product_image"],
                fit: BoxFit.contain,
                memCacheWidth: 200,
                placeholder: (context, url) {
                  return Image.asset(placeholderImage);
                },
                errorWidget: (context, url, dyn) {
                  return Image.asset(noImageUrl);
                },
              ),
            ),

            Container(
              alignment: Alignment.center,
              height: height * 0.14,
              width: width * 0.35,
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  width > 550
                      ? Text(
                          productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        )
                      : Text(
                          productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                  SizedBox(height: height * 0.01),
                  Row(
                    children: [
                      width > 550
                          ? Text(
                              "AED",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                            )
                          : Text(
                              "AED",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                            ),
                      SizedBox(width: width * 0.01),
                      width > 550
                          ? Text(price,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w600))
                          : Text(price,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w600))
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height * 0.1,
              width: width * 0.1,
              child: width > 550
                  ? Text(
                      "x$quantity",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    )
                  : Text(
                      "x$quantity",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                // height: height * 0.1,
                child: Row(
                  children: [
                    width > 550
                        ? Text(
                            "AED",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(fontWeight: FontWeight.w600),
                          )
                        : Text(
                            "AED",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                    SizedBox(width: width * 0.01),
                    FittedBox(
                      child: width > 550
                          ? Text(subtotal,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w600))
                          : Text(subtotal,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
