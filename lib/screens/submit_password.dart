import 'package:flutter/material.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/password_changed.dart';
import 'package:spencer/widgets/loading_animation.dart';

class SubmitPassword extends StatelessWidget {
  final String shopId;
  final String password;
  const SubmitPassword({Key? key, required this.shopId, required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: changePassword(shopId, password),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var result = snapshot.data;
            if (result["status"] == "success") {
              return const PasswordChanged();
            } else {
              return const ErrorPage();
            }
          } else if (snapshot.hasError) {
            var error = snapshot.error;
            if (error == "Socket exception") {
              return const NoNetwork();
            } else {
              return const ErrorPage();
            }
          } else {
            return const LoadingAnimation();
          }
        },
      ),
    );
  }
}
