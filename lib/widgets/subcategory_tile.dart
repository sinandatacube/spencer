import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spencer/screens/bulk_subcatory_list.dart';
import 'package:spencer/screens/subcategory_list.dart';
import 'package:spencer/utilities/url.dart';

import '../states/bulk_provider.dart';

class SubCategoryTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String subcategoryId;
  final String isBulk;
  const SubCategoryTile(
      {Key? key,
      required this.imgUrl,
      required this.title,
      required this.subcategoryId,
      required this.isBulk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        if (isBulk == "0") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SubcategoryList(subCategoryId: subcategoryId),
          ));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => BulkSubcategoryList(
                  subCategoryId: subcategoryId,
                ),
              ))
              .then((value) => context.read<BulkProvider>().clearAllData());
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: height * 0.02),
        height: height * 0.28,
        width: width * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                // height: height*0.19,
                // width: width*0.4,
                fit: BoxFit.contain,
                memCacheWidth: 500,
                placeholder: (context, url) {
                  return Image.asset(placeholderImage);
                },
                errorWidget: (context, url, dyn) {
                  return Image.asset(noImageUrl);
                },
              ),
            ),
            SizedBox(height: height * 0.02),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: FittedBox(
                    child: Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            )
          ],
        ),
        // child: Column(
        //   children: [
        //     //     Image.network(
        //     //  imgUrl,
        //     //       height: 70.h,
        //     //       width: 60.w,
        //     //     ),
        //     CachedNetworkImage(
        //       imageUrl: imgUrl,
        //       height: height*0.18,
        //       width: width*0.4,
        //       fit: BoxFit.contain,
        //       memCacheWidth: 300,
        //       placeholder: (context, url) {
        //         return Image.asset(placeholderImage);
        //       },
        //       errorWidget: (context, url, dyn) {
        //         return Image.asset(noImageUrl);
        //       },
        //     ),
        //     SizedBox(
        //       height: 4.h,
        //     ),
        //     Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 5),
        //       child: FittedBox(
        //         child: Text(
        //           title,
        //          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black,fontWeight: FontWeight.w600)
        //         ),
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
