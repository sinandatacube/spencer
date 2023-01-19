import 'package:flutter/material.dart';
import 'package:spencer/screens/login.dart';
import 'package:spencer/utilities/colors.dart';

class SkippedLoginAlert extends StatelessWidget {
  final bool isBackButtonVisible;
  const SkippedLoginAlert({Key? key, this.isBackButtonVisible = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isBackButtonVisible,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Please Login.. !",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Login()));
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fixedSize: const Size.fromWidth(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
