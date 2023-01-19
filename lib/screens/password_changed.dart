import 'package:flutter/material.dart';
import 'package:spencer/screens/login.dart';
import 'package:spencer/utilities/colors.dart';

class PasswordChanged extends StatelessWidget {
  const PasswordChanged({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: Colors.green.shade500,
      backgroundColor: darkerMainColor,
      // backgroundColor: Color(0xff107cb5),
      // backgroundColor: Color(0xff0c87b0),
      body: SafeArea(
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: height * 0.45,
              width: width * 0.7,
              decoration: BoxDecoration(
                  //  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.19,
                    width: width * 0.19,
                    // width: 100.w,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.check,
                      size: Theme.of(context).iconTheme.size,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.6,
                    child: Text("Your password has changed successfully",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                  ),

                  // SizedBox(height: height * 0.02),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        height: height * 0.06,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const Login(),
                              ));
                            },
                            child: Text(
                              "Back to login",
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
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
