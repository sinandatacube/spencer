import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:spencer/screens/product_details.dart';

class DynamicLinkService {
  Future<String> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data!.link;
      var id = deepLink.toString().split("--");
      log(id.toString());
      log(deepLink.toString());
      log(data.toString());
      if (id.isNotEmpty) {
        return id[1];
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => Product(
        //           productId: id[1],
        //         )));
      }
      // if (deepLink != null) {
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (context) => HomePage()));
      // }

      // FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestScreen()));
      // });
      return "";
    } catch (e) {
      // print(e.toString());
    }
    return "";
  }

  ///createDynamicLink()
}
