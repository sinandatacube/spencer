import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:spencer/main.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';

GlobalKey<FormState> _fkey = GlobalKey<FormState>();

class AccountDelete extends StatelessWidget {
  const AccountDelete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Account Delete'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 40,
            ),
            const SizedBox(height: 30),
            const Text(
              "By closing account you will lose all of your data from Spencer, you no longer have access to your account and it can't be recovered.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController psswcntr = TextEditingController();
                    return AlertDialog(
                      content: Form(
                        key: _fkey,
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                  'To delete account, enter your password'),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: psswcntr,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Required !!';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  filled: true,
                                  hintText: 'Password',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: mainColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            String userId = prefs.getString('shopId') ?? "0";
                            String userSavedPass =
                                prefs.getString("pass") ?? "";

                            String userTypedPass = psswcntr.text;

                            if (userSavedPass.isNotEmpty &&
                                userSavedPass == userTypedPass) {
                              //request to delete
                              Map params = {"shop_id": userId};
                              try {
                                var response = await http.post(
                                    Uri.parse(baseUrl + "delete_account"),
                                    body: params);
                                log(response.body);
                                var result = jsonDecode(response.body);

                                if (result) {
                                  //deleted
                                  isSkip = true;
                                  await prefs.setString('shopId', "");
                                  await prefs.setString('pass', "");

                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const SplashScreen(),
                                      ),
                                      (route) => false);

                                  //
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Failed, please try again later");
                                }
                              } catch (e) {
                                log(e.toString());
                                Fluttertoast.showToast(
                                    msg: "Failed, please try again later");
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Enter correct password");
                            }
                          },
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text(
                'DELETE MY ACCOUNT',
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding txt(txt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          circle(),
          Expanded(
            child: Text(
              txt,
              // textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Container circle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 10,
      width: 10,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
    );
  }

  delete(name, psw) async {
    // var res = await AuthService().delete(name: name, psw: psw);
    // switch (res) {
    //   case 'OK':
    //     await Pref().clearSetStart();
    //     Get.offAllNamed('/splash');
    //     break;
    //   case 'networkerror':
    //     Fluttertoast.showToast(
    //       msg: 'Network error occured !! please check your connection',
    //       gravity: ToastGravity.CENTER,
    //     );
    //     break;
    //   case 'error':
    //     Fluttertoast.showToast(
    //       msg: 'Some error occured !! please try again !!',
    //       gravity: ToastGravity.CENTER,
    //     );
    //     break;
    //   case 'NOT EXITS':
    //     Fluttertoast.showToast(
    //       msg: ' NOT EXITS !!',
    //       gravity: ToastGravity.CENTER,
    //     );
    //     break;
    //   default:
    //     Fluttertoast.showToast(
    //       msg: 'Some error occured !! please try again !!',
    //       gravity: ToastGravity.CENTER,
    //     );
    // }
  }
}
