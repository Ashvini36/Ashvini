import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:scaneats_customer/firebase_options.dart';
import 'package:scaneats_customer/utils/Preferences.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';
import 'package:url_strategy/url_strategy.dart';

import 'main.dart';

export 'main_app.dart' if (dart.library.io) 'main_app.dart' if (dart.library.js_interop) 'main_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FireStoreUtils.getNotificationData();
  await Preferences.initPref();
  setPathUrlStrategy();

  runApp(const MyApp());
}
