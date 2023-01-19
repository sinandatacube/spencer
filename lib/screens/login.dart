import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spencer/api/api_with_model.dart';
import 'package:spencer/modal/details_model.dart';
import 'package:spencer/modal/login_model.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/forgot_password.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/webview.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/registration.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/widgets/loading_animation.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  Details details = Details();
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  void _toggle() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void initState() {
    super.initState();
    isSkip = true;
  }

  @override
  Widget build(BuildContext context) {
    dynamicLinkRouting(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.only(right: 10.0),
        //       child: Center(
        //         child:
        //       ),
        //     ),
        //   ],
        // ),
        backgroundColor: Colors.grey.shade100,
        body: _buildBody(height, width),
      ),
    );
  }

//////////////////////////////////////////////////////body//////////////////////////////////////////////////
  Widget _buildBody(double height, double width) {
    return SingleChildScrollView(
      // physics: const NeverScrollableScrollPhysics(),
      child: Stack(
        children: [
          Container(
            height: height,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height * 0.54,
              decoration: BoxDecoration(
                  // color: Color(0xff107cb5),
                  color: mainColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.elliptical(100, 40),
                      topLeft: Radius.elliptical(100, 40))),
            ),
          ),
          Positioned(
            bottom: height * 0.01,
            // left: width * 0.11,
            // right: width * 0.11,
            left: width * 0.03,
            right: width * 0.03,
            top: height * 0.02,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.1,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            isSkip = true;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomePage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset("assets/images/logo1.png",
                      height: height * 0.2, width: width * 0.63),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      height: 350,
                      width: width * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Text("Login ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                          const SizedBox(height: 20),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 025),
                              child: TextFormField(
                                controller: _usernameController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                keyboardType: TextInputType.number,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                    hintText: "Mobile Number",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w600)),
                              )),
                          const SizedBox(height: 20),
                          Stack(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  controller: _passwordController,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w400),
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w600)),
                                ),
                              ),
                              Positioned(
                                  // top: height * 0.02,
                                  // right: width * 0.06,
                                  top: 20,
                                  right: 35,
                                  child: InkWell(
                                    onTap: _toggle,
                                    child: _isObscure
                                        ? Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: Theme.of(context)
                                                .iconTheme
                                                .size,
                                          )
                                        : Icon(
                                            Icons.remove_red_eye,
                                            size: Theme.of(context)
                                                .iconTheme
                                                .size,
                                          ),
                                  ))
                            ],
                          ),
                          // SizedBox(height: height * 0.03),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                            },
                            child: Text(
                              "forgot Password?",
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(color: Colors.blue.shade600),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // SizedBox(height: height * 0.03),
                          SizedBox(
                            // height: height * 0.05,
                            // width: width * 0.44,
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                var userName = _usernameController.text.trim();
                                var password = _passwordController.text.trim();

                                String error = "";
                                if (userName.isEmpty) {
                                  error = "Mobile number is empty";
                                } else if (password == "") {
                                  error = "password is empty";
                                } else {
                                  LoginModal loginModal = LoginModal(
                                      mobileNumber: userName,
                                      password: password);
                                  //validation of password and mobile number
                                  // var result = await loginConfirmation(
                                  //     userName, password);

                                  //passing data to api
                                  var result = await checkLogin(loginModal);

                                  //loading animation
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const DialogLoadingAnimation();
                                      });

                                  if (result == "Socket error") {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NoNetwork()));
                                  } else if (result == "Network error") {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ErrorPage()));
                                  } else if (result["status"] == "success") {
                                    //storing shop id
                                    String shopId =
                                        result["profile"]["shop_id"] ?? "";

                                    // checking shop id is null
                                    if (shopId.isEmpty || shopId == "0") {
                                      error = "ERR-076, please try again later";
                                    } else {
                                      var sp =
                                          await SharedPreferences.getInstance();
                                      sp.setString("shopId", shopId);
                                      sp.setString("pass", password);
                                      isSkip = false;
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()),
                                          (route) => false);
                                    }
                                  } else if (result["status"] == "failed") {
                                    Navigator.of(context).pop();
                                    error =
                                        "Username and password doesn't match";
                                  }
                                }

                                //snackbar
                                if (error.isNotEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      error,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                              ),
                              child: Text(
                                "Log in",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 20),

                          // SizedBox(height: height * 0.05),
                          Expanded(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Not registered?",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              color: Colors.grey.shade900)),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Registration(
                                                    details: details,
                                                  )));
                                    },
                                    child: Text(" Register now",
                                        style: Theme.of(context)
                                            .textTheme
                                            .button!
                                            .copyWith(
                                                color: Colors.blue.shade600)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Center(
                          child: Text("Contact us - +971507182336",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w500)))),
                  Expanded(
                      flex: 3,
                      child: Center(
                        child: TextButton(
                          //  style: TextButton.styleFrom(splashFactory: ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Webview()));
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'By continuing you agree to ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                              children: <TextSpan>[
                                TextSpan(
                                  // text: total.toString(),
                                  text: " team spencer's\n ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                TextSpan(
                                  // text: total.toString(),
                                  text: " privacy policy",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade600),
                                ),
                              ],
                            ),
                          ),
                          // Text(
                          //   "By continuing you agree to team spencer's privacy policy",
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodySmall!
                          //       .copyWith(color: Colors.black),
                          // )
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
