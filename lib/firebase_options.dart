// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyA8YmuTC-Hhor5iklRnnJUSCqLYXco7R08',
    appId: '1:390889975374:android:7c8e15b4aa3eb98e0b9d1f',
    messagingSenderId: '390889975374',
    projectId: 'ecib-bc0d3',
    storageBucket: 'ecib-bc0d3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpDM_5kb8utwGKbUv6Q1pg08SYrJRcG7I',
    appId: '1:390889975374:ios:2c6b82ba41662b370b9d1f',
    messagingSenderId: '390889975374',
    projectId: 'ecib-bc0d3',
    storageBucket: 'ecib-bc0d3.appspot.com',
    androidClientId:
        '390889975374-r06at5m1cm3019sa6licgo5gslf6vt20.apps.googleusercontent.com',
    iosClientId:
        '390889975374-b0e1v1n580jui353o8oc619viln33nkm.apps.googleusercontent.com',
    iosBundleId: 'com.example.ecib',
  );
}