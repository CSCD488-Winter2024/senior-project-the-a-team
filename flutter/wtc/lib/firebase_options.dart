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
    apiKey: 'AIzaSyCLM5TWXmefBmJALuRQh60xlzk8A8j4rF0',
    appId: '1:520311768806:web:ad3391560ae715fabe9d27',
    messagingSenderId: '520311768806',
    projectId: 'welcometocheney-77d11',
    authDomain: 'welcometocheney-77d11.firebaseapp.com',
    storageBucket: 'welcometocheney-77d11.appspot.com',
    measurementId: 'G-Q8124GZB5Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJ2ykB9EVfy58kbcrcKGTQ0YGaMSDnMuc',
    appId: '1:520311768806:android:2a4aef921dd7901ebe9d27',
    messagingSenderId: '520311768806',
    projectId: 'welcometocheney-77d11',
    storageBucket: 'welcometocheney-77d11.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMhxLTO9ZuOZEo6ViqqpQqtQFT6xXukPY',
    appId: '1:520311768806:ios:1d46d63d58002a1abe9d27',
    messagingSenderId: '520311768806',
    projectId: 'welcometocheney-77d11',
    storageBucket: 'welcometocheney-77d11.appspot.com',
    iosBundleId: 'com.example.wtc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMhxLTO9ZuOZEo6ViqqpQqtQFT6xXukPY',
    appId: '1:520311768806:ios:1d46d63d58002a1abe9d27',
    messagingSenderId: '520311768806',
    projectId: 'welcometocheney-77d11',
    storageBucket: 'welcometocheney-77d11.appspot.com',
    iosBundleId: 'com.example.wtc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCLM5TWXmefBmJALuRQh60xlzk8A8j4rF0',
    appId: '1:520311768806:web:826659f2f0f1b9c6be9d27',
    messagingSenderId: '520311768806',
    projectId: 'welcometocheney-77d11',
    authDomain: 'welcometocheney-77d11.firebaseapp.com',
    storageBucket: 'welcometocheney-77d11.appspot.com',
    measurementId: 'G-GB6PXL3Y30',
  );
}
