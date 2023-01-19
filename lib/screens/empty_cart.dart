import 'package:flutter/material.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/screens/home_page.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context, width, height),
    );
  }

  /////////////////////////////////////////////////////////body///////////////////////////////////////////////////
  Widget _buildBody(BuildContext context, double width, double height) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/emptyCart.png",
              height: height * 0.2, width: width * 0.3),
          Text("Your cart is empty",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                  )),
          SizedBox(
            height: height * 0.03,
          ),
          SizedBox(
            height: 45,
            width: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage())),
              child: Text(
                "Shop now",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
