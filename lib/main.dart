import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spencer/firebase_options.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/login.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/product_details.dart';
import 'package:spencer/states/bulk_description_visibility_provider.dart';
import 'package:spencer/states/bulk_provider.dart';
import 'package:spencer/states/cart_counter.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/dynamic%20links/dynamic_link.dart';
import 'package:spencer/utilities/functions.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'db_service/db_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await NotificationService().requestIOSPermissions(); //

  DB database = DB();
  await database.dbInit();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartCounter()),
    ChangeNotifierProvider(create: (_) => BulkDescriptionProvider()),
    ChangeNotifierProvider(create: (_) => BulkProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // NotificationManager(selectNotification).initNotification();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      navigatorKey: navigatorKey,
      // onGenerateRoute: RouteServices.generateRoute,
      //       routes: <String, WidgetBuilder>{
      //   '/': (BuildContext context) =>const SplashScreen(),
      //   '/productpage': (BuildContext context,) => ProductDetail(productId: ),
      // },
      // routes: {
      //   '/orederDetails': (context) => OrderDetails(),
      //   // "/": (context) => HomePage(),
      // },
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
            backgroundColor: mainColor, foregroundColor: Colors.black),
        fontFamily: "Open Sans",
        backgroundColor: Colors.grey.shade100,
      ),
    );
  }

  // Future selectNotification(
  //   String? payload,
  // ) async {
  //   //Handle notification tapped logic here
  //   // print(" payload is :  " + (payload ?? "0"));
  //   if (payload != null) {
  //     Map params = jsonDecode(payload);
  //     if (params.isNotEmpty) {
  //       String type = params['type'];
  //       String clickId = params['click_id'];
  //       // String sellerType = params['seller_type'] ?? "food";
  //       print(type);
  //       print(clickId);

  //       if (type == "Order") {
  //         navigatorKey.currentState?.push(
  //           MaterialPageRoute(
  //             builder: (_) => OrderDetails(
  //               orderId: clickId,
  //             ),
  //           ),
  //         );
  //       } else {
  //         navigatorKey.currentState?.push(
  //           MaterialPageRoute(
  //             builder: (_) => Product(
  //               productId: clickId,
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  // late Timer _timerLink;

  // @override
  // void initState() {
  //   super.initState();
  //   log("message");
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _dynamicLinkService.retrieveDynamicLink(context);

  //     _timerLink = Timer(
  //       const Duration(milliseconds: 2000),
  //       () {
  //         log("app life");
  //         _dynamicLinkService.retrieveDynamicLink(context);
  //       },
  //     );
  //   }
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   if (_timerLink != null) {
  //     _timerLink.cancel();
  //   }
  //   super.dispose();
  // }

  // Future<void> initDynamicLinks(BuildContext context) async {
  //   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  //   dynamicLinks.onLink.listen((dynamicLinkData) {
  //     final Uri uri = dynamicLinkData.link;
  //     log(uri.toString());
  //     log(dynamicLinkData.toString());
  //     final queryParams = uri.queryParameters;
  //     if (queryParams.isNotEmpty) {
  //       String? productId = queryParams["id"];
  //       Navigator.pushNamed(context, dynamicLinkData.link.path,
  //           arguments: {"productId": int.parse(productId!)});
  //     } else {
  //       Navigator.pushNamed(
  //         context,
  //         dynamicLinkData.link.path,
  //       );
  //     }
  //   }).onError((error) {
  //     print('onLink error');
  //     print(error.message);
  //   });
  // }

  late SharedPreferences prefss;
  @override
  void initState() {
    log("message");

    WidgetsBinding.instance.addObserver(this);

    // initDynamicLinks(context);
    Timer(const Duration(seconds: 3), () async {
      prefss = await SharedPreferences.getInstance();
      checkNetwork();

      Future.delayed(const Duration(seconds: 1), () async {
        if (isConnected == "true") {
          var route = await checkIsLoggedIn();

          if (route == "failed") {
            isSkip = false;

            String id = await _dynamicLinkService.retrieveDynamicLink(context);

            //routing accoording to dynamic link
            if (id.isNotEmpty) {
              isSkip = true;

              log(isSkip.toString(), name: "mainn3");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Product(
                  productId: id,
                ),
              ));
            } else {
              dynamicLinkRouting(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                  (route) => false);
            }
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //       builder: (context) => const Login(),
            //     ),
            //     (route) => false);
          } else if (route == "success") {
            isSkip = false;
            // dynamicLinkRouting(context);
            // get id from dynamic link
            String id = await _dynamicLinkService.retrieveDynamicLink(context);
            //routing accoording to dynamic link
            if (id.isNotEmpty) {
              log(id, name: "mainn");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Product(
                  productId: id,
                ),
              ));
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
            }
          }
        } else if (isConnected == "false") {
          //if no network
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const NoNetwork(),
              ),
              (route) => false);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.2),
            Image.asset("assets/images/logo.png",
                height: height * 0.4, width: width * 0.5),
            SizedBox(
              height: height * 0.3,
              child: Center(
                child: LoadingAnimationWidget.hexagonDots(
                  color: const Color(0xff157694),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

checkIsLoggedIn() async {
  String status = "failed";
  var sp = await SharedPreferences.getInstance();
  var result = sp.getString("shopId") ?? "";
  log(result.toString());

  if (result.isEmpty) {
    status = "failed";
  } else {
    status = "success";
  }

  return status;
}
