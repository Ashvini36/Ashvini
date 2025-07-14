import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scaneats/app/ui/dashboard_screen.dart';
import 'package:scaneats/firebase_options.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/common_ui.dart';

Future<void> firebaseMessageBackgroundHandle(RemoteMessage message) async {
  log("BackGround Message :: ${message.messageId}");
}

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initInfo() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    var request = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (request.authorizationStatus == AuthorizationStatus.authorized || request.authorizationStatus == AuthorizationStatus.provisional) {
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      var iosInitializationSettings = const DarwinInitializationSettings();
      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: iosInitializationSettings);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (payload) {});
      setupInteractedMessage();
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      FirebaseMessaging.onBackgroundMessage((message) => firebaseMessageBackgroundHandle(message));
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("::::::::::::onMessage:::::::::::::::::");
      if (message.notification != null) {
        log(message.notification.toString());
        if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
          await FireStoreUtils.getOrderById(message.data['orderId']).then((value) {
            if (value != null) {
              log(value.toJson().toString());
              CommonUI.newOrderDialog(scaffoldHomeKey.currentContext!, isDarkTheme: false, orderModel: value);
            }
          });
        } else {
          display(message);
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log("::::::::::::onMessageOpenedApp:::::::::::::::::");
      if (message.notification != null) {
        log(message.notification.toString());
      }
    });
    log("::::::::::::Permission authorized:::::::::::::::::");
    // await FirebaseMessaging.instance.subscribeToTopic("customer");
  }

  static getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  void display(RemoteMessage message) async {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.notification!.body.toString()}');
    try {
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        '0',
        'scan-eat',
        description: 'Show scan-eat Notification',
        importance: Importance.max,
      );
      AndroidNotificationDetails notificationDetails = AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: 'your channel Description', importance: Importance.high, priority: Priority.high, ticker: 'ticker');
      const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
      NotificationDetails notificationDetailsBoth = NotificationDetails(android: notificationDetails, iOS: darwinNotificationDetails);
      await FlutterLocalNotificationsPlugin().show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetailsBoth,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:scaneats/app/ui/dashboard_screen.dart';
// import 'package:scaneats/firebase_options.dart';
// import 'package:scaneats/utils/fire_store_utils.dart';
// import 'package:scaneats/widgets/common_ui.dart';

// Future<void> firebaseMessageBackgroundHandle(RemoteMessage message) async {
//   log("BackGround Message :: ${message.messageId}");
// }

// class NotificationService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   initInfo() async {
//     await FireStoreUtils.getNotificationData();

//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     var request = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (request.authorizationStatus == AuthorizationStatus.authorized || request.authorizationStatus == AuthorizationStatus.provisional) {
//       const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//       var iosInitializationSettings = const DarwinInitializationSettings();
//       final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: iosInitializationSettings);
//       await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (payload) {});
//       setupInteractedMessage();
//     }
//   }

//   Future<void> setupInteractedMessage() async {
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       FirebaseMessaging.onBackgroundMessage((message) => firebaseMessageBackgroundHandle(message));
//     }

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       log("::::::::::::onMessage:::::::::::::::::");
//       log(message.data.toString());
//       if (message.notification != null) {
//         if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
//           await FireStoreUtils.getOrderById(message.data['orderId']).then((value) {
//             if (value != null) {
//               log(value.toJson().toString());
//               CommonUI.newOrderDialog(scaffoldHomeKey.currentContext!, isDarkTheme: false, orderModel: value);
//             }
//           });
//         } else {
//           display(message);
//         }
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       log("::::::::::::onMessageOpenedApp:::::::::::::::::");
//     });
//   }

//   static getToken() async {
//     String? token = await FirebaseMessaging.instance.getToken();

//     if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
//       token = await FirebaseMessaging.instance.getToken(
//         vapidKey: "BAy1Uuu0hzb1UyX5BGRvremRD64m8S-5rZRwg9TZeDK5ocK3XzGmEhxRqSa5h9toRH46TZgHIbxsqRRrFNUTV1w",
//       );
//     } else {
//       token = await FirebaseMessaging.instance.getToken();
//     }
//     return token!;
//   }

//   void display(RemoteMessage message) async {
//     log('Got a message whilst in the foreground!');
//     log('Message data: ${message.notification!.body.toString()}');
//     try {
//       AndroidNotificationChannel channel = const AndroidNotificationChannel(
//         '0',
//         'scan-eat',
//         description: 'Show scan-eat Notification',
//         importance: Importance.max,
//       );
//       AndroidNotificationDetails notificationDetails =
//           AndroidNotificationDetails(channel.id, channel.name, channelDescription: 'scan-eat', importance: Importance.high, priority: Priority.high, ticker: 'ticker');
//       const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
//       NotificationDetails notificationDetailsBoth = NotificationDetails(android: notificationDetails, iOS: darwinNotificationDetails);
//       await FlutterLocalNotificationsPlugin().show(
//         0,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetailsBoth,
//         payload: jsonEncode(message.data),
//       );
//     } on Exception catch (e) {
//       log(e.toString());
//     }
//   }
// }
