import 'package:flutter/material.dart';
import 'package:spencer/screens/submit_password.dart';
import 'package:spencer/utilities/colors.dart';

class ChangePassword extends StatefulWidget {
  final String shopId;
  const ChangePassword({Key? key, required this.shopId}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final password1 = TextEditingController();
  final password2 = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;

  void _toggle() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _toggle2() {
    setState(() {
      _isObscure2 = !_isObscure2;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // elevation: 0,
        // backgroundColor: Colors.white,
        title: Text(
          "Reset password",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Padding(
            //    padding:  EdgeInsets.only(left: width*0.09,top: height*0.06),
            //    child: Text("Change password",style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.black),),
            //  )
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.1, top: height * 0.03, bottom: height * 0.01),
              child: Text(
                "Enter new password",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height * 0.07,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black)),
              margin: EdgeInsets.symmetric(horizontal: width * 0.08),
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Stack(
                children: [
                  TextFormField(
                    obscureText: _isObscure,
                    controller: password1,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      // hintText: "Password",
                      // hintStyle: Theme.of(context)
                      //     .textTheme
                      //     .bodySmall!
                      //     .copyWith(
                      //         color: Colors.grey.shade800,
                      //         fontWeight: FontWeight.w600)
                    ),
                  ),
                  Positioned(
                      top: height * 0.02,
                      right: width * 0.02,
                      child: InkWell(
                        onTap: _toggle,
                        child: _isObscure
                            ? const Icon(Icons.remove_red_eye_outlined,
                                size: 20)
                            : const Icon(Icons.remove_red_eye, size: 20),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.1, top: height * 0.03, bottom: height * 0.01),
              child: Text(
                "Confirm password",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            Container(
              height: height * 0.07,
              width: width,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: width * 0.08),
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black)),
              child: Stack(
                children: [
                  TextFormField(
                    obscureText: _isObscure2,
                    controller: password2,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      // hintText: "Password",
                      // hintStyle: Theme.of(context)
                      //     .textTheme
                      //     .bodySmall!
                      //     .copyWith(
                      //         color: Colors.grey.shade800,
                      //         fontWeight: FontWeight.w600)
                    ),
                  ),
                  Positioned(
                      top: height * 0.02,
                      right: width * 0.02,
                      child: InkWell(
                        onTap: _toggle2,
                        child: _isObscure
                            ? const Icon(Icons.remove_red_eye_outlined,
                                size: 20)
                            : const Icon(Icons.remove_red_eye, size: 20),
                      ))
                ],
              ),
            ),

            SizedBox(
              height: height * 0.05,
            ),
            Center(
              child: SizedBox(
                height: height * 0.07,
                width: width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    String error = "";
                    if (password1.text.trim().isEmpty) {
                      error = "Enter password";
                    } else if (password1.text.trim().length < 8) {
                      error = "Minimum 8 characters needed";
                    } else if (password1.text.trim() != password2.text.trim()) {
                      error = "password donot match";
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SubmitPassword(
                          shopId: widget.shopId,
                          password: password1.text.trim(),
                        ),
                      ));
                    }

                    if (error != "") {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          error,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        backgroundColor: Colors.red.shade800,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  child: Text(
                    "Submit",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
