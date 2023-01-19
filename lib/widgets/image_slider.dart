import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:spencer/utilities/url.dart';

// class ImageSlider extends StatefulWidget {
//   List images;
//   String productId;
//   String wishlistId;
//   bool isInWishlist;
//    ImageSlider({Key? key,required this.images,required this.productId,required this.wishlistId,required this.isInWishlist}) : super(key: key);

//   @override
//   State<ImageSlider> createState() => _ImageSliderState();
// }

// class _ImageSliderState extends State<ImageSlider> {

//   double currentIndexPage = 1;
//   @override
//   Widget build(BuildContext context) {

//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return Stack(
//           children: [
//             CarouselSlider.builder(
//               // =carouselController: controller,
//               itemCount: widget.images.length,
//               options: CarouselOptions(
//                 enableInfiniteScroll: false,
//                 viewportFraction: 01,
//                 enlargeCenterPage: true,
//                 // height: 300,
//                 autoPlay: false,
//                 scrollPhysics: const AlwaysScrollableScrollPhysics(),

//                 pauseAutoPlayOnManualNavigate: true,
//                 autoPlayInterval: const Duration(seconds: 3),
//                 reverse: false,
//                 aspectRatio: 4/3,
//               ),
//               itemBuilder: (context, i, id) {
//                 // for onTap to redirect to another screen
//                   currentIndexPage = i.toDouble();
//                   if(mounted){
// setState(() {});

//                   }

//                 return GestureDetector(
//                   child: Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.symmetric(horizontal: 7.w),
//                     // decoration: BoxDecoration(
//                     //     borderRadius: BorderRadius.circular(15),
//                     //     border: Border.all(
//                     //       // color: Colors.black,
//                     //       color: mainColor,
//                     //     )),
//                     //ClipRRect for image border radius
//                     child: ClipRRect(
//                       // borderRadius: BorderRadius.circular(15),
//                       child: Image.network(
//                         productDetailsImage+widget.images[i]["prod_image"],
//                         fit: BoxFit.fill,
//                       ),
//                       // child: ProgressiveImage(
//                       //   baseColor: Colors.grey.shade400,
//                       //   highlightColor: Colors.grey.shade100,
//                       //   fit: BoxFit.cover,
//                       //   image: imageList[i],
//                       //   width: MediaQuery.of(context).size.width,
//                       //   height: 300,
//                       // ),
//                     ),
//                   ),
//                   onTap: () {
//                     // var url = imageList[i];
//                     // Navigator.of(context).push(MaterialPageRoute(
//                     //     builder: (context) => ImageView(url: url)));
//                     // Get.to(ImageView(images: imageList,index:i));
//                   },
//                 );
//               },
//             ),
//             Positioned(
//               // bottom: 0,
//               top: 0,
//               right: 0,
//               child: WishlistButton(productId: widget.productId,shopId:  productDetailsImage + widget.inetwo,isInWishList: widget.isInWishlist,wishlistId: widget.wishlistId,)
//             // IconButton(onPressed: (){},icon:Icon(Icons.favorite_border,size: 35,))
//             ),
//             Positioned(
//               bottom: 2.h,
//               left: 0,
//               right: 0,
//               child: DotsIndicator(
//                 dotsCount: widget.images.length,
//                 position: currentIndexPage,
//                 decorator: DotsDecorator(
//                   size: const Size.square(9.0),
//                   activeSize: const Size(18.0, 9.0),
//                   // activeShape: RoundedRectangleBorder(
//                   //     borderRadius: BorderRadius.circular(5.0)),
//                 ),
//               ),
//             ),
//             PageView.builder()
//           ],
//         );
//       },
//     );
//   }
// }

class ImageSlider extends StatefulWidget {
  final List images;
  final String productId;
  // String wishlistId;
  // bool isInWishlist;
  const ImageSlider({
    Key? key,
    required this.images,
    required this.productId,
    // required this.isInWishlist,
    // required this.wishlistId
  }) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  double currentIndexPage = 0;

  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    // print(widget.images);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return widget.images.isEmpty
        ? Image.asset(noImageUrl)
        : Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {});
                  },
                  controller: _controller,
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    currentIndexPage = index.toDouble();
                    return Container(
                        height: height * 0.45,
                        width: width,
                        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                        // decoration: BoxDecoration(),
                        // child: Image.network(
                        //   productDetailsImage + widget.images[index]["prod_image"],
                        // ),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: CachedNetworkImage(
                            imageUrl:
                                productDetailsImage + widget.images[index],
                            // widget.images[index]["prod_image"],
                            fit: BoxFit.contain,
                            memCacheWidth: 1000,
                            placeholder: (context, url) {
                              return Image.asset(placeholderImage);
                            },
                            errorWidget: (context, url, dyn) {
                              return Image.asset(noImageUrl);
                            },
                          ),
                        ));
                  },
                ),
              ),
              widget.images.isEmpty
                  ? const SizedBox()
                  : Positioned(
                      bottom: 3,
                      left: 0,
                      right: 0,
                      child: DotsIndicator(
                        dotsCount: widget.images.length,
                        position: currentIndexPage,
                      ),
                    ),
            ],
          );
  }
}
