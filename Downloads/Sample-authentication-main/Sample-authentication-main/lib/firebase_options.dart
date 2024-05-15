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
    apiKey: 'AIzaSyDQMrNawO1wglCoYxGnm8xodvI-bpeCtNE',
    appId: '1:655717914601:web:f813fa7127b8e497b89d78',
    messagingSenderId: '655717914601',
    projectId: 'apol-29a72',
    authDomain: 'apol-29a72.firebaseapp.com',
    storageBucket: 'apol-29a72.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5cube14VLEt_h9WoevxNK0MdG6Xg60zQ',
    appId: '1:655717914601:android:f592d7b9b51ecbf0b89d78',
    messagingSenderId: '655717914601',
    projectId: 'apol-29a72',
    storageBucket: 'apol-29a72.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGCrNIbxHIoyhvc0n9Z-qHrf6nMVRYRHg',
    appId: '1:655717914601:ios:06284197d998e35eb89d78',
    messagingSenderId: '655717914601',
    projectId: 'apol-29a72',
    storageBucket: 'apol-29a72.appspot.com',
    iosBundleId: 'com.example.sampleAuth',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGCrNIbxHIoyhvc0n9Z-qHrf6nMVRYRHg',
    appId: '1:655717914601:ios:06284197d998e35eb89d78',
    messagingSenderId: '655717914601',
    projectId: 'apol-29a72',
    storageBucket: 'apol-29a72.appspot.com',
    iosBundleId: 'com.example.sampleAuth',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDQMrNawO1wglCoYxGnm8xodvI-bpeCtNE',
    appId: '1:655717914601:web:5640c351a25b9318b89d78',
    messagingSenderId: '655717914601',
    projectId: 'apol-29a72',
    authDomain: 'apol-29a72.firebaseapp.com',
    storageBucket: 'apol-29a72.appspot.com',
  );
}
