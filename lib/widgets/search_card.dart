import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spencer/screens/product_details.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/url.dart';

import '../utilities/global_variables.dart';

class SearchCard extends StatefulWidget {
  final String imgUrl;
  final String title;
  final String productId;
  final String wprice;
  final String productStatus;

  const SearchCard({
    Key? key,
    required this.productStatus,
    required this.imgUrl,
    required this.title,
    required this.productId,
    required this.wprice,
  }) : super(key: key);

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    // print("searchCard");
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return Product(productId: widget.productId);
            // return    ProductDetails(
            //     productId: widget.productId,
            //     wishlistId: widget.wishlistId,
            // );
          },
        ));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          //  height:height*0.3,
          //  width: width,
          //  color: Colors.red,
          decoration: BoxDecoration(
            border: Border.all(color: mainColor),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),

          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.01),
                      // child: Image.network(
                      // widget.imgUrl,

                      //   height: height * 0.2,
                      //   width: width * 0.5,
                      // ),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: widget.imgUrl,
                            // height: height * 0.18,
                            // width: width * 0.45,
                            fit: BoxFit.fitHeight,
                            memCacheWidth: 300,
                            placeholder: (context, url) {
                              return Image.asset(placeholderImage);
                            },
                            errorWidget: (context, url, dyn) {
                              return Image.asset(noImageUrl);
                            },
                          ),
                        ),
                      ),
                    ),
                    widget.productStatus == "0"
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.red.shade800,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: const Text(
                              "Not Available",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.02,
                            top: height * 0.005,
                            right: width * 0.01),
                        child: Text(
                          widget.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: width > 450
                              ? Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w600)
                              : Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (!isSkip)
                        Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.02, top: height * 0.005),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: height * 0.005),
                                child: Text(
                                  "AED ",
                                  style: width > 450
                                      ? Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: Colors.red.shade800)
                                      : Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.red.shade800),
                                ),
                              ),
                              Text(
                                widget.wprice,
                                style: width > 450
                                    ? Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            color: Colors.red.shade800,
                                            fontWeight: FontWeight.w600)
                                    : Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Colors.red.shade800,
                                            fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
