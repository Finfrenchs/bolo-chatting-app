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
        return macos;
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
    apiKey: 'AIzaSyAy5FKTqq7qEq6D3x08Y6ANkINUp9_bs1U',
    appId: '1:953171522720:web:de22325e4e3f12369e45c5',
    messagingSenderId: '953171522720',
    projectId: 'chat-app-firebase-e369a',
    authDomain: 'chat-app-firebase-e369a.firebaseapp.com',
    storageBucket: 'chat-app-firebase-e369a.appspot.com',
    measurementId: 'G-4B32D9D3X5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQf5qQRmyFPqgkjNPz6V7thGsd1zAS2Ms',
    appId: '1:953171522720:android:b5ea14a19fb009b39e45c5',
    messagingSenderId: '953171522720',
    projectId: 'chat-app-firebase-e369a',
    storageBucket: 'chat-app-firebase-e369a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsyAGtbU2O37Xjaz5FDQZxcZW2HhJKIE4',
    appId: '1:953171522720:ios:9e2d5c1ce5f24bf09e45c5',
    messagingSenderId: '953171522720',
    projectId: 'chat-app-firebase-e369a',
    storageBucket: 'chat-app-firebase-e369a.appspot.com',
    iosBundleId: 'com.example.chatAppFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCsyAGtbU2O37Xjaz5FDQZxcZW2HhJKIE4',
    appId: '1:953171522720:ios:2d4b0925d06fa9279e45c5',
    messagingSenderId: '953171522720',
    projectId: 'chat-app-firebase-e369a',
    storageBucket: 'chat-app-firebase-e369a.appspot.com',
    iosBundleId: 'com.example.chatAppFirebase.RunnerTests',
  );
}
