import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spencer/screens/check_subcategory.dart';
import 'package:spencer/utilities/url.dart';

class CategoriesTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String categoryId;
  const CategoriesTile(
      {Key? key,
      required this.imgUrl,
      required this.title,
      required this.categoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CheckSubCategory(
            cagetogoryId: categoryId,
          ),
        ));
      },
      child: Container(
        padding: EdgeInsets.only(top: height * 0.01),
        // height: height * 0.1,
        // width: width * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: CachedNetworkImage(
                imageUrl: baseImageUrl + categoriesImage + imgUrl,
                // height: height * 0.1,
                // width: width * 0.2,
                // fit: BoxFit.fill,
                memCacheWidth: 300,
                placeholder: (context, url) {
                  return Image.asset(placeholderImage);
                },
                errorWidget: (context, url, dyn) {
                  return Image.asset(noImageUrl);
                },
              ),
            ),
            // SizedBox(height: height * 0.004),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                child: Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
