// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKRan7eD3W8Kmsh_4XoJXrlKpCxKWtDmY',
    appId: '1:527452785533:android:d04f7c04f0a38e93f95a14',
    messagingSenderId: '527452785533',
    projectId: 'cabme-1b117',
    storageBucket: 'cabme-1b117.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDq418XeW9y_kKd1WhbnMb1EYm-kRcvetM',
    appId: '1:527452785533:ios:b3b00f6578e526f5f95a14',
    messagingSenderId: '527452785533',
    projectId: 'cabme-1b117',
    storageBucket: 'cabme-1b117.appspot.com',
    androidClientId: '527452785533-2edrgcd3depj6nc35git9jtoue6eohvc.apps.googleusercontent.com',
    iosClientId: '527452785533-q2lo3auir6juaei1dq5far9kp2f8ogus.apps.googleusercontent.com',
    iosBundleId: 'com.cabme.driver.ios',
  );
}
