import 'package:flutter/material.dart';
import 'package:spencer/screens/chat.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/global_variables.dart';

class FetchCustomerDetails extends StatelessWidget {
  FetchCustomerDetails({Key? key}) : super(key: key);
  TextEditingController shopName = TextEditingController();
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Details"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(width * 0.1),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              TextField(
                controller: shopName,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Shop name",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.grey.shade600)),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              TextField(
                controller: email,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Email",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.grey.shade600)),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  onPressed: () {
                    String error = "";
                    var _email = email.text.trim();
                    var _shopName = shopName.text.trim();
                    if (_shopName.isEmpty) {
                      error = "Enter shop name";
                    } else if (_email.isEmpty) {
                      error = "Enter email";
                    } else if (_email.isNotEmpty) {
                      bool emailValid = RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                          .hasMatch(_email);
                      if (emailValid == false) {
                        error = "Enter a valid email";
                      }
                    }

                    if (error != "") {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          error,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red.shade600,
                      ));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ChatWidget(email: _email, shopName: _shopName)));
                    }
                  },
                  child: Text(
                    "Chat",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ))
            ],
          ),
        )));
  }
}
