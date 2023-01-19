import 'package:flutter/material.dart';
import 'package:spencer/main.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/login.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/functions.dart';
import 'package:spencer/utilities/global_variables.dart';

class NoNetwork extends StatelessWidget {
  const NoNetwork({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;

    return Scaffold(
        //  backgroundColor:Colors.grey.shade50,
        body: _buildBody(context, height, width));
  }

  //////////////////////////////////////////////////////////////body////////////////////////////////////////////////////
  Widget _buildBody(BuildContext context, double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.09),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/noNetwork1.png",
              height: height * 0.15,
              width: width * 0.25,
            ),
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Text(
            "Whoops!",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w400, color: Colors.grey.shade400),
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Text(
            "No Internet connection found.Check your connection and try again",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w400, color: Colors.grey.shade600),
          ),
          SizedBox(
            height: height * 0.015,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              onPressed: () async {
                // var prefss = await SharedPreferences.getInstance();
                checkNetwork();
                Future.delayed(const Duration(milliseconds: 150), () async {
                  if (isConnected == "true") {
                    var route = await checkIsLoggedIn();
                    // print(route);
                    if (route == "failed") {
                      isSkip = false;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Login(),
                      ));
                    } else if (route == "success") {
                      isSkip = false;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false);
                    }
                  } else if (isConnected == "false") {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const NoNetwork(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  }
                });
              },
              // onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => route(),)),
              child: Text(
                "Try again",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
              ))
        ],
      ),
    );
  }
}
