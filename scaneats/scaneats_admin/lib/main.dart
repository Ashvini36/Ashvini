import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:scaneats/firebase_options.dart';
import 'package:scaneats/utils/Preferences.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/utils/notification_service.dart';
import 'package:url_strategy/url_strategy.dart';

import 'main.dart';

export 'main_app.dart' if (dart.library.io) 'main_app.dart' if (dart.library.js_interop) 'main_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Preferences.initPref();
  await FireStoreUtils.getNotificationData();
  FirebaseMessaging.onBackgroundMessage(firebaseMessageBackgroundHandle);
  setPathUrlStrategy();
  NotificationService().initInfo();
  runApp(const MyApp());
}
