import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/web_view_widget.dart';
import 'package:spencer/utilities/functions.dart';
import 'package:spencer/widgets/loading_animation.dart';

class ChatWidget extends StatefulWidget {
  final String email, shopName;
  const ChatWidget({Key? key, required this.email, required this.shopName})
      : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final primaryColor = const Color.fromARGB(255, 25, 118, 210);

  // final username = Get.arguments['name'];

  // final email = Get.arguments['email'];
  //  final email="siankp7740@gmail.com";
  //  final name="sinan";
  @override
  void initState() {
    checkNetwork();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        title: const Text('Chat support'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Tawk(
            directChatLink:
                'https://tawk.to/chat/62e362aa37898912e9602e1c/1g943iqov',
            visitor: TawkVisitor(
              name: widget.shopName,
              email: widget.email,
            ),
            onLoad: () {
              // log(name + 'jbcusdn');
              // log('Tawk! activating');
            },
            onLinkTap: (String url) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WebViewWidget(url: url),
                ),
              );
              log(url);
            },
            placeholder: const LoadingAnimation()

            // Container(
            //   color: Colors.white,
            //   alignment: Alignment.center,
            //   child: CupertinoActivityIndicator(
            //     radius: 20,
            //     color: mainColor,
            //   ),
            //   // Row(
            //   //   mainAxisSize: MainAxisSize.min,
            //   //   children: [
            //   //     Container(
            //   //       height: 30,
            //   //       width: 30,
            //   //       margin: const EdgeInsets.only(right: 12),
            //   //       child: CupertinoActivityIndicator(
            //   //         // strokeWidth: 2.5,
            //   //         color: white,
            //   //       ),
            //   //     ),
            //   //     const Text("Please wait..."),
            //   //   ],
            //   // ),
            // ),
            ),
      ),
    );
  }
}

//how to insert make a function for adding subtotal and nettotal ?             
