import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/check_subcategory.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/product_details.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/url.dart';

class OfferWall extends StatefulWidget {
  final List details;
  const OfferWall({Key? key, required this.details}) : super(key: key);

  @override
  State<OfferWall> createState() => _OfferWallState();
}

class _OfferWallState extends State<OfferWall> {
  double currentIndexPage = 0;
  @override
  Widget build(BuildContext context) {
    // print("offerWallDetails");
    // print(widget.details);
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return CarouselSlider.builder(
      itemCount: widget.details.length,
      options: CarouselOptions(
        enableInfiniteScroll: true,
        viewportFraction: 1,
        enlargeCenterPage: true,
        // height: 300,
        autoPlay: true,
        scrollPhysics: const AlwaysScrollableScrollPhysics(),

        pauseAutoPlayOnManualNavigate: true,
        autoPlayInterval: const Duration(seconds: 3),
        reverse: false,
        aspectRatio: 16 / 9,
      ),
      itemBuilder: (context, i, id) {
        return InkWell(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.06),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  // color: Colors.black,
                  color: mainColor,
                )),
            //ClipRRect for image border radius
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                // child: Image.network(
                //   imageList[i],
                //   width: 500,
                //   fit: BoxFit.cover,
                // ),
                child: CachedNetworkImage(
                  imageUrl:
                      offerwallImageUrl + widget.details[i]["offerwall_img"],
                  // height: height * 0.3,
                  // width: width,
                  // fit: BoxFit.cover,
                  memCacheWidth: 1000,
                  placeholder: (context, url) {
                    return AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          placeholderImage,
                          fit: BoxFit.cover,
                        ));
                  },
                  errorWidget: (context, url, dyn) {
                    return Image.asset(noImageUrl);
                  },
                )),
          ),
          onDoubleTap: () {},
          onTap: () async {
            //api fetch data
            if (widget.details[i]["clickable"] == "1") {
              var result = await fetchOfferWallDetails(
                widget.details[i]["offer_type"],
                widget.details[i]["offer_product_or_category"],
              );

              //check socket error
              if (result == "Socket error") {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NoNetwork()));
              }
              //if product goto productdetails
              else if (widget.details[i]["offer_type"] == "product") {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      Product(productId: result["product"]["product_id"]),
                ));
              }
              //if category goto subcategory
              else if (widget.details[i]["offer_type"] == "category") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CheckSubCategory(
                        cagetogoryId: result["product"][i]["category_id"])));
              }
            }
          },
        );
      },
    );
  }
}
