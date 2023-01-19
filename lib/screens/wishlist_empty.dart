import 'package:flutter/material.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/screens/home_page.dart';

class WishlistEmpty extends StatelessWidget {
  const WishlistEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(Icons.favorite_outline,size: 120,color: Colors.grey.shade400,),
          Image.asset("assets/images/wishEmpty.png"),
          SizedBox(height: height * 0.04),
          Text(
            "Your wishlist is empty",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: height * 0.04),
          SizedBox(
            height: height * 0.06,
            width: width * 0.4,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkerMainColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
                },
                child: Text(
                  "Explore now",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.white),
                )),
          )
        ],
      ),
    );
  }
}
