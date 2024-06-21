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
    apiKey: 'AIzaSyBPSTlfLB-DsaUPrbIE4vVluTcjx-52CTE',
    appId: '1:393719835330:android:41e6d226ea87b29755a95b',
    messagingSenderId: '393719835330',
    projectId: 'app-marketing-e876d',
    storageBucket: 'app-marketing-e876d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCp0yiS_U3wcuh-ertRESxv-nb44fGSY1M',
    appId: '1:393719835330:ios:7ac08ee1de94d17555a95b',
    messagingSenderId: '393719835330',
    projectId: 'app-marketing-e876d',
    storageBucket: 'app-marketing-e876d.appspot.com',
    androidClientId: '393719835330-6m2b54l936475uiqr8rtbak10m06uk7m.apps.googleusercontent.com',
    iosClientId: '393719835330-alrdb0440jotentab52k5mu3ce4kh64m.apps.googleusercontent.com',
    iosBundleId: 'com.millenium.ganhardinheiro',
  );

}