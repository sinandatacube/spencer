import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spencer/screens/change_password.dart';
import 'package:spencer/utilities/colors.dart';

class VerifyOtp extends StatelessWidget {
  final String otp;
  final String shopId;
  VerifyOtp({Key? key, required this.otp, required this.shopId})
      : super(key: key);
  final digit1Controller = TextEditingController();
  final digit2Controller = TextEditingController();
  final digit3Controller = TextEditingController();
  final digit4Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    log("otp");
    log(otp);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                SizedBox(
                  child: Image.asset(
                    "assets/images/mobileotp.png",
                    height: height * 0.4,
                    width: width,
                  ),
                ),
                // SizedBox(
                //   height: height * 0.05,
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: Text(
                    "Please enter the otp to verify your account",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(width: width * 0.1),
                    Container(
                      // padding: EdgeInsets.only(left: width * 0.05),

                      // alignment: Alignment.center,
                      height: height * 0.07,
                      width: width * 0.12,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        autofocus: true,
                        onChanged: (str) {
                          if (str.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        textInputAction: TextInputAction.next,
                        inputFormatters: [LengthLimitingTextInputFormatter(1)],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                        keyboardType: TextInputType.number,
                        controller: digit1Controller,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.08),
                    Container(
                      height: height * 0.07,
                      width: width * 0.12,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        onChanged: (str) {
                          if (str.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (str.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        textInputAction: TextInputAction.next,
                        inputFormatters: [LengthLimitingTextInputFormatter(1)],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                        keyboardType: TextInputType.number,
                        controller: digit2Controller,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            // hintText: "   *",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            )),
                      ),
                    ),
                    SizedBox(width: width * 0.08),

                    Container(
                      height: height * 0.07,
                      width: width * 0.12,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        onChanged: (str) {
                          if (str.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (str.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        textInputAction: TextInputAction.next,
                        inputFormatters: [LengthLimitingTextInputFormatter(1)],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                        keyboardType: TextInputType.number,
                        controller: digit3Controller,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.08),

                    Container(
                      height: height * 0.07,
                      width: width * 0.12,
                      decoration: BoxDecoration(
                          // color: Colors.grey.shade400,
                          color: Colors.white,
                          border: Border.all(color: Colors.black87, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        onChanged: (str) {
                          if (str.length == 1) {
                            FocusScope.of(context).unfocus();
                          }
                          if (str.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        textInputAction: TextInputAction.next,
                        inputFormatters: [LengthLimitingTextInputFormatter(1)],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                        keyboardType: TextInputType.number,
                        controller: digit4Controller,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.08,
                ),
                SizedBox(
                  height: height * 0.06,
                  width: width * 0.25,
                  child: ElevatedButton(
                    onPressed: () {
                      String digit1 = digit1Controller.text;
                      String digit2 = digit2Controller.text;
                      String digit3 = digit3Controller.text;
                      String digit4 = digit4Controller.text;
                      String userOtp = digit1 + digit2 + digit3 + digit4;
                      validation(
                          digit1, digit2, digit3, digit4, context, userOtp);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                    child: Text(
                      "Verify",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  validation(String digit1, String digit2, String digit3, String digit4,
      BuildContext context, String userOtp) {
    String error = "";
    if (digit1.isEmpty || digit2.isEmpty || digit3.isEmpty || digit4.isEmpty) {
      error = "please enter 4 digit otp";
    } else {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>VerifyOtp(otp: otp, userOtp: userOtp, shopId: shopId) ,));
      if (otp == userOtp) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ChangePassword(
            shopId: shopId,
          ),
        ));
      } else {
        error = "Enter a valid otp";
      }
    }

    if (error != "") {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
        backgroundColor: Colors.red.shade800,
      ));
    }
  }
}
