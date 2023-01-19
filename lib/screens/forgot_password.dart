import 'package:flutter/material.dart';
import 'package:spencer/screens/submit_number.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/url.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);
  final numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              Center(
                child: Image.asset(
                  forgotImage,
                  height: height * 0.3,
                  width: width,
                ),
              ),
              // SizedBox(
              //   height: height * 0.03,
              // ),
              Padding(
                padding:
                    EdgeInsets.only(left: width * 0.15, top: height * 0.03),
                child: Text(
                  "Forgot Password?",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.15, top: height * 0.02, right: width * 0.1),
                child: Text(
                  "Please enter mobile number to recieve verification code",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  alignment: Alignment.center,
                  height: height * 0.07,
                  width: width * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200),
                  child: TextField(
                    controller: numberController,
                    // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    keyboardType: TextInputType.number,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Mobile Number",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Center(
                child: SizedBox(
                    height: height * 0.06,
                    width: width * 0.3,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: mainColor),
                      onPressed: () async {
                        var number = numberController.text.trim();
                        submitNumber(context, number);
                      },
                      child: Text(
                        "Send",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  submitNumber(BuildContext context, String number) async {
    var error = "";
    if (number.isEmpty) {
      error = "Enter Mobile Number";
    } else if (number.length < 10) {
      error = "Enter a valid Mobile Number";
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => SubmitNumber(number: number)));
    }

    if (error != "") {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Colors.red.shade700,
      ));
    }
  }
}
