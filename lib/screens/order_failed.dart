import 'package:flutter/material.dart';

class OrderFailed extends StatelessWidget {
  const OrderFailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.4,
            ),
            Image.asset(
              "assets/images/somethingwentwrong.png",
              height: height * 0.1,
              width: width * 06,
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Text(
              "Something went wrong",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.grey.shade500),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              "Please try again",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.grey.shade500),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2e5266)),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Go back",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w700, color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
