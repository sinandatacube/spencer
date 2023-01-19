import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:spencer/modal/details_model.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/submit_registration.dart';
import 'package:spencer/screens/webview.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/screens/login.dart';
import 'package:spencer/utilities/functions.dart';
// import 'package:spencer/widgets/imagePicker.dart';

class Registration extends StatefulWidget {
  final Details details;
  const Registration({Key? key, required this.details}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late TextEditingController mobileNumberController;

  late TextEditingController addressController;

  late TextEditingController placeController;

  late TextEditingController pincodeController;

  late TextEditingController shopNameController;

  late TextEditingController emailController;

  late TextEditingController ownerNameController;

  late TextEditingController passwordController;

  late TextEditingController password2Controller;

  late TextEditingController trnController;

  bool check = false;

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
  void initState() {
    mobileNumberController =
        TextEditingController(text: widget.details.mobileNumber);

    addressController = TextEditingController(text: widget.details.address);

    placeController = TextEditingController(text: widget.details.place);

    pincodeController = TextEditingController(text: widget.details.pincode);

    shopNameController = TextEditingController(text: widget.details.shopName);

    emailController = TextEditingController(text: widget.details.email);

    ownerNameController = TextEditingController(text: widget.details.ownerName);

    trnController = TextEditingController(text: widget.details.trnNo);

    passwordController = TextEditingController();

    password2Controller = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:
         Text(
          "Shop Registration",
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      body: _buildBody(context, height, width),
    );
  }

//////////////////////////////////////////////////// body //////////////////////////////////////////////
  Widget _buildBody(BuildContext context, double height, double width) {
    return SingleChildScrollView(
      // physics: const NeverScrollableScrollPhysics(),
      child: Stack(
        children: [
          SizedBox(height: height * 1.15),
          Container(
            alignment: Alignment.center,
            height: height * 0.6,
            decoration: BoxDecoration(
                color: mainColor,
                // color: Color(0xff107cb5),
                // color: Color(0xff1392d6),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.elliptical(100, 40),
                    bottomRight: Radius.elliptical(100, 40))),
          ),
          Positioned(
            bottom: height * 0.01,
            left: width * 0.013,
            right: width * 0.013,
            top: height * 0.02,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(
                  //   height: height * 0.02,
                  // ),
                  // Text("Registration",
                  //     style: Theme.of(context).textTheme.headline5!.copyWith(
                  //         color: Colors.black, fontWeight: FontWeight.w600)),
                  SizedBox(height: height * 0.02),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      height: height,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: height * 0.02),
                          Container(
                            height: height * 0.06,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              children: [
                                const Icon(
                                  LineAwesomeIcons.address_book,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                SizedBox(
                                  width: width * 0.6,
                                  child: TextFormField(
                                    controller: trnController,
                                    decoration: InputDecoration(
                                        hintText: "Trn no.",
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Container(
                            height: height * 0.06,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              children: [
                                const Icon(
                                  LineAwesomeIcons.store,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                SizedBox(
                                  width: width * 0.6,
                                  child: TextFormField(
                                    controller: shopNameController,
                                    decoration: InputDecoration(
                                        hintText: "Shop name",
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Container(
                              height: height * 0.06,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              child: Row(
                                children: [
                                  const Icon(
                                    LineAwesomeIcons.user,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SizedBox(
                                    width: width * 0.6,
                                    child: TextFormField(
                                      controller: ownerNameController,
                                      decoration: InputDecoration(
                                          hintText: "Owner name",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Colors.grey.shade800,
                                                  fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                              height: height * 0.06,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              child: Row(
                                children: [
                                  const Icon(
                                    LineAwesomeIcons.mobile_phone,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SizedBox(
                                    width: width * 0.6,
                                    child: TextFormField(
                                      // inputFormatters: [
                                      // LengthLimitingTextInputFormatter(10)
                                      // ],
                                      keyboardType: TextInputType.phone,
                                      controller: mobileNumberController,
                                      decoration: InputDecoration(
                                          hintText: "Mobile Number",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Colors.grey.shade800,
                                                  fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(height: height * 0.02),
                          Container(
                            height: height * 0.06,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              children: [
                                const Icon(
                                  LineAwesomeIcons.map_marker,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                SizedBox(
                                  width: width * 0.6,
                                  child: TextFormField(
                                    controller: placeController,
                                    decoration: InputDecoration(
                                        hintText: "Place",
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            height: height * 0.09,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              children: [
                                const Icon(
                                  LineAwesomeIcons.address_card,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                SizedBox(
                                  width: width * 0.6,
                                  child: TextFormField(
                                    // maxLines: 2,
                                    controller: addressController,
                                    decoration: InputDecoration(
                                      hintText: "Address",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Colors.grey.shade800,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.06,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.numbers_outlined,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                SizedBox(
                                  width: width * 0.6,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(8)
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: pincodeController,
                                    decoration: InputDecoration(
                                        hintText: "Pincode",
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            height: height * 0.06,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              children: [
                                const Icon(
                                  LineAwesomeIcons.envelope,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                SizedBox(
                                  width: width * 0.6,
                                  child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            height: height * 0.06,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              children: [
                                const Icon(
                                  LineAwesomeIcons.lock,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                SizedBox(
                                  width: width * 0.6,
                                  child: Stack(
                                    children: [
                                      TextFormField(
                                        obscureText: _isObscure,
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                            hintText: "Password",
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Colors.grey.shade800,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                      ),
                                      Positioned(
                                        top: height * 0.02,
                                        right: width * 0.02,
                                        child: InkWell(
                                          onTap: _toggle,
                                          child: _isObscure
                                              ? const Icon(
                                                  Icons.remove_red_eye_outlined,
                                                  size: 20)
                                              : const Icon(Icons.remove_red_eye,
                                                  size: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                              height: height * 0.06,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              child: Row(
                                children: [
                                  const Icon(
                                    LineAwesomeIcons.lock,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SizedBox(
                                    width: width * 0.6,
                                    child: Stack(
                                      children: [
                                        TextFormField(
                                          controller: password2Controller,
                                          obscureText: _isObscure2,
                                          decoration: InputDecoration(
                                              hintText: "re enter password",
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                        ),
                                        Positioned(
                                            top: height * 0.02,
                                            right: width * 0.02,
                                            child: InkWell(
                                              onTap: _toggle2,
                                              child: _isObscure2
                                                  ? const Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      size: 20)
                                                  : const Icon(
                                                      Icons.remove_red_eye,
                                                      size: 20),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: check,
                                  onChanged: (val) {
                                    check = !check;
                                    setState(() {});
                                  }),
                              const Text("I agree to"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Webview()));
                                  },
                                  child: Text(
                                    "privacy policy",
                                    style:
                                        TextStyle(color: Colors.blue.shade500),
                                  ))
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                height: height * 0.05,
                                width: width * 0.3,
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.1),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: mainColor),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    //check privacy and policy
                                    if (!check) {
                                      Fluttertoast.showToast(
                                          msg: "please check privacy policy");
                                      return;
                                    }
                                    //check network
                                    checkNetwork();

                                    Future.delayed(
                                        const Duration(milliseconds: 250), () {
                                      if (isConnected == "true") {
                                        validate(context, height, width);
                                      } else if (isConnected == "false") {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const NoNetwork(),
                                        ));
                                      }
                                    });
                                  },
                                  child: Text("Submit",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 7.sp,
                  // ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ));
                          },
                          child: Text(" Log in",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: const Color(0xff107cb5),
                                      fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  validate(BuildContext context, double height, double width) {
    String error = "";

    if (trnController.text.trim().isEmpty) {
      error = "Please enter Trn no.";
    } else if (shopNameController.text.trim().isEmpty) {
      error = "Please enter shop name";
    } else if (ownerNameController.text.trim().isEmpty) {
      error = "Please enter owner name";
    } else if (mobileNumberController.text.trim().isEmpty) {
      error = "Please enter Mobile number";
    } else if (mobileNumberController.text.trim().length < 10) {
      error = "Enter a valid Mobile number";
    } else if (placeController.text.trim().isEmpty) {
      error = "Please enter Place ";
    } else if (addressController.text.trim().isEmpty) {
      error = "Please enter address";
    } else if (pincodeController.text.trim().isEmpty) {
      error = "Please Enter pincode";
    } else if (pincodeController.text.trim().length < 5) {
      error = "Please Enter a valid pincode";
    } else if (passwordController.text.trim().isEmpty) {
      error = "Please Enter password";
    } else if (passwordController.text.trim().length < 8) {
      error = "minimum 8 characters required for password";
    } else if (password2Controller.text.trim() !=
        passwordController.text.trim()) {
      error = "Passwords do not match";
    } else if (emailController.text.trim().isEmpty) {
      error = "Please Enter Email address";
    } else if (emailController.text.trim().isNotEmpty) {
      bool emailValid =
          RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
              .hasMatch(emailController.text.trim());
      if (emailValid == false) {
        error = "Enter a valid email";
      }
    }
    //loader
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return DialogLoadingAnimation();
    //     });

    //snackbar to show error and pass data to api

    if (error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error,
          style: snackbarTextStyle,
        ),
        backgroundColor: Colors.red,
      ));

      return;
    } else {
      var details = Details(
        address: addressController.text.trim(),
        email: emailController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        password: passwordController.text.trim(),
        pincode: pincodeController.text.trim(),
        place: placeController.text.trim(),
        shopName: shopNameController.text.trim(),
        trnNo: trnController.text.trim(),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SubmitRegistration(
                details: details,
              )));
    }
  }

  // submitRegistration(BuildContext context) async {
  //   var body = {
  //     "shop_name": shopNameController.text.trim(),
  //     "owner_name": ownerNameController.text.trim(),
  //     "mobile": mobileNumberController.text.trim(),
  //     "password": passwordController.text.trim(),
  //     "email": emailController.text.trim(),
  //     "address": addressController.text.trim(),
  //     "place": placeController.text.trim(),
  //     "pincode": pincodeController.text.trim(),
  //     "trn": trnController.text.trim(),
  //   };
  //   var response = await http.post(Uri.parse(registrationUrl), body: body);

  //   if (response.statusCode == 200) {
  //     var result = await jsonDecode(response.body);
  //     if (result == 'success') {
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => RegistrationSuccess(
  //               mobileNumber: mobileNumberController.text.trim(),
  //               password: passwordController.text.trim(),
  //             ),
  //           ),
  //           (route) => false);
  //     } else if (result == 'failed') {
  //       Navigator.of(context).pop();
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(
  //           "Failed to register",
  //           style: snackbarTextStyle,
  //         ),
  //         backgroundColor: Colors.red,
  //       ));
  //     } else {
  //       Navigator.of(context).pop();
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(
  //           result,
  //           style: snackbarTextStyle,
  //         ),
  //         backgroundColor: Colors.red,
  //       ));
  //     }

  //     //  print(result);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(
  //         "Network Error",
  //         style: snackbarTextStyle,
  //       ),
  //       backgroundColor: Colors.red,
  //     ));
  //   }
  // }
}

// File _imageFile;
//   String base64Image;
//   final ImagePicker _picker = ImagePicker();

//   String uploadURL2 = hotelBaseUri + 'user_profile_upload';

//   void _pickImage(BuildContext context) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//       base64Image = base64Encode(_imageFile.readAsBytesSync());
//       String fileName = _imageFile.path.split('/').last;
//       upload(fileName, context);
//     } catch (e) {
//       debugPrint("Image picker error " + e.toString());
//     }
//   }

// void upload(String fileName, BuildContext context) {
//   http.post(Uri.parse(uploadURL2), body: {
//     "image": base64Image,
//     "name": fileName,
//     "user_id": userDetails['user_id'],
//   }).then((result) async {
//     if (result.statusCode == 200) {
//       // debugPrint(result.body.toString());
//       var imageName = jsonDecode(result.body);
//       CustomSnackBar.show(context, 'Profile picture updated');
//       setState(() {
//         userDetails['profile_pic'] = imageName;
//       });
//     } else {
//       debugPrint('error');
//       CustomSnackBar.show(context, 'try again later');
//     }
//   }).catchError((e) {
//     debugPrint(e.toString());
//     CustomSnackBar.show(context, 'try again later');
//   });
// }
