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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAZLqToODzbWSZRrjGjYwd-OvXilPB1PXE',
    appId: '1:334278581961:web:99fa6517e5fa8e1e387718',
    messagingSenderId: '334278581961',
    projectId: 'gabriel-coach-c7e30',
    authDomain: 'gabriel-coach-c7e30.firebaseapp.com',
    storageBucket: 'gabriel-coach-c7e30.appspot.com',
    measurementId: 'G-VRLWKGDTQT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4Iicx91SxX3hbMcgAr7RPwrh8ZjwcaLU',
    appId: '1:334278581961:android:04a4812f1f479763387718',
    messagingSenderId: '334278581961',
    projectId: 'gabriel-coach-c7e30',
    storageBucket: 'gabriel-coach-c7e30.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfMYquGVoGsQRoDiVtXqQeeOFm57M_gOY',
    appId: '1:334278581961:ios:3b543b079811905b387718',
    messagingSenderId: '334278581961',
    projectId: 'gabriel-coach-c7e30',
    storageBucket: 'gabriel-coach-c7e30.appspot.com',
    iosBundleId: 'com.gabrielcoach.app',
  );
}