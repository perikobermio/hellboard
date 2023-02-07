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
    apiKey: 'AIzaSyCw9bw-hzKQgtskdffxrE81FxKQPfFAgtE',
    appId: '1:628604627836:web:de3a76d7b125286d3792f9',
    messagingSenderId: '628604627836',
    projectId: 'hellboard',
    authDomain: 'hellboard.firebaseapp.com',
    storageBucket: 'hellboard.appspot.com',
    measurementId: 'G-BV2MRTXJVD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7U7Kim_yLs9k7sZMk31JxH6NLrnewuOw',
    appId: '1:628604627836:android:f6fd804efd04c9fe3792f9',
    messagingSenderId: '628604627836',
    projectId: 'hellboard',
    storageBucket: 'hellboard.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2PehqHMWXZ8gskvO7PzIqiDXrJujk4_A',
    appId: '1:628604627836:ios:48f8bdbc194c04263792f9',
    messagingSenderId: '628604627836',
    projectId: 'hellboard',
    storageBucket: 'hellboard.appspot.com',
    iosClientId: '628604627836-61sca7mu3n0a1d9ed5k7t63u26jmak87.apps.googleusercontent.com',
    iosBundleId: 'com.example.hellboard',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA2PehqHMWXZ8gskvO7PzIqiDXrJujk4_A',
    appId: '1:628604627836:ios:48f8bdbc194c04263792f9',
    messagingSenderId: '628604627836',
    projectId: 'hellboard',
    storageBucket: 'hellboard.appspot.com',
    iosClientId: '628604627836-61sca7mu3n0a1d9ed5k7t63u26jmak87.apps.googleusercontent.com',
    iosBundleId: 'com.example.hellboard',
  );
}