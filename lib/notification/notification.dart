import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spencer/screens/orders_details.dart';
import 'package:spencer/utilities/global_variables.dart';

import '../screens/product_details.dart';

class NotificationServices {
  //local
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidInitilize =
      const AndroidInitializationSettings('@drawable/ic_stat_name');
  var iOSinitilize = const DarwinInitializationSettings();
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  //fcm
  final firebaseMessaging = FirebaseMessaging.instance;
  late final SharedPreferences? sharedPreferences;

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    initializeSettings();
    await firebaseMessaging.subscribeToTopic("spencer_user");

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        Map notifData = message.data;
        String payload = jsonEncode(notifData);
        showLocalNotif(
          notification.hashCode,
          notification.title ?? "Unknown title",
          notification.body ?? "Unknown description",
          payload,
        );
      }
    });
  }

  //navigate
  void _handleMessage(RemoteMessage message) async {
    if (message.data['type'] == 'Order') {
      // const LoadingAnimation();
      log(message.data.toString());

      String orderId = message.data["click_id"];
      try {
        // Map body = {'order_id': orderId};
        // http.Response response =
        // await http.post(Uri.parse("${path}order_details"), body: body);
        // var result = await jsonDecode(response.body);
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => OrderDetails(
              orderId: orderId,
            ),
          ),
        );
      } catch (e) {
        log('Error $e');
        navigatorKey.currentState?.pop();
      }
    }
    if (message.data['type'] == 'Offer') {
      String productId = message.data["click_id"];
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Product(
            productId: productId,
          ),
        ),
      );
    }
  }

  showLocalNotif(int id, String title, String description, String payload) {
    var androidDetails = const AndroidNotificationDetails(
        "high_importance_channel", "High Importance Channel",
        importance: Importance.max);
    var iSODetails = const DarwinNotificationDetails(
      presentAlert: true, // Required to display a heads up notification
      presentBadge: true,
      presentSound: true,
    );
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iSODetails);
    flutterLocalNotificationsPlugin
        .show(id, title, description, notificationDetails, payload: payload);
  }

  initializeSettings() async {
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin.initialize(
      initilizationsSettings,
      // onSelectNotification: onSelectNotification,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        notificationTapBackground(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) async {
    String? payload = notificationResponse.payload;
    if (payload != null) {
      log('notification_payload: $payload');
      Map data = jsonDecode(payload);
      if (data.isNotEmpty) {
        String clickId = data["click_id"];
        String type = data["type"];
        if (clickId.isNotEmpty && clickId != "0") {
          if (type == "Order") {
            try {
              navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (context) => OrderDetails(orderId: clickId),
                ),
              );
            } catch (e) {
              log('Error $e');
            }
          }

          if (type == "Offer") {
            String id = clickId;
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => Product(productId: id),
              ),
            );
          }
        }
      }
    }
  }
}




































// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:path_provider/path_provider.dart';

// class NotificationService {
//   Function(String?) selectNotification;
//   NotificationManager(this.selectNotification);
//   static final NotificationService _notificationService =
//       NotificationService._internal();

//   factory NotificationService() {
//     return _notificationService;
//   }

//   NotificationService._internal();

//   //instance of FlutterLocalNotificationsPlugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//      //firebase start
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     messaging.subscribeToTopic("user_flutter");
//     // String token = await messaging.getToken() ?? '0';
//     // messaging.getToken().then((value) {
//     //   debugPrint('FCM Token: $value');
//     // });
//     FirebaseMessaging.onMessage.listen((RemoteMessage messege) {
//       sendNotification(messege.notification?.title, messege.notification?.body,
//           jsonEncode(messege.data), messege.notification?.android?.imageUrl);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       selectNotification(jsonEncode(message.data));
//     });

//     //
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');

//     //Initialization Settings for iOS devices
//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );

//     void requestIOSPermissions(
//         FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//       flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );
//       final InitializationSettings initializationSettings =
//           InitializationSettings(
//               android: initializationSettingsAndroid,
//               iOS: initializationSettingsIOS);
//       await flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onSelectNotification: selectNotification
//       );
//     }
//   }
// //   Future selectNotification(String payload) async {
// //     await Navigator.push(
// //       context,
// //       MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
// //     );
// // }
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Future<void> onBackgroundMessage(RemoteMessage message) async {

//   await Firebase.initializeApp();

// }

// class NotificationManager {
//   Function(String?) selectNotification;
//   NotificationManager(this.selectNotification);

//   Future<void> initNotification() async {
//     FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
//     //firebase start
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     messaging.subscribeToTopic("spencer_mob");
//     // String token = await messaging.getToken() ?? '0';
//     // messaging.getToken().then((value) {
//     //   debugPrint('FCM Token: $value');
//     // });
//     FirebaseMessaging.onMessage.listen((RemoteMessage messege) {
//       sendNotification(messege.notification?.title, messege.notification?.body,
//           jsonEncode(messege.data), messege.notification?.android?.imageUrl);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       selectNotification(jsonEncode(message.data));
//     });

//     //Firebase End
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/ic_stat_name');

//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//       onDidReceiveLocalNotification: handlerNotificationReceived,
//     );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS,
//             macOS: null);

//     await FlutterLocalNotificationsPlugin().initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//   }

//   void sendNotification(title, body, payload, image) async {
//     AndroidNotificationDetails androidPlatformChannelSpecifics;
//     // print("image $image");
//     if (image != null && image != '0') {
//       final String largeIconPath =
//           await _downloadAndSaveFile(image, 'largeIcon');
//       final String bigPicturePath =
//           await _downloadAndSaveFile(image, 'bigPicture');
//       final BigPictureStyleInformation bigPictureStyleInformation =
//           BigPictureStyleInformation(
//         FilePathAndroidBitmap(bigPicturePath),
//         hideExpandedLargeIcon: true,
//       );

//       androidPlatformChannelSpecifics = AndroidNotificationDetails(
//           "com.datacubeinfo.spencer", //Required for Android 8.0 or after
//           "Misc", //Required for Android 8.0 or after
//           channelDescription:
//               "Notifications", //Required for Android 8.0 or after
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true,
//           largeIcon: FilePathAndroidBitmap(largeIconPath),
//           styleInformation: bigPictureStyleInformation);
//     } else {
//       androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//           "com.datacubeinfo.spencer", //Required for Android 8.0 or after
//           "Misc", //Required for Android 8.0 or after
//           channelDescription:
//               "Notifications", //Required for Android 8.0 or after
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true);
//     }

//     const IOSNotificationDetails iOSPlatformChannelSpecifics =
//         IOSNotificationDetails(presentAlert: true, presentSound: true);
//     NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//     FlutterLocalNotificationsPlugin()
//         .show(2, title, body, platformChannelSpecifics, payload: payload);
//   }

//   void handlerNotificationReceived(num, str1, str2, str3) {}

//   Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }
// }


  ////////////////////////////////////////
  ///////////////// token ////////////////
  ////////////////////////////////////////

  // saveFCMToken() async {
  //   try {
  //     sharedPreferences = await SharedPreferences.getInstance();
  //     if (ifuser) {
  //       String savedFCM = sharedPreferences?.getString('fcm_token') ?? "";
  //       if (savedFCM.isEmpty) {
  //         firebaseMessaging.getToken().then((value) {
  //           if (value != null) saveTokenServer(value);
  //           log('Token: $value');
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     log('$e');
  //   }
  // }

  // saveTokenServer(String token) async {
  //   Map params = {'user_id': appuserid, 'token': token};
  //   var response =
  //       await http.post(Uri.parse('${path}save_user_token'), body: params);
  //   log("FCM Saved Server : ${response.body}");
  //   if (response.statusCode == 200) {
  //     if (response.body == "true") {
  //       saveTokenLocally(token);
  //     }
  //   }
  // }

  // saveTokenLocally(String token) async {
  //   sharedPreferences ??= await SharedPreferences.getInstance();
  //   sharedPreferences?.setString('fcm_token', token);
  //   log("FCM Saved Locally : $token");
  // }
// }
