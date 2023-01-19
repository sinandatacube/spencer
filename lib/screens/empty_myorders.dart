import 'package:flutter/material.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/url.dart';

class EmptyMyOrders extends StatelessWidget {
  const EmptyMyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade100,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            urlEmptyOrderImage,
            height: height * 0.5,
          ),
          Text(
            "you haven't placed\nany orders yet",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          SizedBox(
            height: height * 0.07,
            width: width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: Text(
                "Explore products",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
