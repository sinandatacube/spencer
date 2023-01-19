import 'package:flutter/material.dart';
import 'package:spencer/extra/delete_account.dart';
import 'package:spencer/screens/webview.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Webview(),
                ),
              ),
              leading: const Icon(Icons.security),
              title: const Text("Privacy Policy"),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccountDelete(),
                ),
              ),
              leading: const Icon(Icons.delete),
              title: const Text(
                "Account Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
