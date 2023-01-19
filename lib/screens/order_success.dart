import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/utilities/colors.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: darkerMainColor,
        body: _buildBody(context, height, width));
  }

  ////////////////////////////////////////////////////body/////////////////////////////////////////
  Widget _buildBody(BuildContext context, double height, double width) {
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        // show the confirm dialogS
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text(
                    'Are you sure you want to leave?',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: mainColor),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'No',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          willLeave = true;
                          // Navigator.of(context).pop();
                          SystemNavigator.pop();
                        },
                        child: Text('yes',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)))
                  ],
                ));
        return willLeave;
      },
      child: SafeArea(
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: height * 0.5,
              width: width * 0.7,
              decoration: BoxDecoration(
                  //  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.2,
                    width: width * 0.2,
                    // width: 100.w,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  Text("Congratulations",
                      // "Successfully submitted",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: height * 0.03),
                  // Text(
                  //   subtitle1,
                  //   // "Hold on!",
                  //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  //         fontWeight: FontWeight.w400,
                  //         color: Colors.grey.shade500)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Text("Your order placed succesfully",
                        // "Your account will activated in 2-3 business days",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade500)),
                  ),
                  // SizedBox(height: height * 0.03),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        height: height * 0.06,
                        width: width * 0.3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: darkerMainColor),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            },
                            child: Text(
                              "Done",
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
