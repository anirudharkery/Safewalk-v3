// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCuoticzbnymFbaw6w5-sEHnW1_sXVpIww',
    appId: '1:851353634533:web:b8190bd739d21fa177f60c',
    messagingSenderId: '851353634533',
    projectId: 'safe-walk-v3',
    authDomain: 'safe-walk-v3.firebaseapp.com',
    databaseURL: 'https://safe-walk-v3-default-rtdb.firebaseio.com',
    storageBucket: 'safe-walk-v3.appspot.com',
    measurementId: 'G-5HNLTMZL69',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSXzUdHk0_P35OR1R8wyYhR6SUMlIySec',
    appId: '1:851353634533:android:2b748a56c25c843677f60c',
    messagingSenderId: '851353634533',
    projectId: 'safe-walk-v3',
    databaseURL: 'https://safe-walk-v3-default-rtdb.firebaseio.com',
    storageBucket: 'safe-walk-v3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8Tomu4t0JOSnzntvWwhNfq7UGDmMNzfQ',
    appId: '1:851353634533:ios:a322f299f41e4bae77f60c',
    messagingSenderId: '851353634533',
    projectId: 'safe-walk-v3',
    databaseURL: 'https://safe-walk-v3-default-rtdb.firebaseio.com',
    storageBucket: 'safe-walk-v3.appspot.com',
    iosBundleId: 'com.example.safewalk',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB8Tomu4t0JOSnzntvWwhNfq7UGDmMNzfQ',
    appId: '1:851353634533:ios:a322f299f41e4bae77f60c',
    messagingSenderId: '851353634533',
    projectId: 'safe-walk-v3',
    databaseURL: 'https://safe-walk-v3-default-rtdb.firebaseio.com',
    storageBucket: 'safe-walk-v3.appspot.com',
    iosBundleId: 'com.example.safewalk',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCuoticzbnymFbaw6w5-sEHnW1_sXVpIww',
    appId: '1:851353634533:web:4a5455581535cf8c77f60c',
    messagingSenderId: '851353634533',
    projectId: 'safe-walk-v3',
    authDomain: 'safe-walk-v3.firebaseapp.com',
    databaseURL: 'https://safe-walk-v3-default-rtdb.firebaseio.com',
    storageBucket: 'safe-walk-v3.appspot.com',
    measurementId: 'G-77P2T102QC',
  );
}
