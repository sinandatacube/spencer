import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spencer/screens/product_details.dart';
import 'package:spencer/screens/support.dart';

import '../screens/home_page.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    print("routesss");
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/homepage':
        return CupertinoPageRoute(builder: (_) {
          return const Support();
        });

      case "/productpage":
        if (args is Map) {
          return CupertinoPageRoute(builder: (_) {
            return Product(
              productId: args["productId"],
            );
          });
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}
